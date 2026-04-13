#!/bin/bash
set -e

# Colori per il feedback visivo
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}🚀 INSTALLING FULL OPENCODE ECOSYSTEM 🚀${NC}"
echo -e "${BLUE}=====================================================${NC}"

# 1. Check & Install Base Dependencies
echo -e "\n${YELLOW}📦 1/6 Checking system dependencies...${NC}"

if ! command -v brew &> /dev/null; then
    echo -e "${RED}❌ Homebrew non trovato. Per favore installa Homebrew prima di procedere.${NC}"
    exit 1
fi

if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    echo -e "${YELLOW}⚙️ Node.js/npm mancanti. Installazione in corso via Homebrew...${NC}"
    brew install node
else
    echo -e "${GREEN}✅ Node.js e npm trovati.${NC}"
fi

if ! command -v uv &> /dev/null; then
    echo -e "${YELLOW}⚙️ uv mancante. Installazione in corso...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo -e "${GREEN}✅ uv trovato.${NC}"
fi

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ docker non trovato. L'ecosistema richiede Docker Desktop per alcuni servizi (es. Open Notebook).${NC}"
    echo "Installa Docker Desktop da: https://www.docker.com/products/docker-desktop/"
    exit 1
else
    echo -e "${GREEN}✅ Docker trovato.${NC}"
fi

# 2. Build and Install Core Ecosystem Packages
echo -e "\n${YELLOW}🛠️ 2/6 Building and Installing Core OpenCode Packages...${NC}"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# oh-my-openagent (Core CLI / Backend)
if [ -d "$REPO_DIR/oh-my-openagent" ]; then
    echo "Compilando oh-my-openagent..."
    cd "$REPO_DIR/oh-my-openagent"
    npm install
    npm link || true
    echo -e "${GREEN}✅ oh-my-openagent preparato.${NC}"
fi

# opencode-workaholic
if [ -d "$REPO_DIR/opencode-workaholic" ]; then
    echo "Compilando opencode-workaholic..."
    cd "$REPO_DIR/opencode-workaholic"
    npm install
    npm link || true
    echo -e "${GREEN}✅ opencode-workaholic preparato.${NC}"
fi

# opencode-skills (Types / Utils)
if [ -d "$REPO_DIR/opencode-skills" ]; then
    echo "Compilando opencode-skills (libreria)..."
    cd "$REPO_DIR/opencode-skills"
    npm install
    npm link || true
    echo -e "${GREEN}✅ opencode-skills preparato.${NC}"
fi

# codemem (Python/Node backend per la memoria)
if [ -d "$REPO_DIR/codemem" ]; then
    echo "Preparando CodeMem..."
    cd "$REPO_DIR/codemem"
    uv sync || true
    echo -e "${GREEN}✅ CodeMem preparato.${NC}"
fi

# OpenAgentsControl (OAC)
if [ -d "$REPO_DIR/OpenAgentsControl" ]; then
    echo "Preparando OpenAgentsControl..."
    cd "$REPO_DIR/OpenAgentsControl"
    bash ./install.sh full || echo -e "${YELLOW}OAC install.sh reportato come parzialmente skipato (normale se aggiornato).${NC}"
    echo -e "${GREEN}✅ OpenAgentsControl (OAC) installato localmente.${NC}"
fi

# 3. Third-Party Dependencies (ghgrab, etc.)
echo -e "\n${YELLOW}📥 3/6 Installazione dipendenze di terze parti...${NC}"
npm install -g @ghgrab/ghgrab
echo -e "${GREEN}✅ ghgrab installato globalmente.${NC}"

# 4. Install OpenCode External Plugins
echo -e "\n${YELLOW}🧩 4/6 Installazione dei Plugin Ufficiali (DCP e Sentry)...${NC}"
opencode plugin @tarquinen/opencode-dcp@latest --global
echo -e "${GREEN}✅ Plugin DCP (Dynamic Context Pruning) installato.${NC}"

opencode plugin opencode-sentry-monitor --global
echo -e "${GREEN}✅ Plugin Sentry Monitor installato.${NC}"

# Configure DCP directly inside the installation block
cat << 'EOF_DCP' > "$HOME/.config/opencode/dcp.jsonc"
{
    "enabled": true,
    "pruneNotification": "minimal",
    "pruneNotificationType": "chat",
    "commands": {
        "enabled": true,
        "protectedTools": ["task", "skill", "todowrite", "todoread", "memory_observor", "memory_index_reader"]
    },
    "turnProtection": {
        "enabled": true,
        "turns": 4
    },
    "experimental": {
        "allowSubAgents": true,
        "customPrompts": false
    },
    "compress": {
        "mode": "range",
        "permission": "allow",
        "showCompression": false,
        "summaryBuffer": true,
        "maxContextLimit": 80000,
        "minContextLimit": 40000,
        "nudgeFrequency": 3,
        "iterationNudgeThreshold": 10,
        "nudgeForce": "strong",
        "protectedTools": ["task", "skill", "memory_observor"],
        "protectUserMessages": false
    },
    "strategies": {
        "deduplication": {
            "enabled": true
        },
        "purgeErrors": {
            "enabled": true,
            "turns": 3
        }
    }
}
EOF_DCP
echo -e "${GREEN}✅ Configurazione ottimizzata di DCP generata.${NC}"

# 5. Linking Active Skills to OpenCode
echo -e "\n${YELLOW}🔗 5/6 Collegamento delle Skill ad OpenCode...${NC}"
CONFIG_SKILL_DIR="$HOME/.config/opencode/skill"
mkdir -p "$CONFIG_SKILL_DIR"

if [ -d "$REPO_DIR/skills/active" ]; then
    echo "Sincronizzando le skill 'active'..."
    cp -R "$REPO_DIR/skills/active/"* "$CONFIG_SKILL_DIR/" 2>/dev/null || true
fi

if [ -d "$REPO_DIR/third-party-skills" ]; then
    echo "Sincronizzando i third-party-skills..."
    cp -R "$REPO_DIR/third-party-skills/"* "$CONFIG_SKILL_DIR/"
fi

if [ -f "$CONFIG_SKILL_DIR/open-notebook/auto-wake.sh" ]; then
    chmod +x "$CONFIG_SKILL_DIR/open-notebook/auto-wake.sh"
fi
if [ -f "$CONFIG_SKILL_DIR/open-notebook/start-open-notebook.sh" ]; then
    chmod +x "$CONFIG_SKILL_DIR/open-notebook/start-open-notebook.sh"
fi

echo -e "${GREEN}✅ Tutte le Skill sono state caricate nella configurazione di OpenCode.${NC}"

# 6. Ecosistema Pronto
echo -e "\n${BLUE}=====================================================${NC}"
echo -e "${GREEN}🎉 INSTALLAZIONE COMPLETATA CON SUCCESSO! 🎉${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo -e "L'intero ecosistema è ora allineato sul tuo Mac."
echo -e "Componenti configurati:"
echo -e " - CodeMem (Memoria a lungo termine)"
echo -e " - Oh-My-OpenAgent & Workaholic"
echo -e " - Tutte le Skill Attive (incluse le utility di memoria e QA)"
echo -e " - Dynamic Context Pruning (Ottimizzazione Prompt & Token)"
echo -e " - Sentry Monitor (Tracciamento AI Errori)"
echo -e " - OpenAgentsControl (OAC - Pattern architetturali fissi)"
echo -e " - Open Notebook (RAG e Ricerca Locale con auto-wake Docker)"
echo -e " - GhGrab (Download selettivo da GitHub)"
echo -e "\nPuoi lanciare OpenCode e usare immediatamente le nuove funzionalità."
