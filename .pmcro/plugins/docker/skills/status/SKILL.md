---
name: status
description: Inspect Docker CLI and daemon status through a bounded dry-run-first command. Use when a workflow needs to know whether Docker is available before planning container work.
---

# status

## Inputs
Require no secrets and no image mutation intent.

## Workflow
1. Run `scripts/operate.ps1` without `-Execute` first.
2. Use `-Execute` only for the read-only Docker version/status query.
3. Return the client/server evidence or the observed failure. Do not install or repair Docker from this skill.

## Boundaries
This skill is read-only. It does not build, pull, push, remove, start, or stop containers.
