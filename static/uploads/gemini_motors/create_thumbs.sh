#!/bin/bash
for each in *; do

  base="${each%.*}"
  ext="${each##*.}"
  convert "$each" -trim -resize 240 ${base}_thumb.$ext

done
