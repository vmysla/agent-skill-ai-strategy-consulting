#!/usr/bin/env bash
#
# AI Strategy Consulting — portable skill installer (macOS / Linux)
#
# Installs the skill for any of: Claude Code, Codex CLI, Gemini CLI.
# Auto-detects installed tools by default; override with --tools.
#
# Usage:
#   curl -fsSL https://www.emergingaisolutions.com/install.sh | bash
#   curl -fsSL https://www.emergingaisolutions.com/install.sh | bash -s -- --tools claude,codex
#   ./install.sh --tools all
#
set -euo pipefail

REPO_URL="${AISC_REPO_URL:-https://github.com/vmysla/agent-skill-ai-strategy-consulting.git}"
SKILL_NAME="ai-strategy-consulting"

info()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
ok()    { printf '\033[1;32m✔\033[0m  %s\n' "$*"; }
warn()  { printf '\033[1;33m!\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m✘\033[0m  %s\n' "$*" >&2; }

TOOLS_ARG="auto"
while [ $# -gt 0 ]; do
  case "$1" in
    --tools)
      TOOLS_ARG="${2:-}"
      shift 2
      ;;
    --tools=*)
      TOOLS_ARG="${1#--tools=}"
      shift
      ;;
    -h|--help)
      sed -n '3,10p' "$0"
      exit 0
      ;;
    *)
      err "Unknown argument: $1"
      exit 1
      ;;
  esac
done

detect_tools() {
  local detected=()
  command -v claude   >/dev/null 2>&1 && detected+=("claude")
  command -v codex    >/dev/null 2>&1 && detected+=("codex")
  command -v gemini   >/dev/null 2>&1 && detected+=("gemini")
  [ -d "${HOME}/.claude"  ] && [[ ! " ${detected[*]} " =~ " claude " ]] && detected+=("claude")
  [ -d "${HOME}/.codex"   ] && [[ ! " ${detected[*]} " =~ " codex "  ]] && detected+=("codex")
  [ -d "${HOME}/.gemini"  ] && [[ ! " ${detected[*]} " =~ " gemini " ]] && detected+=("gemini")
  printf '%s\n' "${detected[@]:-}"
}

case "$TOOLS_ARG" in
  auto)
    mapfile -t TOOLS < <(detect_tools)
    if [ "${#TOOLS[@]}" -eq 0 ]; then
      warn "No agent tools auto-detected. Installing for all three (claude, codex, gemini)."
      TOOLS=(claude codex gemini)
    fi
    ;;
  all)
    TOOLS=(claude codex gemini)
    ;;
  *)
    IFS=',' read -r -a TOOLS <<<"$TOOLS_ARG"
    ;;
esac

for t in "${TOOLS[@]}"; do
  case "$t" in
    claude|codex|gemini) ;;
    *) err "Unknown tool: $t (valid: claude, codex, gemini, all)"; exit 1 ;;
  esac
done

if ! command -v git >/dev/null 2>&1; then
  err "git is required but was not found on your PATH."
  err "Install git and retry (https://git-scm.com/downloads)."
  exit 1
fi

SCRIPT_DIR=""
if [ -f "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/skills/$SKILL_NAME" ]; then
  SRC_ROOT="$SCRIPT_DIR"
  info "Using local checkout at $SRC_ROOT"
else
  TMP_DIR="$(mktemp -d -t ai-strategy-consulting-XXXXXX)"
  trap 'rm -rf "$TMP_DIR"' EXIT
  info "Cloning ${REPO_URL}"
  git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR/repo"
  SRC_ROOT="$TMP_DIR/repo"
fi

install_claude() {
  local src="$SRC_ROOT/skills/$SKILL_NAME"
  local dest_dir="${HOME}/.claude/skills"
  local dest="$dest_dir/$SKILL_NAME"
  [ -d "$src" ] || { err "Missing source: $src"; return 1; }
  mkdir -p "$dest_dir"
  rm -rf "$dest"
  cp -R "$src" "$dest"
  ok "Claude Code: $dest"
}

install_codex() {
  local src="$SRC_ROOT/codex/prompts/$SKILL_NAME.md"
  local dest_dir="${HOME}/.codex/prompts"
  [ -f "$src" ] || { err "Missing source: $src"; return 1; }
  mkdir -p "$dest_dir"
  cp "$src" "$dest_dir/"
  ok "Codex CLI: $dest_dir/$SKILL_NAME.md"
}

install_gemini() {
  local src="$SRC_ROOT/gemini/commands/$SKILL_NAME.toml"
  local dest_dir="${HOME}/.gemini/commands"
  [ -f "$src" ] || { err "Missing source: $src"; return 1; }
  mkdir -p "$dest_dir"
  cp "$src" "$dest_dir/"
  ok "Gemini CLI: $dest_dir/$SKILL_NAME.toml"
}

info "Installing AI Strategy Consulting skill for: ${TOOLS[*]}"
for t in "${TOOLS[@]}"; do
  case "$t" in
    claude) install_claude ;;
    codex)  install_codex  ;;
    gemini) install_gemini ;;
  esac
done

echo
ok "Done. Restart your agent (or start a new session) to activate the skill."
echo "Invoke manually with: /${SKILL_NAME} <your question>"
