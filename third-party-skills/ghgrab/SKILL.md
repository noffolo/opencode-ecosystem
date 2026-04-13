---
title: ghgrab - GitHub File & Folder Downloader
id: ghgrab
version: 1.0.0
author: opencode-ecosystem
---

# Trigger:
- "Scarica il file X dal repo Y"
- "Voglio prendere solo questa cartella da GitHub"
- "Download file from github"
- "Download cartella github senza clonare"
- "Get release from github"
- "Scarica la release di..."
- "Usa ghgrab"

# Intent Disambiguation (MANDATORY BEFORE EXECUTION)
Quando l'utente fa una richiesta generica legata a un repository GitHub (es. "Prendimi i file da questa repo"), DEVI analizzare la richiesta:
- Se l'utente vuole l'intero progetto per lavorarci sopra -> **Usa `git clone`** (ignorando ghgrab).
- Se l'utente specifica file, cartelle, o dice esplicitamente "solo", "senza clonare" -> **Usa `ghgrab`**.
- Se l'intento non è chiaro, **CHIARIRE PRIMA DI AGIRE** con questa domanda:
  *"Vuoi clonare l'intero repository per lavorarci (tramite git clone), oppure vuoi scaricare solo alcuni file/cartelle specifici senza scaricare tutto il progetto?"*

# Instructions

You are an expert in fetching specific files, folders, and releases from GitHub repositories without cloning them entirely, using the `ghgrab` tool.

**IMPORTANT:** Always use the `agent` subcommand for programmatic interactions. This ensures the output is a stable JSON that you can parse easily, instead of dealing with interactive TUIs.

### 1. View Repository Tree (JSON)
To see the structure of a repository before downloading:
```bash
ghgrab agent tree https://github.com/<owner>/<repo>
```

### 2. Download Specific Files or Folders
To download specific items without a TUI:
```bash
# Downloads to a specific output folder
ghgrab agent download https://github.com/<owner>/<repo> <path/to/folder_or_file1> <path/to/file2> --out ./output_dir

# Downloads straight to current directory WITHOUT creating a subfolder for the repo name
ghgrab agent download https://github.com/<owner>/<repo> <path/to/folder_or_file> --cwd --no-folder
```

### 3. Download GitHub Releases (Artifacts)
To download binary artifacts from a GitHub release (do NOT use `agent` mode for this, use `rel`):
```bash
# Extracts archive and outputs to specific bin path
ghgrab rel <owner>/<repo> --extract --bin-path ~/.local/bin

# Specify OS and Arch (if auto-detect fails)
ghgrab rel <owner>/<repo> --os linux --arch amd64
```

### Error Handling
- If you hit rate limits, remind the user or yourself that a GitHub token might be needed: `ghgrab config set token YOUR_TOKEN`.
- If JSON output from `agent` fails, ensure you are passing the URLs correctly.

# Example Workflow
1. User: "Scarica solo la cartella 'src/components' dal repo 'facebook/react'".
2. You run: `ghgrab agent download https://github.com/facebook/react src/components --out ./react-components`
3. You verify the download with `ls -la ./react-components`.