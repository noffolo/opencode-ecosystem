---
name: qa-gate
description: Skill to enforce strict code quality through an automated gate process.
triggers: qa-gate, verify work, check slop
---
# QA-Gate Skill

## Overview
The `qa-gate` skill is a core component of the 'Anti-Slop Barrier'. It automatically enforces high code quality by running an initial gate-check and iteratively fixing issues until the code passes or exceeds a predefined number of attempts.

## Instructions for Agents
When invoked, agents must execute the following bash script:

`bash ~/.config/opencode/skill/qa-gate/gate-check.sh`

**Note:** The agent should read the `stdout` from this script. If the script exits with code 1 (errors found), the agent must iteratively fix the issues in those files, up to three strikes or until no errors remain.

If the script completes successfully (`exit code 0`), the agent can confidently mark the task as complete without any additional actions.