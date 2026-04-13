---
name: ultraplan
description: "Deep planning for complex tasks with research, hypothesis testing, and structured output. Explores multiple strategies via remote model, validates against codebase, and integrates with memory/autodream/kairos. Use for architectural decisions, large refactoring, and strategic planning."
triggers: ultraplan, deep planning, piano complesso, architectural plan, refactoring plan, strategia, multi-step plan, analisi architettura, piano dettagliato, research, analisi profonda
---

# UltraPlan - Deep Planning Protocol v2

Enhanced with research, hypothesis testing, and ecosystem integration.

## Iron Law

**ALL OUTPUT GOES INTO `.sisyphus/plans/{plan-slug}/` AS SEPARATE FILES — `overview.md`, `plan.md`, `hypotheses/`, `tasks/*.md`, `state.json`.**

This multi-file structure enables:
- `overview.md` — executive summary for quick review
- `plan.md` — full analysis and recommendations
- `hypotheses/*.md` — each hypothesis with validation results
- `tasks/*.md` — executable task breakdown
- `state.json` — status tracking for execution

---

## When to Use

- Complex architectural decisions (microservices split, database migration)
- Large refactoring spanning multiple modules
- Strategic planning where multiple approaches need evaluation
- When standard planning produces vague or incomplete results
- Tasks requiring research across unfamiliar domains
- Decisions affecting multiple plugins/skills in the ecosystem

---

## Integration with Ecosystem

UltraPlan integrates with the post-leak plugin ecosystem:

| Plugin | Integration Point |
|--------|-------------------|
| **memory-index-reader** | Reads MEMORY.md for context, updates after planning |
| **autodream** | Logs planning activity for idle-time consolidation |
| **kairos** | Reports findings to kairos for bug detection and commit prep |
| **skill-auto-activator** | Auto-activates relevant skills during research |

---

## Protocol

### PHASE 0: Context Gathering (PARALLEL)

**Execute ALL of these IN PARALLEL:**

#### 0.1 Read Memory Context
```bash
# Read MEMORY.md for relevant context
cat ~/.config/opencode/memory/MEMORY.md

# Read related topics
cat ~/.config/opencode/memory/topics/{relevant-topic}.md
```

#### 0.2 Explore Codebase (Background Agent)
```bash
task(subagent_type="explore", run_in_background=true, load_skills=[], 
  prompt="Analyze the codebase for [TASK CONTEXT]. Find:
1. Related modules and their relationships
2. Existing patterns and conventions
3. Potential blockers or dependencies
4. Similar past implementations (for reference)

Focus on: src/, lib/, patterns/
Return: File paths, architecture patterns, potential issues.")
```

#### 0.3 Research External Context (Background Agent)
```bash
task(subagent_type="librarian", run_in_background=true, load_skills=[],
  prompt="Research [TECHNOLOGY/TOPIC] for [TASK CONTEXT]. Find:
1. Official documentation and best practices
2. Common patterns and anti-patterns
3. Known issues and workarounds
4. Recent developments or version changes

Search for: official docs, OSS implementations, expert opinions
Return: Key findings with sources.")
```

#### 0.4 Check for Relevant Skills
```bash
# Check if relevant skills exist in archive
cat ~/opencode-ecosystem/skills/.archive-index.json | grep -i "[relevant-keyword]"

# If found, activate the skill
~/opencode-ecosystem/skills/activate-skill [skill-name]
```

---

### PHASE 1: Hypothesis Generation

After research completes, generate multiple hypotheses.

#### 1.1 Define at Least 3 Approaches

For each approach, document:
```
## Hypothesis {N}: [Approach Name]

### Description
[What this approach entails]

### Pros
- [Pro 1]
- [Pro 2]

### Cons
- [Con 1]
- [Con 2]

### Complexity (1-10): {N}
### Risk Level (1-10): {N}
### Time Estimate: {X-Y hours/days}

### Assumptions
- [Assumption 1]
- [Assumption 2]

### Validation Method
[How to test if this approach works]
```

#### 1.2 Save Hypotheses to Files
```bash
mkdir -p .sisyphus/plans/{plan-slug}/hypotheses/

# Save each hypothesis to hypotheses/{n}-{slug}.md
```

---

### PHASE 2: Hypothesis Testing

#### 2.1 Test Each Hypothesis

For each hypothesis, perform validation:

```bash
# Codebase validation
grep -r "[pattern]" src/ --include="*.py" --include="*.js" | head -20

# Pattern validation
ast_grep_search(pattern="[code-pattern]", lang="[language]")

# Dependency check
[language-specific dependency check]
```

#### 2.2 Document Validation Results

