########## ~/.profile ##########

# 1. Homebrew（Apple Silicon）
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. 自動把所有 gnubin 放到 PATH 最前面
#    例如 coreutils / findutils / gnu-sed / gawk / gnu-which / 之後新裝的 gnu-*…
for d in /opt/homebrew/opt/*/libexec/gnubin; do
    [ -d "$d" ] && PATH="$d:$PATH"
done

# 3. 使用者自訂 scripts
PATH="$HOME/bin:$PATH"

# 4. Google Cloud SDK（放 PATH 尾端，只掛 CLI）
if [ -d "$HOME/google-cloud-sdk/bin" ]; then
    PATH="$PATH:$HOME/google-cloud-sdk/bin"
fi

# 5. 把 PATH 去重，避免一堆重複路徑
old_IFS=$IFS
IFS=:
new_PATH=
for p in $PATH; do
    case ":$new_PATH:" in
        *":$p:"*) ;;  # 已經有了就略過
        *)
            if [ -n "$new_PATH" ]; then
                new_PATH="$new_PATH:$p"
            else
                new_PATH="$p"
            fi
            ;;
    esac
done
IFS=$old_IFS
PATH=$new_PATH
unset old_IFS new_PATH p

export PATH

# 6. 互動 bash 才載入 .bashrc
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
########## end ~/.profile ##########

