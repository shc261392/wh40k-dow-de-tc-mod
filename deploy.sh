#!/usr/bin/env bash
# =============================================================================
# deploy.sh — WH40K DoW:DE Traditional Chinese Locale Mod deployer
#
# Supports:
#   • Linux (native Steam + Proton)
#   • WSL2 (Windows Subsystem for Linux — accesses Windows paths via /mnt/c ...)
#
# Usage:
#   bash deploy.sh [--game-dir PATH] [--dry-run] [--no-backup] [--help]
#
# What it does:
#   1. Auto-detect the game installation directory
#   2. Create a timestamped backup of existing mod targets + EnginLoc.sga
#   3. Apply font-fix via Python (writes patched .fnt files to data/font/)
#   4. Copy data/, Engine.ucs to the game's Engine/Locale/Chinese/
#   5. Disable EnginLoc.sga (rename to .disabled) so the game loads data/ instead
#
# Run: make deploy  —OR—  bash deploy.sh
# =============================================================================
set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

# ── Script location = repo root ───────────────────────────────────────────────
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Defaults ─────────────────────────────────────────────────────────────────
GAME_DIR=""
DRY_RUN=false
NO_BACKUP=false
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${REPO_ROOT}/backup"
MANIFEST_FILE="${BACKUP_DIR}/deploy_manifest_${STAMP}.txt"

# ── Game folder name (case-insensitive search) ────────────────────────────────
GAME_FOLDER_NAME="Dawn of War Definitive Edition"

# ── Files / dirs to deploy (relative to repo root) ───────────────────────────
DEPLOY_DIRS=(data)
DEPLOY_FILES=(Engine.ucs)

# ── Target sub-path inside game root ─────────────────────────────────────────
LOCALE_SUBPATH="Engine/Locale/Chinese"

# ─────────────────────────────────────────────────────────────────────────────
log()   { printf "${CYAN}▶${RESET} %s\n" "$*"; }
ok()    { printf "${GREEN}✓${RESET} %s\n" "$*"; }
warn()  { printf "${YELLOW}⚠${RESET}  %s\n" "$*"; }
err()   { printf "${RED}✗${RESET}  %s\n" "$*" >&2; }
die()   { err "$*"; exit 1; }

# ─────────────────────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
Usage: bash deploy.sh [OPTIONS]

Options:
  --game-dir PATH   Override auto-detected game installation directory
  --dry-run         Show what would be deployed without writing anything
  --no-backup       Skip backup step (not recommended)
  --help            Show this help message

Environment:
  DOW_GAME_DIR      Alternative to --game-dir (env var)
EOF
}

# ─────────────────────────────────────────────────────────────────────────────
# Argument parsing
# ─────────────────────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case $1 in
        --game-dir)  GAME_DIR="$2"; shift 2 ;;
        --dry-run)   DRY_RUN=true; shift ;;
        --no-backup) NO_BACKUP=true; shift ;;
        --help|-h)   usage; exit 0 ;;
        *) die "Unknown option: $1 (use --help)" ;;
    esac
done

# Allow env-var override
[[ -z "$GAME_DIR" && -n "${DOW_GAME_DIR:-}" ]] && GAME_DIR="$DOW_GAME_DIR"

# ─────────────────────────────────────────────────────────────────────────────
# Steam library discovery
# ─────────────────────────────────────────────────────────────────────────────

# Enumerate Steam library roots from libraryfolders.vdf
_steam_library_roots() {
    local vdf_candidates=()

    # Native Linux / Proton paths
    vdf_candidates+=(
        "$HOME/.steam/steam/steamapps/libraryfolders.vdf"
        "$HOME/.local/share/Steam/steamapps/libraryfolders.vdf"
        "$HOME/snap/steam/common/.local/share/Steam/steamapps/libraryfolders.vdf"
        "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/libraryfolders.vdf"
    )

    # WSL2: scan common Windows drive mounts (C–E)
    for drv in c d e f; do
        vdf_candidates+=(
            "/mnt/${drv}/Program Files (x86)/Steam/steamapps/libraryfolders.vdf"
            "/mnt/${drv}/SteamLibrary/steamapps/libraryfolders.vdf"
        )
    done

    for vdf in "${vdf_candidates[@]}"; do
        [[ -f "$vdf" ]] || continue
        # Extract "path" values from the VDF file
        grep -oP '(?<="path"\s{1,8}")[^"]+' "$vdf" 2>/dev/null || true
        # Also add the directory containing the VDF itself (the default Steam lib)
        echo "$(dirname "$(dirname "$vdf")")"
    done
}

