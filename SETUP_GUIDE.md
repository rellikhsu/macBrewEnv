# macBrewEnv 安裝腳本使用指南

## 概述

`setup.sh` 是一個自動化安裝腳本，用於在 macOS 系統上快速設定完整的 Homebrew 與 bash 開發環境。

## 功能特色

✅ 自動安裝最新版 Homebrew  
✅ 安裝常用開發工具與套件  
✅ 設定新版 bash 為預設 shell  
✅ 自動備份現有配置檔案  
✅ 部署自訂的 bash 與 vim 環境  
✅ 完整的錯誤處理與使用者提示  
✅ 支援重複執行（冪等性）  

## 系統需求

- **作業系統**: macOS (支援 Apple Silicon 與 Intel)
- **網路連線**: 需要穩定的網路連線
- **權限**: 需要管理員權限（會提示輸入密碼）
- **磁碟空間**: 建議至少 2GB 可用空間

## 安裝步驟

### 方法一：從 GitHub 直接執行（推薦）

```bash
# 1. Clone repository
git clone https://github.com/rellikhsu/macBrewEnv.git

# 2. 進入目錄
cd macBrewEnv

# 3. 執行安裝腳本
./setup.sh
```

### 方法二：下載腳本執行

```bash
# 1. 下載腳本
curl -O https://raw.githubusercontent.com/rellikhsu/macBrewEnv/main/setup.sh

# 2. 設定執行權限
chmod +x setup.sh

# 3. 執行腳本
./setup.sh
```

**注意**: 方法二會自動 clone repository 以取得配置檔案。

## 執行流程

腳本會依序執行以下步驟：

### 步驟 1: 檢查並安裝 Homebrew
- 檢查 Homebrew 是否已安裝
- 若未安裝，使用非互動模式自動安裝
- 支援 Apple Silicon (`/opt/homebrew`) 與 Intel (`/usr/local`) 架構

### 步驟 2: 安裝必要套件
安裝以下套件：
- `bash` - 最新版 Bash shell
- `bash-completion@2` - Bash 自動完成功能
- `bash-git-prompt` - Git 狀態提示
- `mtr` - 網路診斷工具
- `httping` - HTTP ping 工具
- `gping` - 圖形化 ping 工具
- `coreutils` - GNU 核心工具
- `findutils` - GNU find 工具
- `inetutils` - 網路工具集
- `mpv` - 多媒體播放器
- `jq` - JSON 處理工具

### 步驟 3: 將 Homebrew bash 加入到 /etc/shells
- 檢查 `/opt/homebrew/bin/bash` 是否已在 `/etc/shells` 中
- 若不存在，使用 `sudo` 權限加入（**需要輸入管理員密碼**）

### 步驟 4: 修改預設 shell
- 使用 `chsh` 指令將預設 shell 改為 Homebrew 安裝的 bash
- **需要輸入使用者密碼**

### 步驟 5: 備份現有配置檔案
- 檢查 `~/.profile`、`~/.bashrc`、`~/.vimrc` 是否存在
- 若存在，備份到 `~/.config_backup_YYYYMMDD_HHMMSS/` 目錄

### 步驟 6: 確認 repository 檔案
- 檢查當前目錄是否有配置檔案
- 若無，自動 clone repository 到暫存目錄

### 步驟 7: 複製配置檔案
將以下檔案複製到 HOME 目錄：
- `profile` → `~/.profile`
- `bashrc` → `~/.bashrc`
- `vimrc` → `~/.vimrc`

## 互動提示

執行過程中，您需要在以下時機輸入密碼：

### 1. 安裝 Homebrew 時
```
==> This script will install:
...
請輸入您的管理員密碼：
```

### 2. 修改 /etc/shells 時
```
[WARNING] 需要管理員權限來修改 /etc/shells
[INFO] 請輸入您的管理員密碼：
```

### 3. 修改預設 shell 時
```
[WARNING] 即將修改預設 shell，請輸入您的使用者密碼：
```

## 完成後的步驟

安裝完成後，您會看到以下訊息：

