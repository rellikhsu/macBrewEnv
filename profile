# 1. Homebrew (設定 PATH 與環境)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. GNU tools gnubin（coreutils / findutils / gnu-sed / gawk / gnu-which … ）取代內建工具
# 需安裝 brew install coreutils findutils gnu-sed gawk gnu-which 
shopt -s nullglob
for d in /opt/homebrew/opt/*/libexec/gnubin; do
    PATH="$d:$PATH"
done
shopt -u nullglob

# 3. User scripts
PATH="$HOME/bin:$PATH"

# 4. Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.bash.inc" ]; then
    . "$HOME/google-cloud-sdk/path.bash.inc"
fi

# 5. 互動 shell 才載入 .bashrc
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

