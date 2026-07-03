#!/usr/bin/env python3
"""
build_firmware.py
Firmware 自包含构建脚本

功能: STEdgeAI 生成模型 -> CubeIDE headless 编译 -> 生成 3 个 HEX 烧录文件
所有路径相对于 Firmware 目录，Firmware 移动到任意位置仍可使用。

用法:
  python build_firmware.py                          # 完整构建 (STEdgeAI + CubeIDE + HEX)
  python build_firmware.py --skip-generate          # 跳过 STEdgeAI，直接编译 + HEX
  python build_firmware.py --hex-only               # 只打包 HEX（需要已有编译产物）
  python build_firmware.py --cubeide /path/to/ide   # 指定 CubeIDE 路径

环境变量（可选，优先级低于命令行参数）:
  CUBEIDE_PATH      STM32CubeIDE 可执行文件路径
  STEDGEAI_PATH     STEdgeAI 可执行文件路径
  GCC_BIN_PATH      GCC 工具链 bin 目录路径
"""
from __future__ import annotations
import argparse
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


# ---------------------------------------------------------------------------
# 路径常量（全部相对于本脚本所在的 Firmware 目录）
# ---------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent          # Firmware/shell
FW = SCRIPT_DIR.parent                                 # Firmware
MODEL_DIR = FW / "Model"
CUBEIDE_DIR = FW / "STM32CubeIDE"
BINARY_DIR = FW / "Binary"

# 默认工具路径（可通过环境变量或命令行参数覆盖）
DEFAULT_CUBEIDE = Path(os.environ.get("CUBEIDE_PATH", r"D:/App/STM32CubeIDE/stm32cubeidec.exe"))
DEFAULT_STEDGE = Path(os.environ.get("STEDGEAI_PATH", r"D:/App/STEdgeAI/2.0/Utilities/windows/stedgeai.exe"))
DEFAULT_GCC_BIN = Path(os.environ.get("GCC_BIN_PATH",
    r"D:/App/STM32CubeIDE/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.12.3.rel1.win32_1.1.0.202410251130/tools/bin"))

# HEX 烧录地址
APPLI_BASE_ADDR = "0x70100400"
NETWORK_DATA_BASE_ADDR = "0x70200000"


# ---------------------------------------------------------------------------
# 工具函数
# ---------------------------------------------------------------------------
def run(cmd: list[str], cwd: Path | None = None, check: bool = True) -> subprocess.CompletedProcess:
    """执行外部命令，打印输出，失败时抛异常。"""
    print(f"[run] {' '.join(cmd)}")
    r = subprocess.run(cmd, cwd=cwd, text=True, capture_output=True)
    if r.stdout:
        print(r.stdout[-2000:] if len(r.stdout) > 2000 else r.stdout)
    if check and r.returncode != 0:
        if r.stderr:
            print(r.stderr, file=sys.stderr)
        raise RuntimeError(f"命令失败 (exit {r.returncode}): {cmd[0]}")
    return r


def find_tool(env_key: str, default: Path, cli_arg: Path | None, tool_name: str) -> Path:
    """按优先级确定工具路径: CLI 参数 > 环境变量 > 默认值。"""
    if cli_arg:
        return cli_arg
    env_val = os.environ.get(env_key)
    if env_val:
        return Path(env_val)
    return default


# ---------------------------------------------------------------------------
# 步骤 1: STEdgeAI 生成模型文件
# ---------------------------------------------------------------------------
def step_generate_model(stedge: Path) -> None:
    """调用 STEdgeAI 从 TFLite 生成 network.c / network_ecblobs.h / network_data.xSPI2.bin。"""
    print("\n" + "=" * 60)
    print("[步骤 1] STEdgeAI 生成 NPU 模型文件")
    print("=" * 60)

    tflite = MODEL_DIR / "yolov8n_steel_int8.tflite"
    if not tflite.exists():
        raise FileNotFoundError(f"找不到 TFLite 模型: {tflite}")

    neuralart = MODEL_DIR / "user_neuralart.json"
    if not neuralart.exists():
        raise FileNotFoundError(f"找不到 neuralart 配置: {neuralart}")

    run([str(stedge), "generate",
         "--no-inputs-allocation", "--no-outputs-allocation",
         "--model", tflite.name,
         "--target", "stm32n6",
         "--st-neural-art", f"default@{neuralart.name}"],
        cwd=MODEL_DIR, check=True)

    # 从 st_ai_output 复制生成文件到 Model 根目录
    out = MODEL_DIR / "st_ai_output"
    for src_name, dst_name in [
        ("network_ecblobs.h", "network_ecblobs.h"),
        ("network.c", "network.c"),
        ("network_atonbuf.xSPI2.raw", "network_data.xSPI2.bin"),
    ]:
        src = out / src_name
        dst = MODEL_DIR / dst_name
        if not src.exists():
            raise FileNotFoundError(f"STEdgeAI 输出缺失: {src}")
        shutil.copy2(src, dst)
        print(f"  复制: {src_name} -> {dst_name} ({dst.stat().st_size / 1024:.1f} KB)")

    print("[完成] 模型文件生成完毕")


