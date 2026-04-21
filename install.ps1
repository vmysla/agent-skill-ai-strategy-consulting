# AI Strategy Consulting — portable skill installer (Windows PowerShell)
#
# Installs the skill for any of: Claude Code, Codex CLI, Gemini CLI.
# Auto-detects installed tools by default; override with -Tools.
#
# Usage:
#   powershell -c "irm https://www.emergingaisolutions.com/install.ps1 | iex"
#   powershell -c "& { iex (irm https://www.emergingaisolutions.com/install.ps1); } -Tools claude,codex"
#   .\install.ps1 -Tools all

param(
    [string[]]$Tools = @('auto')
)

$ErrorActionPreference = 'Stop'

$RepoUrl   = if ($env:AISC_REPO_URL) { $env:AISC_REPO_URL } else { 'https://github.com/vmysla/agent-skill-ai-strategy-consulting.git' }
$SkillName = 'ai-strategy-consulting'

function Write-Info($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "OK  $msg" -ForegroundColor Green }
function Write-Warn2($msg){ Write-Host "!   $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "ERR $msg" -ForegroundColor Red }

function Get-DetectedTools {
    $detected = @()
    if (Get-Command claude -ErrorAction SilentlyContinue) { $detected += 'claude' }
    if (Get-Command codex  -ErrorAction SilentlyContinue) { $detected += 'codex'  }
    if (Get-Command gemini -ErrorAction SilentlyContinue) { $detected += 'gemini' }
    if ((Test-Path (Join-Path $HOME '.claude')) -and ($detected -notcontains 'claude')) { $detected += 'claude' }
    if ((Test-Path (Join-Path $HOME '.codex'))  -and ($detected -notcontains 'codex'))  { $detected += 'codex'  }
    if ((Test-Path (Join-Path $HOME '.gemini')) -and ($detected -notcontains 'gemini')) { $detected += 'gemini' }
    return $detected
}

# Resolve tool selection (supports comma-separated strings or arrays)
$raw = ($Tools -join ',').ToLower()
if ($raw -eq 'auto' -or [string]::IsNullOrWhiteSpace($raw)) {
    $Selected = Get-DetectedTools
    if ($Selected.Count -eq 0) {
        Write-Warn2 'No agent tools auto-detected. Installing for all three (claude, codex, gemini).'
        $Selected = @('claude', 'codex', 'gemini')
    }
}
elseif ($raw -eq 'all') {
    $Selected = @('claude', 'codex', 'gemini')
}
else {
    $Selected = $raw -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

foreach ($t in $Selected) {
    if ($t -notin @('claude', 'codex', 'gemini')) {
        Write-Err "Unknown tool: $t (valid: claude, codex, gemini, all)"
        exit 1
    }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Err 'git is required but was not found on your PATH.'
    Write-Err 'Install git and retry (https://git-scm.com/download/win).'
    exit 1
}

# Determine source root (local checkout if available, else clone)
$ScriptDir = $null
if ($PSCommandPath) {
    $ScriptDir = Split-Path -Parent $PSCommandPath
}

if ($ScriptDir -and (Test-Path (Join-Path $ScriptDir "skills\$SkillName"))) {
    $SrcRoot = $ScriptDir
    Write-Info "Using local checkout at $SrcRoot"
    $TmpDir = $null
}
else {
    $TmpDir = Join-Path $env:TEMP ("ai-strategy-consulting-" + [guid]::NewGuid().Guid)
    New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null
    Write-Info "Cloning $RepoUrl"
    & git clone --depth 1 --quiet $RepoUrl (Join-Path $TmpDir 'repo')
    if ($LASTEXITCODE -ne 0) { throw 'git clone failed' }
    $SrcRoot = Join-Path $TmpDir 'repo'
}

function Install-Claude {
    $src = Join-Path $SrcRoot "skills\$SkillName"
    $destDir = Join-Path $HOME '.claude\skills'
    $dest = Join-Path $destDir $SkillName
    if (-not (Test-Path $src)) { Write-Err "Missing source: $src"; return }
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse $src $dest
    Write-Ok "Claude Code: $dest"
}

function Install-Codex {
    $src = Join-Path $SrcRoot "codex\prompts\$SkillName.md"
    $destDir = Join-Path $HOME '.codex\prompts'
    if (-not (Test-Path $src)) { Write-Err "Missing source: $src"; return }
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Copy-Item -Force $src $destDir
    Write-Ok "Codex CLI: $(Join-Path $destDir ("$SkillName.md"))"
}

function Install-Gemini {
    $src = Join-Path $SrcRoot "gemini\commands\$SkillName.toml"
    $destDir = Join-Path $HOME '.gemini\commands'
    if (-not (Test-Path $src)) { Write-Err "Missing source: $src"; return }
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Copy-Item -Force $src $destDir
    Write-Ok "Gemini CLI: $(Join-Path $destDir ("$SkillName.toml"))"
}

Write-Info ("Installing AI Strategy Consulting skill for: " + ($Selected -join ', '))

try {
    foreach ($t in $Selected) {
        switch ($t) {
            'claude' { Install-Claude }
            'codex'  { Install-Codex  }
            'gemini' { Install-Gemini }
        }
    }

    Write-Host ''
    Write-Ok 'Done. Restart your agent (or start a new session) to activate the skill.'
    Write-Host "Invoke manually with: /$SkillName <your question>"
}
finally {
    if ($TmpDir -and (Test-Path $TmpDir)) {
        Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
    }
}
