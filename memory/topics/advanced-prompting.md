# Advanced Prompting & In-Context Learning (EgoAlpha)

**Source:** `~/.opencode/knowledge_base/prompt-in-context-learning/`
**Date Assimilated:** 2026-04-06

Questo documento contiene i principi architetturali fondamentali per l'interazione avanzata con gli LLM, estratti dalla repository EgoAlpha. Da utilizzare per ottimizzare la delega dei task e la generazione di prompt.

## 1. Framework C.I.R.C.D.
Per task ad alta precisione, ogni prompt di delega dovrebbe idealmente contenere:
- **[C] Context:** Stato attuale, file attivi, obiettivo macro.
- **[I] Instruction:** Azione atomica richiesta.
- **[R] Relevance:** Riferimenti a pattern esistenti o documentazione esterna (RAG).
- **[C] Constraint:** Paletti rigidi (es. divieti di usare determinati costrutti, limiti di performance).
- **[D] Demonstration:** Esempi In-Context (One-Shot/Few-Shot) di input e output desiderato.
*Nota per OpenCode:* Per risparmiare token, usare un approccio "I.C." di default, scalando a C.I.R.C.D. completo solo in caso di fallimento o complessità estrema.

## 2. RAG Avanzato e Noise Robustness
- **Sparse Context Selection:** Non iniettare interi file. Usa `lsp_symbols` o `ast_grep_search` per estrarre solo le firme dei metodi rilevanti e nascondere le implementazioni superflue.
- **Over-refusal & Reliability:** Gli agenti tendono a bloccarsi o allucinare se il contesto è contraddittorio. Assicurarsi che i [Constraint] siano assoluti e non ambigui.

## 3. Gestione della Memoria e Pianificazione
- **Gerarchia:** Separare sempre la pianificazione (es. `.sisyphus/plans/`) dall'esecuzione.
- **Adversarial Red Teaming:** Utilizzare approcci "avversari" non per bloccare lo sviluppatore, ma per simulare mentalmente exploit e vulnerabilità durante le fasi di review o idle-time (`autodream`).