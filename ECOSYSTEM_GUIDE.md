# OpenCode Ecosystem - Ultimate Guide

Questo è il repository centrale dell'ecosistema OpenCode customizzato. Questo documento elenca tutto ciò che è installato, a cosa serve e come usarlo.

## 🛠 Come installare o aggiornare tutto
Con un solo comando, lo script allinea tutte le configurazioni globali del tuo computer, scaricando e installando le dipendenze:
```bash
./install-all-dependencies.sh
```

---

## 🧠 1. Memoria e Ottimizzazione del Contesto

### 1.1 CodeMem (Memoria Tecnica del Progetto)
*   **Cos'è:** La memoria a lungo termine per il tuo codice. Registra decisioni, dipendenze, bug risolti.
*   **Come si usa:** È invisibile. L'Agente usa le skill `memory_observor` (durante il lavoro) e `memory_index_reader` per aggiornare il file `MEMORY.md`. 
*   **Quando si usa:** Automaticamente, quando l'Agente esplora o risolve bug difficili.

### 1.2 Open Notebook (La Memoria di Ricerca e RAG)
*   **Cos'è:** Un database locale vettoriale basato su Docker per RAG (Retrieval-Augmented Generation).
*   **Come si usa:** "Aggiungi questo PDF/URL alla mia ricerca", "Crea un nuovo notebook".
*   **Superpotere:** L'ecosistema è dotato di **Auto-Wake**. Se chiedi all'IA di salvare una nota su Open Notebook e Docker è spento, OpenCode avvierà Docker per te in background e aspetterà che il database sia pronto.

### 1.3 Dynamic Context Pruning (DCP)
*   **Cos'è:** Un plugin ufficiale che pulisce in tempo reale il contesto della chat. Rimuove errori ripetitivi e log lunghissimi se capisce che non servono più.
*   **Come si usa:** Lavora da solo in background.
*   **Comandi utili:** 
    *   `/dcp context` in chat per vedere quanti token sta salvando.
    *   `/dcp stats` per le statistiche globali di risparmio.

---

## 🤖 2. Qualità del Codice e Pattern (I "Guardiani")

### 2.1 OpenAgentsControl (OAC)
*   **Cos'è:** Un framework integrato per bloccare le allucinazioni dell'AI imponendo "Approval Gates" e pattern di codice immutabili.
*   **Come si usa:** Invece di chiedere all'AI "scrivimi un'app", puoi configurare delle regole (es. "Le API devono sempre usare FastAPI e pydantic"). OAC costringe l'IA a seguire questa regola tramite `.opencode/` context files.

### 2.2 Sentry Monitor
*   **Cos'è:** Plugin per l'invio della telemetria delle tue sessioni AI a Sentry.
*   **Come si usa:** Necessita di un progetto configurato su Sentry. Una volta configurato, ogni volta che un'IA genera un'eccezione o invoca tool, i dati vengono tracciati.

### 2.3 Opencode Workaholic & QA-Gate
*   **Cos'è:** Sub-agenti o skill per l'autoverifica del lavoro.
*   **Come si usa:** Quando finisci un task, l'Agente lancia sub-agenti in background per revisionare quello che ha appena scritto e blocca il completamento se non passa i test interni.

---

## 🐙 3. Automazioni GitHub e Fetching

### 3.1 GhGrab (Download Selettivo)
*   **Cos'è:** Uno strumento velocissimo scritto in Rust per estrarre porzioni di repository o artefatti binari.
*   **Come si usa:** L'Agente lo usa quando gli dici: "Prendimi *solo* la cartella X dal repo Y senza clonarlo tutto". Usa la modalità JSON (`ghgrab agent`) per farsi rispondere in formato macchina.

### 3.2 Git Atomic Committer
*   **Cos'è:** Skill per creare commit super professionali.
*   **Come si usa:** Chiedi all'AI "Crea i commit per il mio lavoro". L'AI separerà le modifiche (frontend, backend, doc) in commit separati e atomici, seguendo le convenzioni di Conventional Commits.

---

## 🧬 4. Core CLI (Il Cuore)
### Oh-My-OpenAgent
*   **Cos'è:** Il client customizzato che gestisce l'astrazione tra l'utente e il backend LLM. È ciò che permette alla magia dei subagenti `task(run_in_background=true)` di operare fluentemente scambiandosi token, file di stato e chiamate MCP.
