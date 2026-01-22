# LaTeX CV Template

A professional LaTeX CV template based on the Friggeri CV class, customized for software engineering resumes.

## Project Structure

```
.
├── Dung_Huynh/
│   ├── cv.tex              # Main CV file (updated)
│   ├── cv_ai_lead.tex      # AI Lead version
│   ├── friggeri-cv.cls     # CV class definition
│   ├── dtklogos.sty        # Logo style package
│   ├── img/                # Profile and images
│   └── *.ttf, *.otf        # Font files
├── scripts/
│   └── optimize_pdf.sh     # PDF optimization script
└── README.md
```

## Prerequisites

Install LaTeX distribution and required tools:

### macOS

```bash
# Install MacTeX (full LaTeX distribution) - recommended
brew install --cask mactex

# Or install BasicTeX (smaller, ~100MB)
brew install --cask basictex
# Then install required packages
tlmgr install latexmk fontspec fontawesome smartdiagram textpos biblatex biber xstring

# Install Ghostscript for PDF optimization
brew install ghostscript
```

### Linux (Ubuntu/Debian)

```bash
sudo apt-get install texlive-xetex texlive-fonts-recommended texlive-latex-extra ghostscript
# textpos is included in texlive-latex-extra
```

## Building the CV

### Quick Start (Recommended)

```bash
# Install all required packages (macOS)
make install

# Build cv_2026.tex
make build

# View available commands
make help
```

### Using Build Script

```bash
# Build cv_2026.tex (default)
./scripts/build.sh

# Build specific file
./scripts/build.sh cv

# Build and clean auxiliary files
./scripts/build.sh cv_2026 clean
```

### Quick Build

```bash
cd Dung_Huynh
xelatex cv.tex
```

### Build All Variants

```bash
# Main CV (original)
xelatex Dung_Huynh/cv.tex

# Updated 2026 version
./scripts/build.sh cv_2026

# AI Lead version
xelatex Dung_Huynh/cv_ai_lead.tex
```

### Using Makefile

```bash
# Install all required packages (macOS)
make install

# Check if requirements are met
make check

# Build cv_2026.tex (default)
make build

# Build all CV files
make build-all

# Optimize PDF for size
make optimize

# Clean auxiliary files
make clean

# Remove all generated files
make clean-all

# View PDF in default viewer
make view

# Show all available commands
make help
```

## PDF Optimization

Reduce PDF size for uploads (e.g., job applications with 2MB limit).

### Quick Optimization

```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
   -dNOPAUSE -dQUIET -dBATCH \
   -sOutputFile=cv_optimized.pdf cv.pdf
```

### Using the Optimization Script

```bash
./scripts/optimize_pdf.sh Dung_Huynh/cv.pdf Dung_Huynh/cv_optimized.pdf
```

### Quality Presets

| Preset      | DPI | Use Case                          |
| ----------- | --- | --------------------------------- |
| `/screen`   | 72  | Web upload, smallest size         |
| `/ebook`    | 150 | Email, applications (recommended) |
| `/printer`  | 300 | Printing, high quality            |
| `/prepress` | 300 | Professional printing             |

## Updating Your CV

### Personal Information

Edit `Dung_Huynh/cv.tex`:

```latex
% Header (line 54)
\header{First}{Last}{Title}

% Sidebar (lines 58-82)
\begin{aside}
  \includegraphics[scale=0.15]{img/your-photo.jpg}
  \section{Address}
   Your Address
  \section{Contact}
    Phone, Skype, etc.
\end{aside}
```

### Open Source Projects

Projects are auto-fetched from GitHub. To update:

1. **Manual update**: Edit the descriptions in `cv.tex` (lines 89-111)
2. **Using GitHub CLI**:
   ```bash
   gh repo view jellydn/resume-latex --json name,description
   ```

### Experience & Education

Update the `entrylist` sections in `cv.tex` (lines 116-173):

```latex
\begin{entrylist}
  \entry
    {MM/YYYY - Now}
    {Job Title}
    {Company Name}
    {Description and achievements\\\\}
\end{entrylist}
```

## Fonts

This template uses custom fonts included in the project:

- **TeX Gyre Heros** (Helvetica replacement)
- **Lato Hairline**

To change fonts, modify the fontspec configuration in your `.tex` file.

## Troubleshooting

### Compilation Errors

**Error: `File 'textpos.sty' not found`**

```bash
# macOS
tlmgr install textpos biblatex biber xstring

# Linux
sudo apt-get install texlive-latex-extra biber
```

**Error: `fontspec` feature requires XeLaTeX or LuaLaTeX**

```bash
# Use xelatex instead of pdflatex
xelatex cv.tex
```

**Error: Missing packages**

```bash
# macOS
tlmgr install <package-name>

# Linux
sudo apt-get install texlive-<package>
```

### PDF Size Issues

If PDF is still too large after optimization:

1. Check for embedded images in `img/` folder
2. Compress images before including in LaTeX
3. Try `/screen` preset for aggressive compression

### Version Control

```bash
# Track LaTeX changes but ignore build artifacts
git add cv.tex
git commit -m "Update experience section"

# .gitignore already excludes:
# *.aux, *.log, *.out, *.pdf, *.toc
```

## Resources

- [Friggeri CV Template](https://www.latextemplates.com/template/friggeri-cv-cv)
- [LaTeX Font Catalog](https://www.tug.org/FontCatalogue/)
- [Overleaf LaTeX Learn](https://www.overleaf.com/learn)

## License

This template is based on the Friggeri CV class. Modify and use freely for your personal CV.
