#!/bin/bash

# PDF Optimization Script for LaTeX CV
# Usage: ./optimize_pdf.sh input.pdf [output.pdf] [preset]

set -e

# Default values
INPUT="${1:-Dung_Huynh/cv.pdf}"
OUTPUT="${2:-${INPUT%.pdf}_optimized.pdf}"
PRESET="${3:-ebook}"

# Quality presets
declare -A PRESETS=(
    ["screen"]="72 dpi - Smallest size, web viewing"
    ["ebook"]="150 dpi - Good quality for applications (recommended)"
    ["printer"]="300 dpi - High quality for printing"
    ["prepress"]="300 dpi - Color preserving, professional printing"
)

# Validate preset
if [[ ! -v "PRESETS[$PRESET]" ]]; then
    echo "❌ Invalid preset: $PRESET"
    echo "Valid presets: screen, ebook, printer, prepress"
    exit 1
fi

# Check if input exists
if [[ ! -f "$INPUT" ]]; then
    echo "❌ Input file not found: $INPUT"
    exit 1
fi

# Get original size
ORIGINAL_SIZE=$(ls -lh "$INPUT" | awk '{print $5}')
ORIGINAL_BYTES=$(stat -f%z "$INPUT" 2>/dev/null || stat -c%s "$INPUT" 2>/dev/null)

echo "🔧 Optimizing PDF..."
echo "   Input:  $INPUT ($ORIGINAL_SIZE)"
echo "   Output: $OUTPUT"
echo "   Preset: $PRESET (${PRESETS[$PRESET]})"
echo ""

# Optimize
gs -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.4 \
   -dPDFSETTINGS=/$PRESET \
   -dNOPAUSE \
   -dQUIET \
   -dBATCH \
   -sOutputFile="$OUTPUT" \
   "$INPUT"

# Get optimized size
OPTIMIZED_SIZE=$(ls -lh "$OUTPUT" | awk '{print $5}')
OPTIMIZED_BYTES=$(stat -f%z "$OUTPUT" 2>/dev/null || stat -c%s "$OUTPUT" 2>/dev/null)

# Calculate reduction (if commands available)
if command -v bc &> /dev/null; then
    REDUCTION=$(echo "scale=1; (1 - $OPTIMIZED_BYTES / $ORIGINAL_BYTES) * 100" | bc)
    echo "✅ Optimization complete!"
    echo ""
    echo "📊 Size comparison:"
    echo "   Original:  $ORIGINAL_SIZE"
    echo "   Optimized: $OPTIMIZED_SIZE ($REDUCTION% reduction)"
else
    echo "✅ Optimization complete!"
    echo ""
    echo "📊 Size comparison:"
    echo "   Original:  $ORIGINAL_SIZE"
    echo "   Optimized: $OPTIMIZED_SIZE"
fi

# Check if under 2MB target
TARGET_BYTES=2097152  # 2MB in bytes
if [[ $OPTIMIZED_BYTES -le $TARGET_BYTES ]]; then
    echo "   ✅ Under 2MB target!"
else
    echo "   ⚠️  Still over 2MB. Try 'screen' preset for more compression."
fi