```
## Validation Results: Hypothesis {N}

### Test 1: [Test Name]
- Command: [What was run]
- Result: [What was found]
- Verdict: PASS | FAIL | PARTIAL

### Test 2: [Test Name]
- Command: [What was run]
- Result: [What was found]
- Verdict: PASS | FAIL | PARTIAL

### Overall Verdict: [PASS|FAIL]
### Confidence: [Low|Medium|High]
```

---

### PHASE 3: Deep Analysis (Remote Model)

#### 3.1 Prepare Context for Remote Model

Create context document:
```bash
cat > /tmp/ultraplan-context.md << 'EOF'
# Task Analysis Context

## Task Description
[TASK]

## Current Codebase State
[PWD, git status, main files involved]

## Memory Context
[Relevant entries from MEMORY.md]

## Research Findings
[Summarized from Phase 0]

## Hypothesis Validation Results
[Summarized from Phase 2]

## Constraints
- RAM: [limit]
- Time: [limit]
- Dependencies: [list]

## Success Criteria
[What "done" looks like]
EOF
```

#### 3.2 Send to Remote Model

Use the remote model (qwen-3.6-plus-free) with these instructions:

```
Analyze this task deeply. Do NOT give a quick answer.

## Task
[TASK from context]

## Research Context
[Findings from Phase 0]

## Hypothesis Validation
[Results from Phase 2]

## Instructions
1. Evaluate each hypothesis against the research findings
2. Identify the BEST approach with detailed reasoning
3. Explore at least 3 alternative approaches not yet considered
4. For each approach, analyze:
   - Implementation complexity (1-10)
   - Risk level (1-10)
   - Time estimate (realistic range)
   - Dependencies and blockers
   - Rollback strategy
5. Recommend the best approach with explicit trade-off analysis
6. Generate a step-by-step implementation plan with:
   - Each step as a numbered item
   - Estimated time per step
   - Files to modify (exact paths)
   - Verification method per step
   - Potential failure points and mitigation

## Output Format
Return a JSON object + markdown:
{
  "recommended_approach": "...",
  "approaches_analysis": [...],
  "implementation_plan": [...],
  "risks": [...],
  "success_metrics": [...]
}

Plus detailed markdown explanation.
```

---

### PHASE 4: Generate Plan Files

#### 4.1 Create Directory Structure
```bash
PLAN_SLUG=$(echo "[task-name]" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
mkdir -p .sisyphus/plans/$PLAN_SLUG/{hypotheses,tasks}
```

#### 4.2 Generate overview.md

```markdown
# Plan: {Task Name}

**Created:** {date}
**Status:** {planning|ready|in-progress|completed}
**Complexity:** {Low|Medium|High}
**Estimated Time:** {X-Y hours/days}

## Executive Summary
[2-3 sentence overview]

## Recommended Approach
[Name and brief rationale]

## Key Decisions
- [Decision 1]
- [Decision 2]

## Task Breakdown
| # | Task | Status | Time |
|---|------|--------|------|
| 1 | {task-1} | [ ] | ~{n}h |
| 2 | {task-2} | [ ] | ~{n}h |

## Risks
- [Risk 1] — Mitigation: [how]
- [Risk 2] — Mitigation: [how]

## Next Steps
1. Review this plan
2. Run `/start-work $PLAN_SLUG` to begin execution
```

#### 4.3 Generate plan.md

Full analysis document with:
- Detailed approach comparison
- Architecture decisions
- Dependency graph
- Implementation strategy
- Risk analysis

#### 4.4 Generate task files

Each task in `tasks/{task-id}.md`:
```markdown
# Task: {Task Title}

**Status:** pending | in-progress | completed
**Estimated Time:** ~{n}h
**Depends On:** {task-ids or "none"}

## Goal
[What this task accomplishes]

## Files Involved
- Create: [files]
- Modify: [files]
- Delete: [files]

## Steps
1. [Step with command examples]
2. [Step with command examples]

## Verification
[How to verify this task is done]

## Rollback
[How to undo if something goes wrong]
```

#### 4.5 Initialize state.json

```json
{
  "plan": "{plan-slug}",
  "created": "{ISO timestamp}",
  "updated": "{ISO timestamp}",
  "status": "planning",
  "complexity": "medium",
  "estimated_hours": 8,
  "approaches_evaluated": 3,
  "recommended_approach": "{approach-name}",
  "execution_order": ["task-1", "task-2", ...],
  "progress": {
    "total_tasks": 5,
    "completed": 0,
    "in_progress": 0,
    "pending": 5
  },
  "tasks": [
    {
      "id": "task-1",
      "title": "Task 1",
      "status": "pending",
      "started_at": null,
      "completed_at": null,
      "commits": []
    }
  ],
  "metadata": {
    "created_by": "ultraplan",
    "version": "2.0",
    "model_used": "qwen-3.6-plus-free"
  }
}
```

