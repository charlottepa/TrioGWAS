#!/bin/bash

# Usage: ./correct_bims_cp.sh input.bim output.bim

INPUT=$1
OUTPUT=$2

if [[ ! -f "$INPUT" ]]; then
  echo "❌ Input BIM file not found: $INPUT"
  exit 1
fi

awk '{
  # Normalize chromosome
  chr = $1
  if (chr == "X" || chr == "chrX") chr = 23
  else sub(/^chr/, "", chr)

  # Determine variant type
  is_snp = ($5 ~ /^[ATCG]$/ && $6 ~ /^[ATCG]$/)
  label = is_snp ? "SNP" : "INDEL"

  # Compose cleaned ID (no "chr" prefix)
  new_id = chr ":" $4 ":" label

  print chr, new_id, $3, $4, $5, $6
}' "$INPUT" > "$OUTPUT"

echo "✅ BIM file fixed and saved to: $OUTPUT"

