# AI CLI Kickstarter

给完全不懂计算机的人安装第一个 AI CLI，然后由这个 AI 接管后续指导。

## 支持

- Qwen Code
- Kimi Code
- CodeBuddy CLI
- macOS
- Linux
- Windows
- 中文 / English

## 使用

### macOS

解压后双击 `Start-macOS.command`。若 macOS 阻止运行，右键文件并选择“打开”。

### Linux

打开终端，在本目录运行：

```bash
bash Start-Linux.sh
```

### Windows

双击 `Start-Windows.cmd`。它会启动 PowerShell 状态机。

## 状态机

`LANGUAGE → PROBE → SELECT → PRECHECK → CONFIRM → INSTALL → VERIFY → HANDOFF`

失败时进入 `ERROR`，用户可以重试、换工具或退出。

## 网络检测

启动器请求：

`https://www.google.com/generate_204`

它只判断当前 Terminal/PowerShell 是否能直接连接 Google，不推断用户所在地，也不推断其他国际服务是否可用。

## 安装来源

- Qwen Code：官方 standalone installer
- Kimi Code：官方 installer
- CodeBuddy CLI：官方 native installer（当前官方文档标注 Beta）

安装器会在执行前显示下载地址。供应商可能更新安装方式，因此发布前应重新核对官方文档。