---

### PHASE 5: Memory Integration

#### 5.1 Log Planning Activity
```bash
echo "[$(date +%Y-%m-%d)] UltraPlan: {plan-name} - {status}" >> ~/.config/opencode/memory/raw/observations.log
```

#### 5.2 Update MEMORY.md (via memory-index-reader)
```bash
# Add pointer if plan is significant
python3 ~/.config/opencode/memory/strict_write.py add \
  "planning" \
  "Plan: {plan-name} - {N} tasks, ~{X}h" \
  "topics/plans.md"
```

#### 5.3 Notify Kairos
```bash
# Kairos will pick up the planning activity on next scan
echo "[$(date +%Y-%m-%d)] Planned: {plan-name}" >> ~/.config/opencode/memory/raw/kairos-activity.log
```

---

### PHASE 6: Present to User

Display:
```
╔══════════════════════════════════════════════════════════════╗
║                    ULTRAPLAN GENERATED                      ║
╠══════════════════════════════════════════════════════════════╣
║ Plan: {plan-name}                                           ║
║ Slug: {plan-slug}                                           ║
║ Approaches Evaluated: {N}                                    ║
║ Recommended: {approach-name}                                ║
║                                                             ║
║ Complexity: {Low|Medium|High} ({X}/10)                     ║
║ Risk: {Low|Medium|High} ({X}/10)                           ║
║ Estimated Time: {X-Y hours/days}                            ║
║                                                             ║
║ Tasks: {N}                                                  ║
╠══════════════════════════════════════════════════════════════╣
║ Location: .sisyphus/plans/{plan-slug}/                     ║
╠══════════════════════════════════════════════════════════════╣
║ Files Generated:                                            ║
║   ✓ overview.md (executive summary)                        ║
║   ✓ plan.md (full analysis)                                ║
║   ✓ hypotheses/*.md ({N} hypotheses)                        ║
║   ✓ tasks/*.md ({N} task files)                            ║
║   ✓ state.json (tracking)                                  ║
╠══════════════════════════════════════════════════════════════╣
║ Next: /start-work {plan-slug}                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Execution

### /start-work {plan-slug}

To execute the plan:
```bash
# Read state.json
cat .sisyphus/plans/{plan-slug}/state.json

# Execute tasks in order from execution_order[]
# For each task:
#   1. Read tasks/{task-id}.md
#   2. Execute steps
#   3. Verify with method in Verification section
#   4. Update state.json with completion
#   5. Commit changes (optional: use git-atomic-committer)

# Mark plan complete when all tasks done
# Update MEMORY.md with results
```

---

## Validation Checklist

- [ ] Phase 0: Context gathered (memory, explore, librarian)
- [ ] Phase 1: At least 3 hypotheses defined
- [ ] Phase 2: Each hypothesis validated against codebase
- [ ] Phase 3: Remote model analysis complete
- [ ] Phase 4: All files generated (overview, plan, tasks, state.json)
- [ ] Phase 5: Memory updated (observations.log, MEMORY.md if applicable)
- [ ] Phase 6: Summary presented to user
- [ ] Directory structure: `.sisyphus/plans/{slug}/` with all required files
- [ ] Each task has: Goal, Files Involved, Steps, Verification, Rollback
- [ ] State tracking enabled via state.json

---

## Anti-Patterns (Avoid These)

| Anti-Pattern | Why It's Wrong | Correct Approach |
|--------------|----------------|------------------|
| Quick answer without research | Misses context and trade-offs | Always run Phase 0 research |
| Single approach without alternatives | No basis for decision | Generate 3+ hypotheses |
| Hypotheses not tested | Assumptions may be wrong | Validate against codebase |
| Single file output | Can't track task status | Multi-file structure |
| No memory integration | Planning activity lost | Log to observations.log |
| No rollback strategy | Unrecoverable failures | Always document rollback |

---

## Coordination with Other Skills

| Skill | Coordination |
|-------|--------------|
| **code-forge-plan** | Use when input is a feature spec doc; use ultraplan for complex/novel problems |
| **memory-index-reader** | Read MEMORY.md first, update after planning |
| **git-atomic-committer** | Commit after each task completion |
| **skill-auto-activator** | Auto-activate relevant skills during research phase |

---

## Notes

1. **Time Budget**: UltraPlan itself should take ~15-30 minutes for complex tasks
2. **Context Preservation**: The multi-file structure preserves context for future reference
3. **Memory Integration**: Planning activity feeds into autodream for idle-time consolidation
4. **Kairos Integration**: Planned work is visible to kairos for commit preparation
5. **Iteration**: Plans can be regenerated if context changes significantly
