#!/bin/bash

# LaTeX CV Build Script
# Usage: ./scripts/build.sh [filename] [clean]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CV_DIR="$PROJECT_ROOT/Dung_Huynh"

# Default file (without .tex extension)
FILE="${1:-cv_2026}"
CLEAN="${2:-false}"

echo "📄 LaTeX CV Build Script"
echo "========================"
echo ""

# Check for required LaTeX packages
echo -e "${BLUE}🔍 Checking LaTeX packages...${NC}"
if ! kpsewhich textpos.sty &> /dev/null; then
    echo -e "${RED}❌ Missing required package: textpos${NC}"
    echo ""
    echo "Install it with:"
    echo "  macOS: tlmgr install textpos"
    echo "  Linux: sudo apt-get install texlive-latex-extra"
    echo ""
    exit 1
fi

# Change to CV directory
cd "$CV_DIR"

# Check if file exists
if [[ ! -f "${FILE}.tex" ]]; then
    echo -e "${RED}❌ Error: ${FILE}.tex not found in $CV_DIR${NC}"
    echo ""
    echo "Available files:"
    ls -1 *.tex 2>/dev/null | sed 's/^/  - /' || echo "  No .tex files found"
    exit 1
fi

echo -e "${YELLOW}🔧 Building: ${FILE}.tex${NC}"
echo ""

# Build with xelatex (run twice for references)
xelatex -interaction=nonstopmode "${FILE}.tex" > /dev/null
xelatex -interaction=nonstopmode "${FILE}.tex" > /dev/null

# Check if PDF was created
if [[ -f "${FILE}.pdf" ]]; then
    PDF_SIZE=$(ls -lh "${FILE}.pdf" | awk '{print $5}')
    echo -e "${GREEN}✅ Build successful!${NC}"
    echo "   Output: $CV_DIR/${FILE}.pdf"
    echo "   Size:   $PDF_SIZE"
    echo ""

    # Check if PDF is over 2MB
    PDF_BYTES=$(stat -f%z "${FILE}.pdf" 2>/dev/null || stat -c%s "${FILE}.pdf" 2>/dev/null)
    if [[ $PDF_BYTES -gt 2097152 ]]; then
        echo -e "${YELLOW}⚠️  PDF is over 2MB. Consider optimizing:${NC}"
        echo "   ./scripts/optimize_pdf.sh ${FILE}.pdf"
    fi
else
    echo -e "${RED}❌ Build failed. Check ${FILE}.log for errors.${NC}"
    exit 1
fi

# Clean auxiliary files if requested
if [[ "$CLEAN" == "clean" ]]; then
    echo ""
    echo -e "${YELLOW}🧹 Cleaning auxiliary files...${NC}"
    rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz
    echo -e "${GREEN}✅ Cleaned${NC}"
fi

echo ""
echo "📂 Output location: $CV_DIR/${FILE}.pdf"
