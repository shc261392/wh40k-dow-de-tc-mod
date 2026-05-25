# ─────────────────────────────────────────────────────────────────────────────
# WH40K DoW:DE – Traditional Chinese Locale Mod
# Makefile — development env management and run command control
#
# Prerequisites (dev, Linux only):
#   - uv  (https://docs.astral.sh/uv/)
#   - bash, rsync
#
# IMPORTANT: run all targets from the repository root.
# ─────────────────────────────────────────────────────────────────────────────

SHELL := /bin/bash
.DEFAULT_GOAL := help

PYTHON   := uv run python
FONT_DIR := data/font
SCRIPTS  := scripts

# ── Font / size defaults (override on CLI: make apply FONT=noto-serif-tc SIZE=36)
FONT     ?= noto-sans-tc
SIZE     ?= 34
PROFILE  ?=
MODE     ?= fallback-only

# ─────────────────────────────────────────────────────────────────────────────
# Setup
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: setup
setup: ## Install Python environment (no relic SGA tools needed for most workflows)
	uv sync
	@echo ""
	@echo "✓ Python env ready.  Run 'make help' to see available commands."

.PHONY: setup-sga
setup-sga: ## Install relic SGA tools (required only for SGA repack; Windows/Wine only)
	uv sync --extra sga
	@echo "✓ relic-tool-sga installed.  Use 'make unpack-sga' to extract the archive."

# ─────────────────────────────────────────────────────────────────────────────
# Font patching
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: dry-run
dry-run: ## Preview font-fix changes without writing (SIZE / MODE overridable)
	$(PYTHON) $(SCRIPTS)/apply_font_fix.py \
	    --root . \
	    --restore-from-bak \
	    --mode $(MODE) \
	    --size $(SIZE) \
	    --dry-run

.PHONY: apply
apply: ## Apply font-fix to data/font/*.fnt (writes files; auto-creates .bak)
	$(PYTHON) $(SCRIPTS)/apply_font_fix.py \
	    --root . \
	    --restore-from-bak \
	    --mode $(MODE) \
	    --size $(SIZE)
	@echo ""
	@echo "✓ Font fix applied.  Run 'make deploy' to push to the game installation."

.PHONY: apply-tc
apply-tc: ## Apply Traditional Chinese text corrections to Engine.ucs
	$(PYTHON) $(SCRIPTS)/apply_tc_corrections.py --ucs Engine.ucs

.PHONY: dry-run-tc
dry-run-tc: ## Preview TC text corrections without writing
	$(PYTHON) $(SCRIPTS)/apply_tc_corrections.py --ucs Engine.ucs --dry-run

.PHONY: list-fonts
list-fonts: ## List font replacement options (--replace-font-file / --replace-font-match)
	@echo "Font replacement options:"
	@echo "  --replace-font-file FILE   e.g. msyh.ttc, notosans_m_16_xc"
	@echo "  --replace-font-match REGEX e.g. NotoSansTC|Gulim (default)"

.PHONY: list-profiles
list-profiles: ## Show size/mode options
	@echo "Size: set via SIZE=N (default: 34)  Mode: fallback-only | all (default: fallback-only)"

# ─────────────────────────────────────────────────────────────────────────────
# SGA archive tools (optional, Windows/Wine)
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: unpack-sga
unpack-sga: ## Unpack EnginLoc.sga → data/ (requires setup-sga; Windows/Wine only)
	@echo "Unpack is Windows-only (PowerShell + relic.exe)."
	@echo "On Linux use: uv run python scripts/apply_font_fix.py directly (no SGA needed)."

# ─────────────────────────────────────────────────────────────────────────────
# Deployment
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: deploy
deploy: ## Deploy mod (loose-file mode, default) — copies data/, disables EnginLoc.sga
	@bash deploy.sh

.PHONY: deploy-sga
deploy-sga: ## Deploy mod (sga mode) — builds EnginLocMod.sga, keeps EnginLoc.sga active
	@bash deploy.sh --mode sga

.PHONY: deploy-dry
deploy-dry: ## Dry-run the default (loose) deploy without writing anything
	@bash deploy.sh --dry-run

.PHONY: deploy-sga-dry
deploy-sga-dry: ## Dry-run the sga deploy without writing anything
	@bash deploy.sh --mode sga --dry-run

.PHONY: uninstall
uninstall: ## Revert deployment (restore backups, re-enable original SGA)
	@bash uninstall.sh

DIST_DIR := .copilot_workspace/dist
VERSION  := $(shell python3 -c "import tomllib,pathlib; d=tomllib.loads(pathlib.Path('pyproject.toml').read_text()); print(d['project']['version'])" 2>/dev/null || echo "dev")
PKG_NAME := wh40k-dow-de-tc-mod-v$(VERSION)

# ─────────────────────────────────────────────────────────────────────────────
# Packaging
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: package
package: apply ## Build distributable mod archive (.copilot_workspace/dist/PKG.zip)
	@echo "▶ Packaging $(PKG_NAME).zip ..."
	@rm -rf "$(DIST_DIR)/$(PKG_NAME)"
	@mkdir -p "$(DIST_DIR)/$(PKG_NAME)/data/font" \
	           "$(DIST_DIR)/$(PKG_NAME)/data/art" \
	           "$(DIST_DIR)/$(PKG_NAME)/data/sound"
	@rsync -a --exclude="*.bak" data/font/  "$(DIST_DIR)/$(PKG_NAME)/data/font/"
	@rsync -a                   data/art/   "$(DIST_DIR)/$(PKG_NAME)/data/art/"
	@rsync -a                   data/sound/ "$(DIST_DIR)/$(PKG_NAME)/data/sound/"
	@cp Engine.ucs "$(DIST_DIR)/$(PKG_NAME)/"
	@cd "$(DIST_DIR)" && zip -r "$(PKG_NAME).zip" "$(PKG_NAME)/" -x "*.DS_Store"
	@echo "✓ $(DIST_DIR)/$(PKG_NAME).zip"
	@echo "  Size: $$(du -sh "$(DIST_DIR)/$(PKG_NAME).zip" | cut -f1)"
	@echo "  Files: $$(find "$(DIST_DIR)/$(PKG_NAME)" -type f | wc -l)"

# ─────────────────────────────────────────────────────────────────────────────
# Maintenance
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: restore-bak
restore-bak: ## Restore all .fnt files from their .bak backups (undo apply)
	$(PYTHON) $(SCRIPTS)/apply_font_fix.py --root . --dry-run --restore-from-bak --size 34 2>/dev/null || true
	@find $(FONT_DIR) -name "*.fnt.bak" -exec sh -c 'cp "$$1" "$${1%.bak}"' _ {} \;
	@echo "✓ .fnt files restored from .bak"

.PHONY: clean
clean: ## Remove uv cache and .venv (does NOT touch mod data or backups)
	rm -rf .venv
	uv cache clean 2>/dev/null || true
	@echo "✓ Clean done."

# ─────────────────────────────────────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: help
help: ## Show this help message
	@printf "\033[1mWH40K DoW:DE TC Mod — available targets\033[0m\n\n"
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) \
	    | sort \
	    | awk 'BEGIN{FS=":.*## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'
	@printf "\nOverridable variables: FONT (default: $(FONT)), SIZE (default: $(SIZE)), MODE (default: $(MODE)), PROFILE\n"
	@printf "Example: make apply FONT=noto-serif-tc SIZE=36\n"
