#!/bin/bash

# Colori per l'output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Verifica stato Docker in corso...${NC}"

# Controlla se il demone Docker sta girando
if ! docker info > /dev/null 2>&1; then
    echo -e "${YELLOW}Docker non è in esecuzione. Lo sto aprendo per te in background...${NC}"
    # Su macOS, questo avvia l'app Docker
    open -a Docker
    
    # Aspetta finché il demone non risponde (timeout 60 secondi)
    COUNTER=0
    while ! docker info > /dev/null 2>&1; do
        if [ $COUNTER -gt 60 ]; then
            echo "Errore: Docker sta impiegando troppo tempo ad avviarsi."
            exit 1
        fi
        sleep 2
        COUNTER=$((COUNTER+2))
    done
    echo -e "${GREEN}Docker è ora operativo!${NC}"
else
    echo -e "${GREEN}Docker è già in esecuzione.${NC}"
fi

# Avvia Open Notebook
echo -e "${YELLOW}Avvio Open Notebook...${NC}"
cd ~/.config/opencode/skill/open-notebook
docker compose up -d

# Aspetta che l'API sia pronta
COUNTER=0
while ! curl -s http://localhost:5055/health | grep -q "healthy"; do
    if [ $COUNTER -gt 30 ]; then
        echo "Attesa API prolungata, procedo comunque..."
        break
    fi
    sleep 2
    COUNTER=$((COUNTER+2))
done

echo -e "${GREEN}✅ Open Notebook è pronto all'uso!${NC}"
