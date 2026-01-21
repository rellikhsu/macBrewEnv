# macBrewEnv

macOS bash profile environment - 自動化設定 Homebrew 與 bash 開發環境

## 快速開始

```bash
# Clone repository
git clone https://github.com/rellikhsu/macBrewEnv.git
cd macBrewEnv

# 執行安裝腳本
./setup.sh
```

## 功能特色

- ✅ **自動安裝最新版 Homebrew**：使用安全的暫存檔安裝模式，避免 Pipe 執行風險。
- ✅ **常用開發工具**：自動部署 bash, git-prompt, vim, jq 等工具。
- ✅ **強健的錯誤處理**：內建 `trap` 錯誤捕捉與網路重試機制。
- ✅ **自動備份**：安裝前自動備份現有的設定檔 (`.profile`, `.bashrc`, `.vimrc`)。
- ✅ **跨架構支援**：動態偵測 `Homebrew` 路徑，完美支援 **Apple Silicon** (`/opt/homebrew`) 與 **Intel** (`/usr/local`) Mac。

## 包含的配置檔案

- **profile** - Bash profile 設定 (~/.profile)
  - Homebrew 環境初始化
  - GNU 工具優先化
  - PATH 去重機制
  - 支援 Google Cloud SDK（需自行安裝）

- **bashrc** - Bash 執行配置 (~/.bashrc)
  - 自訂命令提示字元
  - Git prompt 整合
  - 豐富的別名設定
  - Bash completion

- **vimrc** - Vim 編輯器配置 (~/.vimrc)
  - 語法高亮
  - 自動縮排
  - UTF-8 編碼
  - 256 色支援

## 安裝的套件

- bash - 最新版 Bash shell
- bash-completion@2 - Bash 自動完成
- bash-git-prompt - Git 狀態提示
- coreutils / findutils - GNU 核心工具
- mtr / httping / gping - 網路診斷工具
- mpv - 多媒體播放器
- jq - JSON 處理工具
- inetutils - 網路工具集

## 詳細說明

請參閱 [SETUP_GUIDE.md](SETUP_GUIDE.md) 獲取完整的安裝指南與使用說明。

## 系統需求

- macOS (支援 Apple Silicon 與 Intel)
- 網路連線
- 管理員權限

## 授權

MIT License
