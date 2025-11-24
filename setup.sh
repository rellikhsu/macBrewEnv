#!/bin/sh
#
# macBrewEnv Setup Script
# 自動化設定 macOS Homebrew 環境與 bash 配置
#

set -e  # 遇到錯誤立即停止

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 輔助函數
print_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

print_success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
}

print_step() {
    printf "\n${GREEN}==>${NC} ${BLUE}%s${NC}\n" "$1"
}

# 檢查是否為 macOS
check_macos() {
    if [ "$(uname)" != "Darwin" ]; then
        print_error "此腳本僅適用於 macOS 系統"
        exit 1
    fi
    print_success "系統檢查通過：macOS"
}

# 檢查網路連線
check_network() {
    print_info "檢查網路連線..."
    if ! ping -c 1 -W 2 github.com > /dev/null 2>&1; then
        print_error "無法連線到網路，請檢查網路設定"
        exit 1
    fi
    print_success "網路連線正常"
}

# 檢查並安裝 Homebrew
install_homebrew() {
    print_step "步驟 1: 檢查並安裝 Homebrew"
    
    if command -v brew > /dev/null 2>&1; then
        print_warning "Homebrew 已安裝，跳過安裝步驟"
        BREW_PREFIX=$(brew --prefix)
        print_info "Homebrew 路徑: $BREW_PREFIX"
    else
        print_info "開始安裝 Homebrew..."
        print_warning "安裝過程中可能需要輸入您的管理員密碼"
        
        # 使用非互動模式安裝 Homebrew
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # 設定 Homebrew 環境變數
        if [ -x /opt/homebrew/bin/brew ]; then
            BREW_PREFIX="/opt/homebrew"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x /usr/local/bin/brew ]; then
            BREW_PREFIX="/usr/local"
            eval "$(/usr/local/bin/brew shellenv)"
        else
            print_error "Homebrew 安裝失敗"
            exit 1
        fi
        
        print_success "Homebrew 安裝完成"
    fi
}

# 更新 Homebrew
update_homebrew() {
    print_info "更新 Homebrew..."
    brew update
    print_success "Homebrew 更新完成"
}

# 安裝必要套件
install_packages() {
    print_step "步驟 2: 安裝必要套件"
    
    PACKAGES="bash bash-completion@2 bash-git-prompt mtr httping gping coreutils findutils inetutils mpv jq"
    
    print_info "準備安裝以下套件："
    printf "  %s\n" "$PACKAGES"
    
    for pkg in $PACKAGES; do
        if brew list "$pkg" > /dev/null 2>&1; then
            print_warning "套件 $pkg 已安裝，跳過"
        else
            print_info "安裝 $pkg..."
            brew install "$pkg"
        fi
    done
    
    print_success "所有套件安裝完成"
}

# 將新版 bash 加入到 /etc/shells
add_bash_to_shells() {
    print_step "步驟 3: 將 Homebrew bash 加入到 /etc/shells"
    
    BASH_PATH="${BREW_PREFIX}/bin/bash"
    
    if [ ! -f "$BASH_PATH" ]; then
        print_error "找不到 $BASH_PATH"
        exit 1
    fi
    
    if grep -Fxq "$BASH_PATH" /etc/shells; then
        print_warning "$BASH_PATH 已存在於 /etc/shells 中"
    else
        print_warning "需要管理員權限來修改 /etc/shells"
        print_info "請輸入您的管理員密碼："
        
        echo "$BASH_PATH" | sudo tee -a /etc/shells > /dev/null
        print_success "$BASH_PATH 已加入到 /etc/shells"
    fi
}

# 修改預設 shell
change_default_shell() {
    print_step "步驟 4: 修改預設 shell"
    
    BASH_PATH="${BREW_PREFIX}/bin/bash"
    CURRENT_SHELL=$(dscl . -read ~/ UserShell | awk '{print $2}')
    
    print_info "目前的 shell: $CURRENT_SHELL"
    print_info "新的 shell: $BASH_PATH"
    
    if [ "$CURRENT_SHELL" = "$BASH_PATH" ]; then
        print_warning "預設 shell 已經是 $BASH_PATH"
    else
        print_warning "即將修改預設 shell，請輸入您的使用者密碼："
        chsh -s "$BASH_PATH"
        print_success "預設 shell 已修改為 $BASH_PATH"
        print_warning "注意：需要登出並重新登入才會生效"
    fi
}

