#!/bin/bash
# ollama-autounload — scarica i modelli Ollama se non usati da X minuti
# Da mettere in crontab: */5 * * * * ~/opencode-ecosystem/skills/ollama-autounload.sh

IDLE_MINUTES=${1:-10}
OLLAMA_HOST="${OLLAMA_HOST:-http://localhost:11434}"

# Controlla se Ollama e in esecuzione
if ! curl -s "$OLLAMA_HOST/api/tags" > /dev/null 2>&1; then
    exit 0
fi

# Lista i modelli attualmente caricati in memoria
loaded=$(curl -s "$OLLAMA_HOST/api/ps" 2>/dev/null)

if [ -z "$loaded" ] || [ "$loaded" = "[]" ] || [ "$loaded" = '{"models":[]}' ]; then
    exit 0
fi

# Estrai i nomi dei modelli caricati
models=$(echo "$loaded" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    models = data.get('models', [])
    for m in models:
        print(m.get('name', ''))
except:
    pass
" 2>/dev/null)

if [ -z "$models" ]; then
    exit 0
fi

# Controlla se ci sono processi opencode attivi che usano Ollama
if pgrep -f "opencode" > /dev/null 2>&1; then
    # OpenCode e attivo, non scaricare nulla
    exit 0
fi

# Scarica i modelli inattivi
for model in $models; do
    echo "scaricamento modello: $model"
    curl -s -X POST "$OLLAMA_HOST/api/generate" \
        -d "{\"model\": \"$model\", \"keep_alive\": 0}" > /dev/null 2>&1
done

echo "modelli scaricati. RAM liberata."
