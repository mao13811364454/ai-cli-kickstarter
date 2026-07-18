# AI CLI Kickstarter — Windows PowerShell
$ErrorActionPreference = "Stop"
$Version = "0.1.0"
$State = "LANGUAGE"
$Language = ""
$GoogleStatus = "unknown"
$ProviderName = ""
$CommandName = ""
$InstallUrl = ""
$LastError = ""

function T([string]$Key) {
    $zh = @{
        title="AI CLI 启动器"; choose_language="请选择语言 / Choose your language";
        probing="正在检测 PowerShell 是否能直接访问 Google……";
        reachable="可以直接访问 Google。"; unreachable="无法直接访问 Google。";
        unknown="无法可靠判断 Google 是否可访问。";
        network_note="该结果只代表当前 PowerShell 对 Google 的连接，不判断地理位置。";
        choose="请选择一个 Kickstarter："; default="直接按 Enter 选择 Qwen Code，或输入 1–3";
        qwen="中国大陆友好；官方独立安装器"; kimi="中国大陆友好；首次启动后输入 /login";
        buddy="腾讯生态；官方原生安装器目前为 Beta";
        checking="正在执行安装前检查……"; ready="即将安装"; confirm="继续？[Y/n]";
        installing="正在运行官方安装器……"; verifying="正在验证……"; success="安装成功。";
        not_found="安装器已结束，但当前 PowerShell 尚未找到命令。请重新打开 PowerShell 后再运行。";
        launch="现在启动？[Y/n]"; failed="安装失败"; retry="[1] 重试  [2] 换一个工具  [3] 退出";
        exit="按 Enter 退出"
    }
    $en = @{
        title="AI CLI Kickstarter"; choose_language="请选择语言 / Choose your language";
        probing="Testing whether PowerShell can reach Google directly...";
        reachable="Google is directly reachable."; unreachable="Google is not directly reachable.";
        unknown="Google reachability could not be determined reliably.";
        network_note="This only tests PowerShell access to Google; it does not infer location.";
        choose="Choose a kickstarter:"; default="Press Enter for Qwen Code, or enter 1–3";
        qwen="Mainland-China friendly; official standalone installer";
        kimi="Mainland-China friendly; enter /login after first launch";
        buddy="Tencent ecosystem; official native installer is currently Beta";
        checking="Running pre-installation checks..."; ready="Ready to install"; confirm="Continue? [Y/n]";
        installing="Running the official installer..."; verifying="Verifying..."; success="Installation succeeded.";
        not_found="The installer finished, but the command is not visible yet. Reopen PowerShell and try again.";
        launch="Launch now? [Y/n]"; failed="Installation failed"; retry="[1] Retry  [2] Choose another tool  [3] Exit";
        exit="Press Enter to exit"
    }
    if ($Language -eq "zh") { return $zh[$Key] } else { return $en[$Key] }
}

function Banner {
    Clear-Host
    Write-Host ""
    Write-Host "=== $(T 'title') v$Version ==="
    Write-Host ""
}

function Probe-Google {
    try {
        $r = Invoke-WebRequest -Uri "https://www.google.com/generate_204" -Method Get -TimeoutSec 7 -MaximumRedirection 2 -UseBasicParsing
        if ($r.StatusCode -eq 204) { $script:GoogleStatus = "reachable" }
        else { $script:GoogleStatus = "unknown" }
    } catch {
        $script:GoogleStatus = "unreachable"
    }
}

function Select-Provider([string]$Choice) {
    switch ($Choice) {
        "1" { $script:ProviderName="Qwen Code"; $script:CommandName="qwen"; $script:InstallUrl="https://qwen-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-qwen-standalone.ps1" }
        "2" { $script:ProviderName="Kimi Code"; $script:CommandName="kimi"; $script:InstallUrl="https://code.kimi.com/install.ps1" }
        "3" { $script:ProviderName="CodeBuddy CLI"; $script:CommandName="codebuddy"; $script:InstallUrl="https://www.codebuddy.cn/cli/install.ps1" }
    }
}

function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user;$HOME\.local\bin;$HOME\AppData\Local\codebuddy\bin"
}

