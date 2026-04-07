#!/usr/bin/env bash
set -e

echo "🚀 Starting OpenCode Ecosystem Installation..."

OS=$(uname -s)
echo "🖥️  Detected OS: $OS"

if [[ "$OS" == *"Linux"* ]] && grep -qi microsoft /proc/version 2>/dev/null; then
    echo "⚠️  WSL Detected: Note that cron might not start automatically in WSL."
    echo "   You may need to run 'sudo service cron start' manually."
elif [[ "$OS" == *"Linux"* ]]; then
    echo "🐧 Linux Detected."
elif [[ "$OS" == *"Darwin"* ]]; then
    echo "🍎 macOS Detected."
else
    echo "⚠️  Unknown OS: $OS. Proceeding with caution."
fi

# 1. Check for required toolchains
REQUIRED_CMDS=("opencode" "bun" "pnpm" "node" "ollama" "git")
MISSING_CMDS=0

for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "❌ Error: Required command '$cmd' is not installed or not in PATH."
        MISSING_CMDS=1
    fi
done

if [ $MISSING_CMDS -ne 0 ]; then
    echo "⚠️  Please install the missing toolchains and try again."
    exit 1
fi
echo "✅ All required toolchains found."

# 2. Setup base directories
OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
OPENCODE_PLUGINS_DIR="$OPENCODE_CONFIG_DIR/plugins"
mkdir -p "$OPENCODE_CONFIG_DIR"
mkdir -p "$OPENCODE_PLUGINS_DIR"
REPO_DIR="$(pwd)"

# 3. Install External Plugins (Automated Dependencies)
echo "📦 Installing and configuring external dependencies..."

# Oh-My-OpenAgent
if [ ! -d "$OPENCODE_PLUGINS_DIR/oh-my-openagent" ]; then
    echo "⬇️  Cloning oh-my-openagent..."
    git clone https://github.com/code-yeongyu/oh-my-openagent.git "$OPENCODE_PLUGINS_DIR/oh-my-openagent"
    cd "$OPENCODE_PLUGINS_DIR/oh-my-openagent"
    bun install
    bun run build
    echo "✅ oh-my-openagent installed."
else
    echo "✅ oh-my-openagent already exists."
fi

# CodeMEM
if [ ! -d "$OPENCODE_PLUGINS_DIR/codemem" ]; then
    echo "⬇️  Cloning CodeMEM..."
    # Replace with actual codemem repo URL when available (using a placeholder or standard structure)
    # git clone <repo-url> "$OPENCODE_PLUGINS_DIR/codemem"
    # For now, we simulate the structure based on the guide
    mkdir -p "$OPENCODE_PLUGINS_DIR/codemem/packages/mcp-server/dist"
    echo "console.log('CodeMEM Placeholder');" > "$OPENCODE_PLUGINS_DIR/codemem/packages/mcp-server/dist/index.js"
    echo "⚠️  NOTE: Replace the CodeMEM placeholder with the actual repository clone when available."
else
    echo "✅ CodeMEM already exists."
fi

# RAM Guard (ESM Module)
if [ ! -d "$OPENCODE_PLUGINS_DIR/ram-guard" ]; then
    echo "⬇️  Setting up RAM Guard ESM Plugin..."
    mkdir -p "$OPENCODE_PLUGINS_DIR/ram-guard"
    cd "$OPENCODE_PLUGINS_DIR/ram-guard"
    echo '{"name": "ram-guard", "version": "1.0.0", "type": "module"}' > package.json
    cat << 'MODULE_EOF' > index.js
export default async function() {
    return {
        tools: [],
        name: "ram-guard-plugin"
    };
}
MODULE_EOF
    npm install --quiet
    echo "✅ RAM Guard plugin initialized."
else
    echo "✅ RAM Guard plugin already exists."
fi

# 4. Create symlinks for Ecosystem configurations
echo "🔗 Creating symlinks..."

create_symlink() {
    local src="$1"
    local dest="$2"
    
    if [ ! -e "$src" ]; then
        echo "⚠️  Source $src does not exist. Skipping symlink."
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$src" ]; then
            echo "✅ Symlink already exists: $dest"
            return
        fi
        echo "⚠️  Destination $dest already exists. Backing up to ${dest}.bak..."
        mv "$dest" "${dest}.bak"
    fi
    
    ln -s "$src" "$dest"
    echo "✅ Linked $src -> $dest"
}

cd "$REPO_DIR"
create_symlink "$REPO_DIR/configs/oh-my-openagent.json" "$OPENCODE_CONFIG_DIR/oh-my-openagent.json"
create_symlink "$REPO_DIR/memory" "$OPENCODE_CONFIG_DIR/memory"
create_symlink "$REPO_DIR/skill" "$OPENCODE_CONFIG_DIR/skill"

# 5. Handle opencode.json.template
TEMPLATE_FILE="$REPO_DIR/configs/opencode.json.template"
TARGET_CONFIG="$OPENCODE_CONFIG_DIR/opencode.json"

echo "📝 Checking OpenCode configuration..."
if [ -f "$TARGET_CONFIG" ]; then
    echo "⚠️  $TARGET_CONFIG already exists. Skipping overwrite."
    echo "👉 Please manually merge any new settings from configs/opencode.json.template into your existing opencode.json."
else
    echo "👉 Action taken: Copying template config."
    cp "$TEMPLATE_FILE" "$TARGET_CONFIG"
    echo "⚠️  IMPORTANT: Please edit $TARGET_CONFIG and add your real API keys!"
fi

# 6. Install cronjobs safely
echo "🕒 Setting up cronjobs..."
TMP_CRON=$(mktemp)
crontab -l > "$TMP_CRON" 2>/dev/null || true

CRON_ADDED=0

if ! grep -q "$OPENCODE_CONFIG_DIR/memory/ram-guard-cron.sh" "$TMP_CRON"; then
    echo "*/5 * * * * $OPENCODE_CONFIG_DIR/memory/ram-guard-cron.sh >> /dev/null 2>&1" >> "$TMP_CRON"
    CRON_ADDED=1
fi

if ! grep -q "$OPENCODE_CONFIG_DIR/memory/kairos.sh" "$TMP_CRON"; then
    echo "*/30 * * * * $OPENCODE_CONFIG_DIR/memory/kairos.sh $HOME >> /dev/null 2>&1" >> "$TMP_CRON"
    CRON_ADDED=1
fi

if [ $CRON_ADDED -eq 1 ]; then
    crontab "$TMP_CRON"
    echo "✅ Cronjobs installed successfully."
else
    echo "✅ Cronjobs are already installed."
fi
rm -f "$TMP_CRON"

# 7. Success message
echo ""
echo "🎉 OpenCode Ecosystem successfully deployed!"
echo ""
echo "Next steps:"
echo "1. Edit ~/.config/opencode/opencode.json and insert your valid API keys."
echo "2. Restart your terminal or start OpenCode by running: opencode"
echo ""
echo "Enjoy your Macchina da Guerra! 🚀"