```
========================================
  macBrewEnv 環境設定完成！
========================================

重要提醒：
  1. 預設 shell 已修改為 /opt/homebrew/bin/bash
  2. 請 登出 並 重新登入 以使 shell 變更生效
  3. 重新登入後，新的 bash 環境設定將自動載入
```

**請務必登出並重新登入**，新的 shell 環境才會生效。

## 驗證安裝

重新登入後，可以執行以下指令驗證：

```bash
# 檢查當前 shell
echo $SHELL
# 應該顯示: /opt/homebrew/bin/bash

# 檢查 bash 版本
bash --version
# 應該顯示 5.x 以上版本

# 檢查 PATH 設定
echo $PATH
# 應該看到 /opt/homebrew/bin 和 GNU 工具路徑在前面

# 測試 Git prompt
cd /path/to/git/repo
# 應該會看到 Git 分支資訊在 prompt 中
```

## 重複執行

此腳本設計為**冪等性**（idempotent），可以安全地重複執行：

- 已安裝的 Homebrew 不會重複安裝
- 已安裝的套件會被跳過
- 已存在的 `/etc/shells` 條目不會重複加入
- 每次執行都會備份現有配置檔案（使用不同時間戳記）

## 備份檔案管理

每次執行腳本時，現有的配置檔案會被備份到：

```
~/.config_backup_YYYYMMDD_HHMMSS/
├── .profile
├── .bashrc
└── .vimrc
```

如果需要還原舊的設定：

```bash
# 找到備份目錄
ls -d ~/.config_backup_*

# 還原檔案
cp ~/.config_backup_YYYYMMDD_HHMMSS/.bashrc ~/.bashrc
```

## 解除安裝

如果需要移除此環境設定：

```bash
# 1. 還原備份的配置檔案
cp ~/.config_backup_YYYYMMDD_HHMMSS/.profile ~/.profile
cp ~/.config_backup_YYYYMMDD_HHMMSS/.bashrc ~/.bashrc
cp ~/.config_backup_YYYYMMDD_HHMMSS/.vimrc ~/.vimrc

# 2. 改回預設 shell
chsh -s /bin/bash

# 3. (選擇性) 解除安裝 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## 常見問題

### Q1: 執行時出現 "Permission denied"
**A**: 請確認腳本有執行權限：
```bash
chmod +x setup.sh
```

### Q2: Homebrew 安裝失敗
**A**: 請檢查：
- 網路連線是否正常
- 是否有足夠的磁碟空間
- 是否已安裝 Xcode Command Line Tools

### Q3: chsh 指令失敗
**A**: 請確認：
- `/opt/homebrew/bin/bash` 已加入 `/etc/shells`
- 輸入的密碼正確
- 使用者帳號有權限修改 shell

### Q4: 重新登入後環境沒有變化
**A**: 請檢查：
```bash
# 確認 shell 是否已變更
echo $SHELL

# 確認 .profile 是否被載入
source ~/.profile

# 確認 .bashrc 是否被載入
source ~/.bashrc
```

### Q5: 想要自訂配置檔案
**A**: 您可以直接編輯：
- `~/.profile` - PATH 與環境變數設定
- `~/.bashrc` - 互動式 shell 設定
- `~/.vimrc` - Vim 編輯器設定

修改後執行 `source ~/.bashrc` 即可生效。

## 技術細節

### 腳本特性
- 使用 POSIX sh 語法，不依賴 bash 特定功能
- 使用 `set -e` 確保錯誤時立即停止
- 完整的顏色輸出與進度提示
- 智慧偵測 Apple Silicon vs Intel 架構

### 安全性
- 所有需要權限的操作都會明確提示
- 自動備份現有配置，避免資料遺失
- 使用官方 Homebrew 安裝腳本
- 不會修改系統核心檔案（除了 `/etc/shells`）

## 支援與回饋

如有問題或建議，請在 GitHub repository 提交 Issue：
https://github.com/rellikhsu/macBrewEnv/issues

## 授權

此專案採用與 repository 相同的授權條款。