find_game_dir() {
    local roots
    mapfile -t roots < <(_steam_library_roots | sort -u)

    for lib_root in "${roots[@]}"; do
        local candidate="${lib_root}/steamapps/common/${GAME_FOLDER_NAME}"
        if [[ -d "$candidate" ]]; then
            echo "$candidate"
            return 0
        fi
        # Case-insensitive fallback (Linux filesystems are case-sensitive)
        local found
        found="$(find "${lib_root}/steamapps/common" -maxdepth 1 -iname "${GAME_FOLDER_NAME}" -type d 2>/dev/null | head -1)"
        if [[ -n "$found" ]]; then
            echo "$found"
            return 0
        fi
    done

    # Last resort: broader search under /mnt for WSL (slow — only if nothing found)
    for drv in c d e f; do
        [[ -d "/mnt/${drv}" ]] || continue
        local found
        found="$(find "/mnt/${drv}" -maxdepth 8 -iname "${GAME_FOLDER_NAME}" -type d 2>/dev/null | head -1)"
        if [[ -n "$found" ]]; then
            echo "$found"
            return 0
        fi
    done

    return 1
}

# ─────────────────────────────────────────────────────────────────────────────
# Backup helpers
# ─────────────────────────────────────────────────────────────────────────────

backup_item() {
    local src="$1"
    local rel="${src#${LOCALE_TARGET}/}"
    local dst="${BACKUP_DIR}/${STAMP}/${rel}"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$src" ]]; then
        cp -a "$src" "$dst"
        echo "$src" >> "$MANIFEST_FILE"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Main deploy logic
# ─────────────────────────────────────────────────────────────────────────────

printf "\n${BOLD}WH40K DoW:DE — Traditional Chinese Locale Mod Deployer${RESET}\n"
printf "Repo: %s\n\n" "$REPO_ROOT"

# 1. Resolve game directory
if [[ -z "$GAME_DIR" ]]; then
    log "Auto-detecting game installation..."
    if ! GAME_DIR="$(find_game_dir)"; then
        err "Could not auto-detect game directory."
        err "Set DOW_GAME_DIR or pass --game-dir PATH."
        err ""
        err "Typical paths:"
        err "  Linux Proton: ~/.local/share/Steam/steamapps/common/Dawn of War Definitive Edition"
        err "  WSL2:         /mnt/d/SteamLibrary/steamapps/common/Dawn of War Definitive Edition"
        exit 1
    fi
    ok "Found: $GAME_DIR"
else
    [[ -d "$GAME_DIR" ]] || die "Specified game dir does not exist: $GAME_DIR"
    ok "Using provided: $GAME_DIR"
fi

LOCALE_TARGET="${GAME_DIR}/${LOCALE_SUBPATH}"

# Verify this actually looks like the right directory
[[ -d "$LOCALE_TARGET" ]] || die "Expected locale directory missing: $LOCALE_TARGET"

printf "\n${BOLD}Target:${RESET} %s\n" "$LOCALE_TARGET"
$DRY_RUN && printf "${YELLOW}[DRY RUN — no files will be written]${RESET}\n"
printf "\n"

# 2. Apply font-fix patches to repo's data/font/ (writes .fnt files locally)
log "Applying font-fix patches (data/font/*.fnt)..."
if ! $DRY_RUN; then
    if command -v uv &>/dev/null; then
        uv run python "${REPO_ROOT}/scripts/apply_font_fix.py" \
            --root "${REPO_ROOT}" \
            --font noto-sans-tc \
            --restore-from-bak \
            --mode fallback-only \
            --size 34
    elif command -v python3 &>/dev/null; then
        python3 "${REPO_ROOT}/scripts/apply_font_fix.py" \
            --root "${REPO_ROOT}" \
            --font noto-sans-tc \
            --restore-from-bak \
            --mode fallback-only \
            --size 34
    else
        warn "No Python interpreter found; skipping font-fix patch step."
        warn "Install uv or python3, then re-run deploy."
    fi
else
    uv run python "${REPO_ROOT}/scripts/apply_font_fix.py" \
        --root "${REPO_ROOT}" \
        --font noto-sans-tc \
        --restore-from-bak \
        --mode fallback-only \
        --size 34 \
        --dry-run 2>/dev/null || true
fi

# 3. Backup existing files in the target
if ! $NO_BACKUP && ! $DRY_RUN; then
    log "Creating backup (${BACKUP_DIR}/${STAMP}/)..."
    mkdir -p "${BACKUP_DIR}/${STAMP}"
    echo "deploy_timestamp=${STAMP}" > "$MANIFEST_FILE"
    echo "game_dir=${GAME_DIR}" >> "$MANIFEST_FILE"
    echo "locale_target=${LOCALE_TARGET}" >> "$MANIFEST_FILE"
    echo "---files---" >> "$MANIFEST_FILE"

    # Backup deployed dirs
    for d in "${DEPLOY_DIRS[@]}"; do
        [[ -d "${LOCALE_TARGET}/${d}" ]] && backup_item "${LOCALE_TARGET}/${d}" || true
    done
    # Backup deployed files
    for f in "${DEPLOY_FILES[@]}"; do
        [[ -f "${LOCALE_TARGET}/${f}" ]] && backup_item "${LOCALE_TARGET}/${f}" || true
    done
    # Backup EnginLoc.sga if present (will be disabled)
    for sga_name in EnginLoc.sga EnginLoc.sga.disabled; do
        [[ -f "${LOCALE_TARGET}/${sga_name}" ]] && backup_item "${LOCALE_TARGET}/${sga_name}" || true
    done

    ok "Backup written to ${BACKUP_DIR}/${STAMP}/"
fi

# 4. Copy mod directories
for d in "${DEPLOY_DIRS[@]}"; do
    local_src="${REPO_ROOT}/${d}"
    [[ -d "$local_src" ]] || { warn "Source dir missing, skipping: $local_src"; continue; }

    log "Deploying ${d}/ → ${LOCALE_TARGET}/${d}/"
    if ! $DRY_RUN; then
        rsync -a --exclude="*.bak" "${local_src}/" "${LOCALE_TARGET}/${d}/"
    else
        rsync -a --dry-run --exclude="*.bak" "${local_src}/" "${LOCALE_TARGET}/${d}/" | grep -v "^sending" || true
    fi
done

# 5. Copy mod files
for f in "${DEPLOY_FILES[@]}"; do
    local_src="${REPO_ROOT}/${f}"
    [[ -f "$local_src" ]] || { warn "Source file missing, skipping: $local_src"; continue; }

    log "Deploying ${f} → ${LOCALE_TARGET}/${f}"
    if ! $DRY_RUN; then
        cp -f "$local_src" "${LOCALE_TARGET}/${f}"
    fi
done

# 6. Disable original EnginLoc.sga so game loads data/ instead
SGA_PATH="${LOCALE_TARGET}/EnginLoc.sga"
SGA_DISABLED="${LOCALE_TARGET}/EnginLoc.sga.disabled"

if [[ -f "$SGA_PATH" ]]; then
    log "Disabling ${SGA_PATH} (renaming to .disabled)..."
    if ! $DRY_RUN; then
        mv "$SGA_PATH" "$SGA_DISABLED"
        ok "Renamed EnginLoc.sga → EnginLoc.sga.disabled"
    else
        warn "[DRY RUN] Would rename: EnginLoc.sga → EnginLoc.sga.disabled"
    fi
elif [[ -f "$SGA_DISABLED" ]]; then
    ok "EnginLoc.sga already disabled (EnginLoc.sga.disabled exists)"
else
    warn "EnginLoc.sga not found — game may still load stale packed locale"
fi

# 7. Record deployment state for uninstall
if ! $DRY_RUN; then
    DEPLOY_STATE="${REPO_ROOT}/.copilot_workspace/last_deploy.env"
    mkdir -p "$(dirname "$DEPLOY_STATE")"
    cat > "$DEPLOY_STATE" <<ENVEOF
GAME_DIR=${GAME_DIR}
LOCALE_TARGET=${LOCALE_TARGET}
BACKUP_STAMP=${STAMP}
BACKUP_DIR=${BACKUP_DIR}/${STAMP}
ENVEOF
    ok "Deploy state saved: ${DEPLOY_STATE}"
fi

printf "\n${GREEN}${BOLD}Deployment complete!${RESET}\n"
printf "  Launch DoW:DE and verify Chinese text rendering.\n"
printf "  To revert: bash uninstall.sh  (or: make uninstall)\n\n"
