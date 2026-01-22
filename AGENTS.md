# AGENTS.md - LaTeX CV Project Guidelines

This document provides guidelines for AI agents operating in this repository.

## Project Overview

LaTeX CV template based on the Friggeri CV class, customized for software engineering resumes. Contains multiple CV variants (cv.tex, cv_2026.tex, cv_ai_lead.tex) that compile to PDF.

## Build Commands

### Quick Start
```bash
make              # Shows help message with all targets
make install      # Install required LaTeX packages (macOS)
make check        # Verify all dependencies are installed
make build        # Build cv_2026.tex (default target)
make view         # Open built PDF in default viewer
```

### Build Targets
```bash
make build              # Build cv_2026.pdf
make build-cv           # Build cv.pdf (original)
make build-all          # Build all .tex files in Dung_Huynh/
make optimize           # Optimize cv_2026.pdf for file size
make clean              # Remove auxiliary files (*.aux, *.log, *.out, *.toc)
make clean-all          # Remove all generated files including PDFs
make watch              # Watch for changes and rebuild (requires entr)
make all                # Clean and build in one command
make stats              # Show project statistics
```

### Alternative Build Scripts
```bash
./scripts/build.sh                    # Build cv_2026.tex
./scripts/build.sh cv                 # Build specific file
./scripts/build.sh cv_2026 clean      # Build and clean auxiliary files
./scripts/optimize_pdf.sh input.pdf output.pdf  # Optimize PDF
```

### Manual Compilation
```bash
cd Dung_Huynh && xelatex cv_2026.tex  # Run twice for correct cross-references
```

## Code Style Guidelines

### LaTeX Document Structure

- Use consistent indentation (2 spaces for nested environments)
- One newline between major sections and environments
- Keep line length under 120 characters for readability
- Use descriptive comments for section modifications

### Section Organization

```latex
% Header section (personal info, aside)
% ---------------------------------------
\section{Header}

% Experience section
% ------------------
\section{Experience}
\begin{entrylist}
  \entry
    {dates}
    {title}
    {company}
    {description}
\end{entrylist}
```

### Entry Format

```latex
\entry
  {MM/YYYY - MM/YYYY}  % Dates (left column)
  {Job Title}          % Title (center)
  {Company Name}       % Organization (center)
  {Description with\\\\line breaks\\\\}  % Details (right)
```

### Import Order

LaTeX packages must be loaded in this order:
1. Document class (`\documentclass`)
2. Required packages (fontspec, geometry)
3. Style packages (friggeri-cv.cls, dtklogos.sty)
4. Font loading
5. Custom commands and environments

### Naming Conventions

- **Files**: lowercase with underscores (`cv_2026.tex`, `optimize_pdf.sh`)
- **Commands**: lowercase with underscores (`\newcommand{\mycommand}`)
- **Environments**: lowercase (`\begin{entrylist}...\end{entrylist}`)
- **Variables**: descriptive names in comments

### Cross-References and Special Characters

- Use `&` for column separators in tables and entry lists
- Escape special characters: `\&`, `\%`, `\$`, `\#`, `\_`, `\{`, `\}`
- Use `\\` for line breaks within entries
- Use `\\\\` for paragraph breaks in entry descriptions

### Git Workflow

- Commit source files only (`.tex`, `.cls`, `.sty`, `.md`)
- Never commit build artifacts (`.pdf`, `.aux`, `.log`, `.out`)
- Use meaningful commit messages describing content changes

### Error Handling

- LaTeX compilation errors show line numbers in `.log` file
- Run `make clean` before rebuilding after errors
- Check for missing packages with `make check`
- Common issues: missing fonts, package conflicts, syntax errors

### Font Usage

Project includes custom fonts - do not modify fontspec configuration unless adding new fonts:
- TeX Gyre Heros (Helvetica replacement)
- Lato Hairline

### Image Guidelines

- Store images in `Dung_Huynh/img/`
- Use relative paths: `img/profile.jpg`
- Scale images appropriately (`scale=0.15` for profile photo)
- Use PDF or PNG formats for compatibility

## Dependencies

- **XeLaTeX** - Required for compilation (not pdflatex)
- **Ghostscript** - Required for PDF optimization
- **LaTeX packages**: textpos, fontspec, fontawesome5, smartdiagram

## No Test Suite

This is a LaTeX document project with no automated tests. Verify changes by:
1. Running `make build`
2. Opening the generated PDF with `make view`
3. Checking for compilation errors in the build output
