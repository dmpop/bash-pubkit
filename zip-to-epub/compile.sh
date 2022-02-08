#!/bin/bash

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

# Author: Dmitri Popov, dmpop@linux.com
# Source code: https://github.com/dmpop/bash-pubkit

##-----Functions-----##

# Usage prompt
usage() {
  cat <<EOF
$0 [DIR]

Bash Pubkit: Compiles Markdown pages and accompanying images, fonts, and CSS stylesheets into a book in the EPUB format.

Usage:
  $0 <DIR>
  $0 <DIR_1> <DIR_2> ...
EOF
  exit 1
}

##-----Global variables-----##

# Directory structure
PAGES_DIR="pages"
IMAGES_DIR="images"
FONTS_DIR="fonts"
METADATA_FILE="metadata.yaml"

# Prompt tag
TAG=" >>> "

# Create EPUB for each specified directory
for BOOK_DIR; do

  ##-----Sanity checks-----##

  # Check whether Pandoc is installed
  if [ ! -x "$(command -v pandoc)" ]; then
    echo "Make sure Pandoc is installed"
    exit 1
  fi

  # If the directory doesn't exist, skip it and continue
  if [ ! -d "$BOOK_DIR" ]; then
    echo $TAG "$BOOK_DIR not found, skipping..."
    continue
  fi

  # Check if the fonts directory exists
  if [ -d "$BOOK_DIR/$FONTS_DIR" ]; then
    # Check if the fonts directory is empty
    FONT_CHECK=$(ls -A "$BOOK_DIR/$FONTS_DIR")
    if [ "$FONT_CHECK" ]; then
      CUSTOM_FONTS=true
    else
      CUSTOM_FONTS=false
    fi
  fi

  # Pandoc command must run in the project directory
  cd "$BOOK_DIR"

  # If metadata.yaml doesn't exist
  # return to original folder, skip it, and continue
  if [ ! -f $METADATA_FILE ]; then
    echo $TAG "$METADATA_FILE not found in $BOOK_DIR, skipping..."
    cd ..
    continue
  fi

  ##-----Setting up the Pandoc command-----##

  # Format metadata.yaml for use with Pandoc
  # 1) Create a temporary copy of metadata.yaml with the .md` extension
  cp metadata.yaml metadata.md
  # 2) Append "..." to last line of metadata.md
  echo "..." >>metadata.md

  # Set arguments for Pandoc
  if [ "$CUSTOM_FONTS" = true ]; then
    # Create Pandoc arguments to embed all fonts in the fonts directory
    LIST_OF_FONTS=""
    shopt -s nullglob
    for f in $FONTS_DIR/*.ttf; do
      LIST_OF_FONTS+="--epub-embed-font="
      LIST_OF_FONTS+=$f
      LIST_OF_FONTS+=" "
    done
    # Append arguments to the Pandoc command
    BOOK_TITLE=$(basename "$BOOK_DIR")
    awk 'FNR==1{print ""}1' metadata.md "$PAGES_DIR"/*.md | pandoc -o "$BOOK_DIR/$BOOK_TITLE.epub" --toc $LIST_OF_FONTS
  else
    awk 'FNR==1{print ""}1' metadata.md "$PAGES_DIR"/*.md | pandoc -o "$BOOK_DIR/$BOOK_TITLE.epub" --toc
  fi

  # Check if EPUB was created
  if [ -f "$BOOK_DIR/$BOOK_TITLE.epub" ]; then
    echo
    echo $TAG "$BOOK_TITLE.epub compiled successfully."
  else
    echo $TAG "Compiling $BOOK_TITLE.epub failed."
  fi

  ##-----Cleanup-----##

  # Delete metadata.md
  rm metadata.md

  # Return to the original directory
  cd ..
done
