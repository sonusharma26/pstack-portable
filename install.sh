#!/usr/bin/env bash
# MIT License. Downloads a local marketplace; does not require Git.
# Keep execution inside main so a partial curl download cannot start installation.
pstack_install() (
  set -euo pipefail

  if [ "$#" -ne 1 ]; then
    printf 'Usage: bash install.sh <claude-code|codex>\n' >&2
    exit 2
  fi
  case "$1" in
    claude-code) pstack_cli=claude ;;
    codex) pstack_cli=codex ;;
    *) printf 'Choose claude-code or codex.\n' >&2; exit 2 ;;
  esac

  for pstack_dependency in curl tar mktemp "$pstack_cli"; do
    if ! command -v "$pstack_dependency" >/dev/null 2>&1; then
      printf 'Required command not found: %s\n' "$pstack_dependency" >&2
      exit 1
    fi
  done

  pstack_base="${PSTACK_INSTALL_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/pstack-portable}"
  mkdir -p "$pstack_base"
  pstack_base="$(cd "$pstack_base" && pwd -P)"
  # Each download gets its own persistent directory. Existing files are untouched.
  pstack_package="$(mktemp -d "$pstack_base/package.XXXXXXXX")"
  trap 'printf "Installation did not finish. Download directory: %s\n" "$pstack_package" >&2' ERR

  printf 'Downloading pstack from GitHub...\n'
  curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    https://api.github.com/repos/sonusharma26/pstack-portable/tarball/main \
    --output "$pstack_package/source.tar.gz"
  tar -xzf "$pstack_package/source.tar.gz" --strip-components=1 -C "$pstack_package"
  rm -f "$pstack_package/source.tar.gz"

  if [ "$1" = claude-code ]; then
    test -f "$pstack_package/.claude-plugin/marketplace.json"
    test -f "$pstack_package/dist/claude-code/.claude-plugin/plugin.json"
    claude plugin marketplace add "$pstack_package"
    claude plugin install pstack@pstack-portable
  else
    test -f "$pstack_package/.agents/plugins/marketplace.json"
    test -f "$pstack_package/dist/codex/plugin.json"
    pstack_agents=("$pstack_package"/dist/codex/agents/*.toml)
    test -f "${pstack_agents[0]}"
    codex plugin marketplace add "$pstack_package"
    codex plugin add pstack@pstack-portable

    pstack_agent_dir="${PSTACK_AGENT_DIR:-${CODEX_HOME:-$HOME/.codex}/agents}"
    mkdir -p "$pstack_agent_dir"
    for pstack_agent in "${pstack_agents[@]}"; do
      pstack_target="$pstack_agent_dir/${pstack_agent##*/}"
      if [ -e "$pstack_target" ] || [ -L "$pstack_target" ]; then
        printf 'Keeping existing agent: %s\n' "$pstack_target"
      else
        # noclobber also preserves a file created concurrently with this install.
        (set -o noclobber; cat "$pstack_agent" > "$pstack_target")
      fi
    done
  fi

  trap - ERR
  printf 'Installed pstack for %s. Start a new session to use it.\n' "$1"
  printf 'Keep this local marketplace directory: %s\n' "$pstack_package"
)

pstack_install "$@"
