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

若出现「Windows 已保护你的电脑」（SmartScreen）提示，点击「更多信息」，再点击「仍要运行」。这是 Windows 对从网上下载的文件的常规提醒。

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

信任模型：本工具会下载并执行上述三家官方域名提供的安装脚本，运行安装即表示信任这些来源。启动器不会自行校验脚本内容，但会在执行前显示下载地址并要求确认。

## 开发

- 运行测试：`bash tests/run-tests.sh`（使用本地 curl 桩，不访问网络）
- Lint：`shellcheck kickstarter.sh Start-Linux.sh Start-macOS.command`
- CI（GitHub Actions）在每次 push 时运行 shellcheck、PSScriptAnalyzer 与冒烟测试
- `kickstarter.sh` 与 `kickstarter.ps1` 互为镜像，修改状态或文案时需要同步两个文件

## 许可证

MIT，见 [LICENSE](LICENSE)。
