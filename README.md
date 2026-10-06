# pstack portable

Engineering workflows for **Claude Code** and **Codex**: understand a codebase, explore competing designs, review changes, and keep a verifiable record of the work.

An independent port of [pstack](https://github.com/cursor/plugins/tree/main/pstack), created by **Lauren Tan** and released under the MIT License. This port adapts its skills and agent workflows to each host.

**Status:** early release. Both packages contain 46 skills and have passed local packaging and static checks. End-to-end installation and agent execution have not yet been verified on either host.

## Install

Install and sign in to Claude Code or Codex first, using a version that supports plugins. Run the command for your host in Bash on macOS, Linux, or Windows with Git Bash. Requires curl and tar; no repository clone is needed.

### Claude Code

```bash
curl -fsSL https://raw.githubusercontent.com/sonusharma26/pstack-portable/main/install.sh | bash -s -- claude-code
```

### Codex

```bash
curl -fsSL https://raw.githubusercontent.com/sonusharma26/pstack-portable/main/install.sh | bash -s -- codex
```

These commands download and run [install.sh](install.sh). The installer downloads the GitHub archive, registers the local marketplace, and installs pstack for the selected host. For Codex, it also copies the custom agent definitions, preserving existing files.

Downloaded packages stay under `${XDG_DATA_HOME:-$HOME/.local/share}/pstack-portable`. Keep the directory printed by the installer: it is the local marketplace source. Codex agents go to `${CODEX_HOME:-$HOME/.codex}/agents`.

## Start using pstack

Start a new session after installation.

**Claude Code:**

```text
/pstack:how Explain how authentication works in this project.
/pstack:interrogate Review the current changes for correctness and regressions.
```

Bundled agents are registered as `pstack:poteto-agent` and `pstack:comment-sicko`.

**Codex:** open `/skills`, select pstack's `how` or `interrogate` skill, and describe the task. If an agent's configured model is unavailable on your account, choose an available model in its installed TOML file before using that workflow.

Installation follows the hosts' documented [Claude Code marketplace flow](https://code.claude.com/docs/en/plugin-marketplaces), [Codex plugin commands](https://learn.chatgpt.com/docs/developer-commands), and [Codex custom-agent locations](https://learn.chatgpt.com/docs/agent-configuration/subagents).

## What is included

| Workflow | Purpose |
|---|---|
| `how` / `why` | Trace behavior and investigate the reasons behind a design. |
| `architect` / `arena` | Explore alternative designs or implementations and synthesize a result. |
| `interrogate` | Review changes through independent reviewer seats. |
| `swarm` | Split exploration, checks, or implementation into bounded parallel work. |
| `figure-it-out` | Plan and execute work that needs a tailored workflow. |
| `show-me-your-work` | Keep an evidence-backed decision log. |
| `recall` / `reflect` | Recover working context and propose improvements to skills. |
| `poteto-mode` | Apply the broader pstack engineering workflow. |

The packages also include engineering principles, testing and benchmarking guidance, writing skills, and task playbooks. See the full skill lists for [Claude Code](dist/claude-code/skills) and [Codex](dist/codex/skills).

## Models and permissions

- **Claude Code:** override model roles in your project's `.pstack/models.md`, with one `role: value` per line, such as `deep-code: opus`. See the [Claude Code runtime](dist/claude-code/skills/pstack-runtime/SKILL.md).
- **Codex:** edit `model` and `model_reasoning_effort` in the installed custom agent files. `.pstack/models.md` does not configure Codex. See the [Codex runtime](dist/codex/skills/pstack-runtime/SKILL.md).
- Writing candidates use isolated checkouts. Reviewers stay read-only, and every worker must preserve the user's scope and approval gates.
- External writes require authorization for the action and target. Unattended work does not supply missing permission.
- Cross-host review is disabled by default. It requires explicit authorization to use the other provider and share the evidence. Codex-to-Claude review uses a tool-free invocation; Claude-to-Codex review requires an operator-provided, verified restricted profile. Without the required authorization or restrictions, use same-family reviewers and report that limitation.

## Scope and limitations

This release ports the core skills and selected playbooks. It does not include upstream's babysitting, shipping, autonomous-run, orchestration, autopilot, session-pickup, pause-safely, multi-phase-plan, worktree-cleanup, or Benny automation workflows.

Some workflows need Git history, authenticated forge tooling, or connected MCP services. Missing capabilities should be reported. Same-family panels do not provide the same diversity as panels using different model families.

## Repository layout

| Path | Contents |
|---|---|
| `install.sh` | Single-command installer for either host. |
| `core/` | Shared skills, agent instructions, and runtime vocabulary. |
| `hosts/` | Host adapters, agent settings, and package manifests. |
| `dist/claude-code/` | Ready-to-install Claude Code package. |
| `dist/codex/` | Ready-to-install Codex package and custom agent definitions. |
| `.claude-plugin/marketplace.json` | Claude Code marketplace entry. |
| `.agents/plugins/marketplace.json` | Codex marketplace entry. |

Packages install directly from `dist/`; no build step is required. When contributing changes, keep shared source and both packaged copies aligned, and reflect host-specific changes in the matching package. On upgrades, compare the supplied Codex agent definitions with your installed copies before replacing customized files.

## Credits and license

Original pstack by **Lauren Tan**, from [`cursor/plugins`](https://github.com/cursor/plugins/tree/4e5b1cf2ccb0ea3716f08c8ee0a5856b5ab93536/pstack), version **0.15.10**, commit `4e5b1cf2ccb0ea3716f08c8ee0a5856b5ab93536`.

Portable adaptation maintained at [sonusharma26/pstack-portable](https://github.com/sonusharma26/pstack-portable). This is an independent project and is not affiliated with Cursor, Anthropic, or OpenAI.

[MIT License](LICENSE). The original copyright and license notice are retained in each distributed package.
