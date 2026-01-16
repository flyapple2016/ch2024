# nano11 🔬  
一个用于构建更加精简版 Windows 11 镜像的 PowerShell 脚本。

## 简介

隆重推出 **nano11 构建器** —— 一个用于创建更小体积 Windows 11 镜像的 PowerShell 脚本！

**nano11** 的目标是自动化构建一个高度精简的 Windows 11 镜像。该脚本仅使用系统内置的 DISM 功能和官方的 `oscdimg.exe`（会自动下载），无需任何第三方二进制文件，即可生成可启动的 ISO 镜像。脚本中包含了一个无人值守应答文件（unattend.xml），可在安装过程中跳过微软账户（Microsoft Account）强制登录，并默认启用紧凑型安装（compact installation）。

本项目为开源项目，欢迎根据你的需求自由修改和适配！同时，也非常欢迎你的反馈！

> ☢️ **开始前请注意：**  
> 这是一个极端实验性质的脚本，专为快速搭建开发测试环境而设计。它会尽可能移除所有组件，包括 Windows 组件存储（WinSxS）、核心系统服务等。  
>  
> **生成的操作系统将无法再进行维护**。这意味着你无法添加语言包、驱动程序或功能组件，也无法接收 Windows 更新。此镜像仅适用于虚拟机中的测试、开发或嵌入式场景，要求系统为最小化且静态不变的环境。

## 移除了哪些内容？

`nano11.ps1` 脚本非常激进，移除了以下内容：

- **所有预装臃肿应用**：如 Clipchamp、新闻、天气、Xbox、Office Hub、纸牌游戏等。
- **核心系统组件**：
  - ⛔ Windows 组件存储（WinSxS）
  - ⛔ Windows Update（及其相关服务）
  - ⛔ Windows Defender（及其相关服务）
  - ⛔ 大部分驱动程序（仅保留 VGA、网络和存储驱动）
  - ⛔ 所有输入法（IME，不支持亚洲语言）
  - ⛔ 搜索、BitLocker、生物识别、无障碍功能
  - ⛔ 大多数系统服务（包括音频服务）
- **其他组件**：
  - Microsoft Edge 与 OneDrive
  - Internet Explorer 与 Tablet PC 数学识别功能

> ⚠️ **重要提示**：使用此脚本生成的镜像**无法再添加任何功能或语言包**！

## 使用说明
1. 从微软官网下载 Windows 11 镜像。
2. 右键点击下载的 ISO 文件，选择“挂载”（Mount），并记下分配的盘符。
3. 以管理员身份打开 PowerShell。
4. 为当前会话设置执行策略：
   Set-ExecutionPolicy Bypass -Scope Process
5. 进入脚本所在目录并运行：
   C:\path\to\your\nano11\nano11.ps1
6. 按提示操作：脚本会询问你挂载镜像的盘符以及要基于的版本（SKU）。
7. 坐等完成！完成后，新的 ISO 镜像将保存在脚本所在目录。
最终你将获得一个体积比标准 Windows 11 镜像小至多 3 倍的超精简系统！

## 预构建镜像下载
你可以直接下载演示视频中使用的预构建镜像：  
👉 [archive.org 下载链接](https://archive.org/details/nano11_25h2)