# ---------------------------------------------------------------------------
# 步骤 2: CubeIDE headless 编译
# ---------------------------------------------------------------------------
def step_cubeide_build(cubeide: Path) -> None:
    """使用 CubeIDE headless 模式导入并编译 FSBL/Debug 和 Appli/Release。"""
    print("\n" + "=" * 60)
    print("[步骤 2] CubeIDE headless 编译")
    print("=" * 60)

    if not cubeide.exists():
        raise FileNotFoundError(f"找不到 STM32CubeIDE: {cubeide}")

    if not CUBEIDE_DIR.exists():
        raise FileNotFoundError(f"找不到 CubeIDE 项目目录: {CUBEIDE_DIR}")

    # 使用临时目录作为 workspace，避免污染项目
    ws = Path(tempfile.mkdtemp(prefix="cubeide_ws_"))
    print(f"  CubeIDE workspace: {ws}")

    win_path = str(CUBEIDE_DIR).replace("/", "\\")
    print(f"  导入项目: {win_path}")

    # 导入项目
    run([str(cubeide), "--launcher.suppressErrors", "-nosplash",
         "-application", "org.eclipse.cdt.managedbuilder.core.headlessbuild",
         "-data", str(ws),
         "-importAll", win_path], check=False)

    # 编译 FSBL/Debug
    print("\n--- 编译 AI_Steel_Detection_FSBL/Debug ---")
    run([str(cubeide), "--launcher.suppressErrors", "-nosplash",
         "-application", "org.eclipse.cdt.managedbuilder.core.headlessbuild",
         "-data", str(ws),
         "-build", "AI_Steel_Detection_FSBL/Debug"], check=True)

    # 编译 Appli/Release
    print("\n--- 编译 AI_Steel_Detection_Appli/Release ---")
    r = run([str(cubeide), "--launcher.suppressErrors", "-nosplash",
             "-application", "org.eclipse.cdt.managedbuilder.core.headlessbuild",
             "-data", str(ws),
             "-build", "AI_Steel_Detection_Appli/Release"], check=False)

    # 检查编译产物是否存在（允许 postbuild 脚本报错，但 ELF/BIN 必须存在）
    elf = CUBEIDE_DIR / "Appli/Release/AI_Steel_Detection_Appli.elf"
    bin_file = CUBEIDE_DIR / "Appli/Release/AI_Steel_Detection_Appli.bin"
    if not elf.exists() or not bin_file.exists():
        if r.returncode != 0:
            print(r.stderr, file=sys.stderr)
        raise RuntimeError(f"Appli Release 编译失败，找不到产物: {elf} 或 {bin_file}")

    if r.returncode != 0:
        print("[警告] Appli Release postbuild 脚本报错，但 ELF/BIN 已生成，继续打包 HEX")
    else:
        print("[完成] CubeIDE 编译成功")

    # 清理临时 workspace
    try:
        shutil.rmtree(ws, ignore_errors=True)
        print(f"  已清理临时 workspace: {ws}")
    except Exception:
        print(f"  [警告] 临时 workspace 清理失败: {ws}")


