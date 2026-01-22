.PHONY: help install build clean optimize watch all

# Default target
.DEFAULT_GOAL := help

# Variables
CV_DIR := Dung_Huynh
SCRIPTS_DIR := scripts
LATEX_ENGINE := xelatex
PDF_VIEWER := open

# CV files
CV_SOURCES := $(wildcard $(CV_DIR)/*.tex)
CV_PDFS := $(patsubst %.tex,%.pdf,$(CV_SOURCES))

# Colors for terminal output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)LaTeX CV Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Usage:$(NC) make [target]"
	@echo ""
	@echo "$(GREEN)Targets:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install all required LaTeX packages and tools
	@echo "$(BLUE)📦 Installing required packages...$(NC)"
	@echo ""
	@echo "$(GREEN)Checking for Ghostscript...$(NC)"
	@command -v gs >/dev/null 2>&1 || brew install ghostscript
	@echo "✅ Ghostscript installed"
	@echo ""
	@echo "$(GREEN)Installing LaTeX packages...$(NC)"
	@echo "Running: tlmgr install textpos fontspec fontawesome smartdiagram biblatex biber xstring"
	@tlmgr install textpos fontspec fontawesome smartdiagram biblatex biber xstring || \
		(echo "$(YELLOW)⚠️  tlmgr requires sudo. Run manually:$(NC)" && \
		 echo "sudo tlmgr install textpos fontspec fontawesome smartdiagram biblatex biber xstring" && \
		 exit 1)
	@echo ""
	@echo "$(GREEN)✅ All packages installed!$(NC)"

install-full: ## Install full MacTeX (recommended, no package management needed)
	@echo "$(BLUE)📦 Installing MacTeX...$(NC)"
	@echo "This will download and install ~4GB of files."
	@echo "Run: brew install --cask mactex"

check: ## Check if all required packages are installed
	@echo "$(BLUE)🔍 Checking requirements...$(NC)"
	@echo ""
	@command -v $(LATEX_ENGINE) >/dev/null 2>&1 || (echo "❌ $(LATEX_ENGINE) not found"; exit 1)
	@echo "✅ $(LATEX_ENGINE) installed"
	@command -v gs >/dev/null 2>&1 || (echo "⚠️  Ghostscript not found (needed for optimization)"; exit 1)
	@echo "✅ Ghostscript installed"
	@kpsewhich textpos.sty >/dev/null 2>&1 || (echo "❌ textpos.sty not found - run 'make install'"; exit 1)
	@echo "✅ textpos.sty installed"
	@echo ""
	@echo "$(GREEN)✅ All requirements met!$(NC)"

build: ## Build cv_2026.tex (default)
	@echo "$(BLUE)🔨 Building cv_2026.tex...$(NC)"
	@(cd $(CV_DIR) && $(LATEX_ENGINE) -interaction=nonstopmode cv_2026.tex >/dev/null 2>&1 || true)
	@(cd $(CV_DIR) && $(LATEX_ENGINE) -interaction=nonstopmode cv_2026.tex >/dev/null 2>&1 || true)
	@if [ -f "$(CV_DIR)/cv_2026.pdf" ]; then \
		echo "$(GREEN)✅ Built: $(CV_DIR)/cv_2026.pdf$(NC)"; \
		size=$$(ls -lh "$(CV_DIR)/cv_2026.pdf" | awk '{print $$5}'); \
		echo "   Size: $$size"; \
	else \
		echo "$(RED)❌ Build failed$(NC)"; \
		exit 1; \
	fi

build-all: ## Build all CV files
	@echo "$(BLUE)🔨 Building all CV files...$(NC)"
	@for tex in $(CV_SOURCES); do \
		pdf=$${tex%.tex}.pdf; \
		echo "Building $$tex..."; \
		cd $(CV_DIR) && $(LATEX_ENGINE) -interaction=nonstopmode $$(basename $$tex) >/dev/null 2>&1 && \
		$(LATEX_ENGINE) -interaction=nonstopmode $$(basename $$tex) >/dev/null 2>&1 && \
		echo "$(GREEN)✅ Built: $$pdf$(NC)" || \
		echo "$(YELLOW)⚠️  Failed: $$pdf$(NC)"; \
	done

optimize: ## Optimize cv_2026.pdf for file size
	@echo "$(BLUE)🗜️  Optimizing cv_2026.pdf...$(NC)"
	@gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
		-dNOPAUSE -dQUIET -dBATCH \
		-sOutputFile="$(CV_DIR)/cv_2026_optimized.pdf" \
		"$(CV_DIR)/cv_2026.pdf"
	@if [ -f "$(CV_DIR)/cv_2026_optimized.pdf" ]; then \
		orig=$$(ls -lh "$(CV_DIR)/cv_2026.pdf" | awk '{print $$5}'); \
		opt=$$(ls -lh "$(CV_DIR)/cv_2026_optimized.pdf" | awk '{print $$5}'); \
		echo "$(GREEN)✅ Optimized: $(CV_DIR)/cv_2026_optimized.pdf$(NC)"; \
		echo "   Original: $$orig → Optimized: $$opt"; \
	else \
		echo "$(RED)❌ Optimization failed$(NC)"; \
	fi

optimize-all: ## Optimize all PDFs
	@echo "$(BLUE)🗜️  Optimizing all PDFs...$(NC)"
	@for pdf in $(CV_PDFS); do \
		if [ -f "$$pdf" ]; then \
			optimized=$${pdf%.pdf}_optimized.pdf; \
			echo "Optimizing $$pdf..."; \
			gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
				-dNOPAUSE -dQUIET -dBATCH \
				-sOutputFile="$$optimized" "$$pdf" && \
			echo "$(GREEN)✅ Optimized: $$optimized$(NC)"; \
		fi; \
	done

clean: ## Remove auxiliary files (aux, log, etc.)
	@echo "$(BLUE)🧹 Cleaning auxiliary files...$(NC)"
	@cd $(CV_DIR) && rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz
	@echo "$(GREEN)✅ Cleaned$(NC)"

clean-all: clean ## Remove all generated files including PDFs
	@echo "$(BLUE)🧹 Cleaning all generated files...$(NC)"
	@cd $(CV_DIR) && rm -f *.pdf
	@echo "$(GREEN)✅ All generated files removed$(NC)"

view: ## Open cv_2026.pdf in default viewer
	@$(PDF_VIEWER) $(CV_DIR)/cv_2026.pdf 2>/dev/null || open $(CV_DIR)/cv_2026.pdf

watch: ## Watch for changes and rebuild (requires entr)
	@echo "$(BLUE)👀 Watching for changes...$(NC)"
	@command -v entr >/dev/null 2>&1 || \
		(echo "❌ 'entr' not found. Install: brew install entr" && exit 1)
	@find $(CV_DIR)/*.tex | entr -r $(MAKE) build

all: clean build ## Clean and build

stats: ## Show project statistics
	@echo "$(BLUE)📊 Project Statistics$(NC)"
	@echo ""
	@echo "CV files:"
	@echo "  $(words $(CV_SOURCES)) .tex files"
	@echo ""
	@echo "PDF files:"
	@-for pdf in $(CV_PDFS); do \
		if [ -f "$$pdf" ]; then \
			size=$$(ls -lh "$$pdf" | awk '{print $$5}'); \
			echo "  $$pdf - $$size"; \
		fi; \
	done
