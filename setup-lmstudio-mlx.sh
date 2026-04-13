#!/bin/bash
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}🧠 LM STUDIO MLX SETUP FOR OPENCODE ECOSYSTEM 🧠${NC}"
echo -e "${BLUE}=====================================================${NC}"

echo -e "\n${YELLOW}📦 1/3 Checking LM Studio installation...${NC}"
if [ ! -d "/Applications/LM Studio.app" ]; then
    echo -e "${YELLOW}LM Studio non trovato. Installazione via Homebrew...${NC}"
    brew install --cask lm-studio
    echo -e "${GREEN}✅ LM Studio installato.${NC}"
else
    echo -e "${GREEN}✅ LM Studio già installato.${NC}"
fi

LMS_BIN="/Users/$USER/.lmstudio/bin/lms"
if ! command -v lms &> /dev/null; then
    if [ -f "$LMS_BIN" ]; then
        export PATH="$PATH:/Users/$USER/.lmstudio/bin"
    else
        echo -e "${RED}❌ L'utility 'lms' di LM Studio non è stata trovata.${NC}"
        echo -e "${YELLOW}👉 IMPORTANTE: Apri LM Studio almeno una volta per inizializzare gli strumenti da riga di comando (lms).${NC}"
        echo -e "${YELLOW}Dopo averlo aperto, riavvia questo script.${NC}"
        exit 1
    fi
fi

echo -e "\n${YELLOW}🚀 2/3 Avvio del Server LM Studio in background...${NC}"
echo -e "Avvio del server API su porta 1234..."
lms server start || echo -e "${YELLOW}Il server potrebbe essere già in esecuzione.${NC}"

echo -e "\n${YELLOW}📥 3/3 Download dei modelli MLX ottimizzati per OpenCode...${NC}"

# Start downloads asynchronously
echo -e "Avvio download per: mistralai/mistral-nemo-instruct-2407"
lms get "mistralai/mistral-nemo-instruct-2407" --yes &

echo -e "Avvio download per: qwen2.5-coder-7b-instruct"
lms get "qwen2.5-coder-7b-instruct" --yes &

echo -e "Avvio download per: gemma-2b-it"
lms get "gemma-2b-it" --yes &

echo -e "\n${BLUE}=====================================================${NC}"
echo -e "${GREEN}✅ SETUP AVVIATO IN BACKGROUND!${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo -e "I modelli sono in fase di download. Puoi verificare lo stato aprendo LM Studio."
echo -e "Il server LM Studio è in ascolto su http://localhost:1234/v1"
