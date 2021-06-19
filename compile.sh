#!/bin/bash

# ./compile-epub.sh
# The script compiles ebooks in the EPUB and MOBI formats from Markdown-formatted text files and accompanying images, fonts, and an CSS stylesheet.

##-------------Functions----------------##

# Usage prompt
usage() {
  cat <<EOF
$0 [DIR]

Bash PubKit: Compile ebooks in the EPUB format from Markdown pages and accompanying images, fonts, and CSS stylesheets. Bash PubKit is based on BASC eBookGenerator (github.com/bibanon/BASC-eBookGenerator) and uses Pandoc to generate EPUB files.

Usage:
  $0 <DIR>
  $0 <DIR_1> <DIR_2> ...
EOF
  exit 1
}

##-------------Global variables----------------##

# Directory structure
PAGES_DIR="pages"
IMAGE_DIR="images"
FONT_DIR="fonts"
METADATA_FILE="metadata.yaml"

# Announcement tag
TAG=" >>> "

# Create EPUB for each specified directory
for EBOOK_DIR; do

  ##-------------Sanits checks----------------##

  # If the directory doesn't exist, skip it and continue
  if [ ! -d "$EBOOK_DIR" ]; then
    echo $TAG "$EBOOK_DIR not found, skipping..."
    continue
  fi

  # Check if the fonts directory exists
  if [ -d "$EBOOK_DIR/$FONTS_DIR" ]; then
    # Check if the fonts directory is empty
    HAVE_FONTS=$(ls -A "$EBOOK_DIR/$FONTS_DIR")
    if [ "$HAVE_FONTS" ]; then
      CUSTOM_FONTS=true
    else
      CUSTOM_FONTS=false
    fi
  fi

  # Pandoc command must run in the ebook's directory
  cd "$EBOOK_DIR"

  # If `metadata.yaml` doesn't exist (likely not EPUB folder)
  # return to original folder, skip it, and continue
  if [ ! -f $METADATA_FILE ]; then
    echo $TAG "$METADATA_FILE not found in $EBOOK_DIR, skipping..."
    cd ..
    continue
  fi

  ##-------------Setting up the Pandoc Command----------------##

  # Format `metadata.yaml` for use with Pandoc
  # 1) Create a temporary copy of `metadata.yaml` with `.md` extension
  cp metadata.yaml metadata.md
  # 2) Append "..." to last line of `metadata.md`
  sed -i '$ a ...' metadata.md

  # Set arguments for Pandoc
  if [ "$CUSTOM_FONTS" = true ]; then
    # Create Pandoc arguments to embed all fonts in the directory
    LIST_OF_FONTS=""
    shopt -s nullglob
    for f in $FONT_DIR/*.ttf; do
      LIST_OF_FONTS+="--epub-embed-font="
      LIST_OF_FONTS+=$f
      LIST_OF_FONTS+=" "
    done
    # Append arguments to the Pandoc command
    EBOOK_TITLE=$(basename $EBOOK_DIR)
    awk 'FNR==1{print ""}1' metadata.md "$PAGES_DIR"/*.md | pandoc -o "$HOME/$EBOOK_TITLE.epub" --toc $LIST_OF_FONTS
  else
    awk 'FNR==1{print ""}1' metadata.md "$PAGES_DIR"/*.md | pandoc -o "$HOME/$EBOOK_TITLE.epub" --toc
  fi

  # Check if EPUB was created
  if [ -f "$HOME/$EBOOK_TITLE.epub" ]; then
    echo
    echo $TAG "$EBOOK_TITLE.epub compiled successfully."
  else
    echo $TAG "Compiling $EBOOK_TITLE.epub failed."
  fi

  ##--------------------Cleanup-----------------------##

  # Delete `metadata.md` (`metadata.yaml` not affected)
  rm metadata.md

  # Return to the original directory
  cd ..
done