# 備份現有配置檔案
backup_existing_configs() {
    print_step "步驟 5: 備份現有配置檔案"
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_DIR="$HOME/.config_backup_$TIMESTAMP"
    
    NEEDS_BACKUP=0
    
    if [ -f "$HOME/.profile" ] || [ -f "$HOME/.bashrc" ] || [ -f "$HOME/.vimrc" ]; then
        NEEDS_BACKUP=1
    fi
    
    if [ $NEEDS_BACKUP -eq 1 ]; then
        mkdir -p "$BACKUP_DIR"
        print_info "備份目錄: $BACKUP_DIR"
        
        if [ -f "$HOME/.profile" ]; then
            cp "$HOME/.profile" "$BACKUP_DIR/.profile"
            print_info "已備份 ~/.profile"
        fi
        
        if [ -f "$HOME/.bashrc" ]; then
            cp "$HOME/.bashrc" "$BACKUP_DIR/.bashrc"
            print_info "已備份 ~/.bashrc"
        fi
        
        if [ -f "$HOME/.vimrc" ]; then
            cp "$HOME/.vimrc" "$BACKUP_DIR/.vimrc"
            print_info "已備份 ~/.vimrc"
        fi
        
        print_success "配置檔案備份完成"
    else
        print_info "沒有需要備份的配置檔案"
    fi
}

# 確認 repository 存在
ensure_repo() {
    print_step "步驟 6: 確認 repository 檔案"
    
    SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
    
    # 檢查必要檔案是否存在
    if [ -f "$SCRIPT_DIR/profile" ] && [ -f "$SCRIPT_DIR/bashrc" ] && [ -f "$SCRIPT_DIR/vimrc" ]; then
        print_success "找到所有必要的配置檔案"
        REPO_DIR="$SCRIPT_DIR"
    else
        print_warning "在當前目錄找不到配置檔案，嘗試 clone repository..."
        
        TEMP_DIR="$HOME/.macBrewEnv_temp"
        
        if [ -d "$TEMP_DIR" ]; then
            print_info "移除舊的暫存目錄..."
            rm -rf "$TEMP_DIR"
        fi
        
        print_info "Clone repository 到 $TEMP_DIR"
        git clone https://github.com/rellikhsu/macBrewEnv.git "$TEMP_DIR"
        
        REPO_DIR="$TEMP_DIR"
        print_success "Repository clone 完成"
    fi
    
    export REPO_DIR
}

# 複製配置檔案
copy_config_files() {
    print_step "步驟 7: 複製配置檔案到 HOME 目錄"
    
    if [ -z "$REPO_DIR" ]; then
        print_error "REPO_DIR 未設定"
        exit 1
    fi
    
    print_info "從 $REPO_DIR 複製配置檔案..."
    
    cp "$REPO_DIR/profile" "$HOME/.profile"
    print_success "已複製 profile -> ~/.profile"
    
    cp "$REPO_DIR/bashrc" "$HOME/.bashrc"
    print_success "已複製 bashrc -> ~/.bashrc"
    
    cp "$REPO_DIR/vimrc" "$HOME/.vimrc"
    print_success "已複製 vimrc -> ~/.vimrc"
    
    print_success "所有配置檔案複製完成"
}

# 清理暫存目錄
cleanup() {
    if [ -d "$HOME/.macBrewEnv_temp" ]; then
        print_info "清理暫存目錄..."
        rm -rf "$HOME/.macBrewEnv_temp"
    fi
}

# 顯示完成訊息
show_completion_message() {
    print_step "安裝完成！"
    
    printf "\n"
    printf "${GREEN}========================================${NC}\n"
    printf "${GREEN}  macBrewEnv 環境設定完成！${NC}\n"
    printf "${GREEN}========================================${NC}\n"
    printf "\n"
    printf "${YELLOW}重要提醒：${NC}\n"
    printf "  1. 預設 shell 已修改為 ${BLUE}%s/bin/bash${NC}\n" "$BREW_PREFIX"
    printf "  2. 請 ${RED}登出${NC} 並 ${RED}重新登入${NC} 以使 shell 變更生效\n"
    printf "  3. 重新登入後，新的 bash 環境設定將自動載入\n"
    printf "\n"
    printf "${BLUE}配置檔案位置：${NC}\n"
    printf "  - ~/.profile\n"
    printf "  - ~/.bashrc\n"
    printf "  - ~/.vimrc\n"
    printf "\n"
    
    if [ -d "$HOME/.config_backup_"* ] 2>/dev/null; then
        BACKUP_DIR=$(ls -dt "$HOME/.config_backup_"* 2>/dev/null | head -1)
        printf "${YELLOW}備份檔案位置：${NC}\n"
        printf "  %s\n" "$BACKUP_DIR"
        printf "\n"
    fi
    
    printf "${GREEN}感謝使用 macBrewEnv！${NC}\n"
    printf "\n"
}

# 主程式
main() {
    printf "\n"
    printf "${BLUE}========================================${NC}\n"
    printf "${BLUE}  macBrewEnv 自動安裝腳本${NC}\n"
    printf "${BLUE}========================================${NC}\n"
    printf "\n"
    
    check_macos
    check_network
    install_homebrew
    update_homebrew
    install_packages
    add_bash_to_shells
    change_default_shell
    backup_existing_configs
    ensure_repo
    copy_config_files
    cleanup
    show_completion_message
}

# 執行主程式
main
