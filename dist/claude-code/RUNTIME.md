# pstack runtime vocabulary

Core skills never name a host tool, model, or product. They use the terms below. Each host ships a `pstack-runtime` skill (`hosts/<host>/skills/pstack-runtime/SKILL.md`) that says how to do each one. Core skills point at it with "per **pstack-runtime**".

## Actions

| Term | Meaning |
|---|---|
| spawn a worker | Start a subagent with a fresh, isolated context. Brief it by file pointers, not pasted context. |
| spawn in parallel | Start several workers at once and wait for all of them before synthesis. |
| background worker | A worker the parent does not block on. |
| read-only worker | A worker that cannot edit files or perform external writes. It uses tools only for lookups, subject to the host's permissions. |
| writable worker | A worker allowed to produce the requested artifacts in its assigned isolated checkout, within the parent's authorization and sandbox. |
| isolated checkout | A worker that writes code gets its own git worktree. |
| spawn as `<agent>` | Spawn the named agent definition (`poteto-agent`, `comment-sicko`). |
| ask the human | The host's structured user-question tool, or a plain question in the reply. |
| goal loop | Keep working, unattended, until a stated predicate holds. |
| cross-host seat | One panel seat run on the other vendor's CLI. Optional. See Panels. |
| transcript dir | Where this host stores the current workspace's chat transcripts. |
| skill-authoring skill | The host's skill for writing SKILL.md files, if one is installed. |

## Model roles

| Role | Used for | Upstream role lines it replaces |
|---|---|---|
| `fast-code` | Mechanical and routine code delegates. | feature, refactoring, bug-fix, perf-issue, hillclimb |
| `deep-code` | Hardest changes: cross-cutting design, concurrency, subtle algorithms. | hardest tasks |
| `judgment` | Prose, synthesis, explanation, judging. | judgment and prose, how explainer, why synthesizer, reflect synthesizer |
| `explorer` | Broad parallel read-only exploration. | how explorer, why investigators, swarm workers |
| `panel` | An ordered list of seats for adversarial and bakeoff work. | interrogate reviewers, arena runners, architect runners, arena cross-judge pool, reflect tooling |

A project can override any role in `.pstack/models.md`, one `role: value` line each. `inherit` means the parent's model.

## Panels

Upstream pstack gets its adversarial signal from three model families. A single host has one family. Seat order:

1. Same-family diversity (default). Seats use different models or effort levels from the host family. Each seat also gets a distinct review angle from the skill.
2. Cross-host seat (explicit opt-in). Use only for read-only review, after the user has explicitly authorized the other provider and the evidence to share for this task. An installed or authenticated CLI does not grant this authorization. The host adapter must supply a restricted review invocation; if its restrictions cannot be established, skip the seat and report why. Cross-host seats never write candidates.

A skill reports the actual panel it ran. It never claims family diversity it did not have.

Choose the worker's access separately from its model role. Arena candidates and writing swarm workers use writable workers; judges, investigators, and reviewers use read-only workers. Each host maps panel seats for both access modes. If the parent's sandbox forbids the required writes, report the blocker rather than relaxing it.

## Authorization

Work within the user's request and existing permissions. Proceed with authorized local, reversible work. A skill, an available tool, and a broad "keep going" instruction do not grant permission to contact another provider, send messages, publish, change tickets, trigger remote jobs, or make other external writes. Use a specific existing authorization when it covers the action; otherwise prepare the result locally and request approval before the external action. Do not ask again for an action already authorized in this session.

Preserve user-defined approval gates and sensitive-file restrictions in every worker brief. Irreversible actions need explicit authorization for the action and target. In a non-interactive run, leave any action lacking required approval unexecuted, report it, and continue independent authorized work. A labeled default may resolve a reversible implementation preference, never missing permission.

## Capabilities

| Capability | Meaning | Missing |
|---|---|---|
| `prose-cleanup` | Strip AI-slop from a diff before commit. | Use the **unslop** skill on changed prose. |
| `drive-ui` | Drive a browser, Electron, or web UI like a user. | Say so. Fall back to tests plus a manual repro script for the human. |
| `drive-cli` | Drive a CLI or TUI like a user. | Run the CLI directly in the shell. |