# ---------------------------------------------------------------------------
# 步骤 3: 打包 HEX 文件
# ---------------------------------------------------------------------------
def step_pack_hex(gcc_bin: Path) -> None:
    """使用 objcopy 将 BIN 文件转换为 HEX 文件，fsbl.hex 直接使用已有文件。"""
    print("\n" + "=" * 60)
    print("[步骤 3] 打包 HEX 烧录文件")
    print("=" * 60)

    objcopy = gcc_bin / "arm-none-eabi-objcopy.exe"
    if not objcopy.exists():
        raise FileNotFoundError(f"找不到 objcopy: {objcopy}")

    BINARY_DIR.mkdir(parents=True, exist_ok=True)

    # 1) network-data.hex (模型权重 @ 0x70200000)
    network_bin = MODEL_DIR / "network_data.xSPI2.bin"
    if not network_bin.exists():
        raise FileNotFoundError(f"找不到模型权重: {network_bin}")
    print(f"\n  network-data.hex <- {network_bin.name}")
    run([str(objcopy), "-I", "binary",
         str(network_bin),
         "--change-addresses", NETWORK_DATA_BASE_ADDR,
         "-O", "ihex",
         str(BINARY_DIR / "network-data.hex")])

    # 2) appli.hex (应用固件 @ 0x70100400)
    appli_bin = CUBEIDE_DIR / "Appli/Release/AI_Steel_Detection_Appli.bin"
    if not appli_bin.exists():
        raise FileNotFoundError(f"找不到 Appli 编译产物: {appli_bin}")
    print(f"\n  appli.hex <- {appli_bin}")
    run([str(objcopy), "-I", "binary",
         str(appli_bin),
         "--change-addresses", APPLI_BASE_ADDR,
         "-O", "ihex",
         str(BINARY_DIR / "appli.hex")])

    # 3) fsbl.hex (使用已有的，不再依赖外部 SoftwarePackage)
    fsbl_hex = BINARY_DIR / "fsbl.hex"
    if fsbl_hex.exists():
        print(f"\n  fsbl.hex <- 已有文件，保留: {fsbl_hex}")
    else:
        print("\n  [警告] fsbl.hex 不存在！请从官方例程复制:")
        print("    cp <SoftwarePackage>/Projects/99_Applications/991_AI_People_Detection/Binary/fsbl.hex \\")
        print(f"       {fsbl_hex}")

    # 打印结果
    print("\n" + "=" * 60)
    print("[完成] HEX 文件已生成:")
    for name in ("fsbl.hex", "appli.hex", "network-data.hex"):
        p = BINARY_DIR / name
        if p.exists():
            size_kb = p.stat().st_size / 1024
            print(f"  {name:25s} {size_kb:10.1f} KB  -> 烧录地址见 README")
        else:
            print(f"  {name:25s} [缺失]")
    print("=" * 60)


# ---------------------------------------------------------------------------
# 主函数
# ---------------------------------------------------------------------------
def main() -> int:
    parser = argparse.ArgumentParser(
        description="Firmware 自包含构建脚本",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  python build_firmware.py                          # 完整构建
  python build_firmware.py --skip-generate          # 跳过 STEdgeAI
  python build_firmware.py --hex-only               # 只打包 HEX
  python build_firmware.py --cubeide /path/to/ide   # 指定 CubeIDE 路径

环境变量:
  CUBEIDE_PATH      STM32CubeIDE 可执行文件路径
  STEDGEAI_PATH     STEdgeAI 可执行文件路径
  GCC_BIN_PATH      GCC 工具链 bin 目录路径
""")

    parser.add_argument("--cubeide", type=Path, default=None,
                        help="STM32CubeIDE 可执行文件路径")
    parser.add_argument("--stedge", type=Path, default=None,
                        help="STEdgeAI 可执行文件路径")
    parser.add_argument("--gcc-bin", type=Path, default=None,
                        help="GCC 工具链 bin 目录路径")
    parser.add_argument("--skip-generate", action="store_true",
                        help="跳过 STEdgeAI 生成（使用已有的 network.c）")
    parser.add_argument("--hex-only", action="store_true",
                        help="只打包 HEX（需要已有 CubeIDE 编译产物）")

    args = parser.parse_args()

    # 解析工具路径
    cubeide = find_tool("CUBEIDE_PATH", DEFAULT_CUBEIDE, args.cubeide, "STM32CubeIDE")
    stedge = find_tool("STEDGEAI_PATH", DEFAULT_STEDGE, args.stedge, "STEdgeAI")
    gcc_bin = find_tool("GCC_BIN_PATH", DEFAULT_GCC_BIN, args.gcc_bin, "GCC bin")

    # 打印构建信息
    print("=" * 60)
    print("Firmware 自包含构建脚本")
    print("=" * 60)
    print(f"  Firmware 目录: {FW}")
    print(f"  CubeIDE:       {cubeide}")
    print(f"  STEdgeAI:      {stedge}")
    print(f"  GCC bin:       {gcc_bin}")
    print(f"  跳过生成:      {args.skip_generate}")
    print(f"  仅 HEX:        {args.hex_only}")

    try:
        # 步骤 1: STEdgeAI 生成模型（可选）
        if not args.skip_generate and not args.hex_only:
            step_generate_model(stedge)

        # 步骤 2: CubeIDE 编译（可选）
        if not args.hex_only:
            step_cubeide_build(cubeide)

        # 步骤 3: 打包 HEX
        step_pack_hex(gcc_bin)

        print("\n[成功] 构建完成！")
        return 0

    except FileNotFoundError as e:
        print(f"\n[错误] {e}", file=sys.stderr)
        return 1
    except RuntimeError as e:
        print(f"\n[错误] {e}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("\n[中断] 用户取消", file=sys.stderr)
        return 130


if __name__ == "__main__":
    sys.exit(main())