function Show-Handoff {
    if ($Language -eq "zh") {
@'
我是计算机新手。请作为我的个人 AI 电脑助手。

请遵守：
1. 执行命令前，用通俗语言解释目的。
2. 修改配置文件前先备份。
3. 涉及管理员权限、删除、覆盖、付费或隐私时，先询问我。
4. 每完成一步都验证结果。
5. 对每个在线服务都实际检测可访问性，不要仅根据 Google 的结果推断。
6. 只在必要时教我概念和命令，不要一次塞给我太多知识。

首先，请检查当前电脑环境，并告诉我下一步最值得做什么。
'@ | Write-Host
    } else {
@'
I am a complete beginner. Act as my personal AI computer assistant.

Please follow these rules:
1. Explain the purpose in plain language before running commands.
2. Back up configuration files before changing them.
3. Ask first before administrator access, deletion, overwriting, payment, or privacy-sensitive actions.
4. Verify every completed step.
5. Test each online service directly; do not infer all connectivity from the Google result.
6. Teach concepts and commands only when necessary; do not overwhelm me.

First inspect this computer and tell me the single most valuable next step.
'@ | Write-Host
    }
}

while ($true) {
    switch ($State) {
        "LANGUAGE" {
            Banner
            Write-Host (T "choose_language")
            Write-Host "`n  [1] 中文`n  [2] English`n"
            $c = Read-Host ">"
            if ($c -eq "1") { $Language="zh"; $State="PROBE" }
            elseif ($c -eq "2") { $Language="en"; $State="PROBE" }
        }
        "PROBE" {
            Banner; Write-Host (T "probing"); Probe-Google
            Write-Host "`n$(T $GoogleStatus)"
            Write-Host (T "network_note")
            Start-Sleep -Seconds 1; $State="SELECT"
        }
        "SELECT" {
            Banner
            Write-Host "$(T $GoogleStatus)`n"
            Write-Host (T "choose")
            Write-Host "`n  [1] Qwen Code — $(T 'qwen')"
            Write-Host "`n  [2] Kimi Code — $(T 'kimi')"
            Write-Host "`n  [3] CodeBuddy CLI — $(T 'buddy')`n"
            $c = Read-Host (T "default")
            if ([string]::IsNullOrWhiteSpace($c)) { $c="1" }
            if ($c -in @("1","2","3")) { Select-Provider $c; $State="PRECHECK" }
        }
        "PRECHECK" {
            Banner; Write-Host (T "checking")
            if ($PSVersionTable.PSVersion.Major -lt 5) { $LastError="PowerShell 5 or newer is required"; $State="ERROR" }
            else { $State="CONFIRM" }
        }
        "CONFIRM" {
            Banner
            Write-Host "$(T 'ready'): $ProviderName"
            Write-Host "Google: $GoogleStatus"
            Write-Host "Source: $InstallUrl`n"
            $c=Read-Host (T "confirm")
            if ([string]::IsNullOrWhiteSpace($c) -or $c -match "^(y|yes|是)$") { $State="INSTALL" } else { $State="DONE" }
        }
        "INSTALL" {
            Banner; Write-Host (T "installing")
            try {
                $installer = Invoke-RestMethod -Uri $InstallUrl -TimeoutSec 30
                Invoke-Expression $installer
                $State="VERIFY"
            } catch {
                $LastError=$_.Exception.Message; $State="ERROR"
            }
        }
        "VERIFY" {
            Refresh-Path; Write-Host "`n$(T 'verifying')"
            try {
                $cmd=Get-Command $CommandName -ErrorAction Stop
                & $cmd.Source --version
                Write-Host (T "success")
            } catch {
                Write-Host (T "not_found")
            }
            $State="HANDOFF"
        }
        "HANDOFF" {
            Write-Host ""; Show-Handoff
            $c=Read-Host "`n$(T 'launch')"
            if ([string]::IsNullOrWhiteSpace($c) -or $c -match "^(y|yes|是)$") {
                Refresh-Path
                try { & $CommandName } catch { Write-Host (T "not_found") }
            }
            $State="DONE"
        }
        "ERROR" {
            Write-Host "`n$(T 'failed'): $LastError"
            $c=Read-Host (T "retry")
            if ($c -eq "1") { $State="PRECHECK" }
            elseif ($c -eq "2") { $State="SELECT" }
            elseif ($c -eq "3") { $State="DONE" }
        }
        "DONE" {
            Read-Host (T "exit") | Out-Null
            exit
        }
    }
}
