#!/bin/bash

# BASC EBOOKGenerator
# ./compile-epub.sh
# Create EPUB and MOBI ebooks from Markdown pages, with all necessary pages,
# images, fonts, and CSS stylesheets kept in a source code folder.
# Uses Pandoc and KindleGen as backends to generate EPUB and MOBI.

##-------------Functions----------------##

# usage prompt
usage(){
cat <<EOF
$0 [OPTIONS] [FILES]

BASC EBOOKGenerator: Create EPUB and MOBI ebooks from Markdown pages, with all
necessary pages, images, fonts, and CSS stylesheets kept in a source code folder.

Uses Pandoc and KindleGen as backends to generate EPUB and MOBI.

Usage:
  $0 <ebook-folder>
  $0 <ebook-folder-1> <ebook-folder-2> ...
  $0 <ebook-folder> -k
  $0 <ebook-folder> -o <output-folder>
  $0 <ebook-folder> -k -o <output-folder>

Options:
  -k --also-generate-kindle-mobi  (Requires KindleGen) Amazon Kindle devices
                                  are unable to read EPUB-format ebooks, only
                                  MOBI. This script has the option to use 
                                  Amazon's KindleGen to convert EPUB into MOBI-
                                  format ebooks.
  -o --output-folder=<folder>     By default, the EPUB file is placed into the
                                  ebook source folder. However, this can be
                                  somewhat inconvenient. Use this option to
                                  choose an output folder where the EPUBs
                                  should be placed. (will be created if folder
                                  does not exist)
EOF
  exit 1
}

# function to check if any files with the extension given exists
any_with_ext () ( 
    ext="$1"
    any=false
    shopt -s nullglob
    for f in *."$ext"; do
        any=true
        break
    done
    echo $any 
)

##-------------Global Variables----------------##

# folder name structure
PAGES_FOLDER="pages"
IMAGE_FOLDER="images"
FONT_FOLDER="fonts"
METADATA_FILE="metadata.yaml"

# initial value
COMPILE_KINDLE_MOBI=false
OUTPUT_FOLDER=""

# Announcement tag
TAG=" :: "

##-------------Getopt Setup----------------##

# available options
OPTS=`getopt -o ko: -l also-generate-kindle-mobi,output-folder: -- "$@"`

# display usage prompt and quit if no arguments
[[ $# -eq 0 ]] && usage

eval set -- "$OPTS"

while [ "$1" != "" ]; do
    case "$1" in
        -k|--also-generate-kindle-mobi)
            COMPILE_KINDLE_MOBI=true
            shift
            ;;
        -o|--output-folder)
            if [ -n $2 ] ; then
              OUTPUT_FOLDER=$2
            fi
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            usage
            ;;
    esac
done

##-------------Precompilation Setup----------------##

# create the output folder if it doesn't already exist
if [[ -n "$OUTPUT_FOLDER" ]]; then
  mkdir -p "$OUTPUT_FOLDER"

  # check if output folder was actually created by `mkdir`
  if [ ! -d "$OUTPUT_FOLDER" ] ; then
    echo $TAG "Disabling -o --output-folder option..."
    OUTPUT_FOLDER=""
  fi
fi

# create an ebook for every ebook folder name passed in
for EBOOK_FOLDER ; do

    ##-------------Condition Checking----------------##

    # if folder doesn't exist, skip it and continue
    if [ ! -d "$EBOOK_FOLDER" ]; then
      echo $TAG "$EBOOK_FOLDER not found, skipping..."
      continue
    fi

    # check if fonts folder exists
    if [ -d "$EBOOK_FOLDER/$FONTS_FOLDER" ] ; then
      # check if fonts folder is empty
      HAVE_FONTS=$(ls -A "$EBOOK_FOLDER/$FONTS_FOLDER")
      if [ "$HAVE_FONTS" ]; then
        CUSTOM_FONTS=true
      else
        CUSTOM_FONTS=false
      fi
    fi

    # pandoc command must be run in the ebook's folder
    cd "$EBOOK_FOLDER"

    # if `metadata.yaml` doesn't exist (likely not EPUB folder)
    # return to original folder, skip it and continue
    if [ ! -f $METADATA_FILE ]; then
      echo $TAG "$METADATA_FILE not found in $EBOOK_FOLDER, skipping..."
      cd ..
      continue
    fi

    ##-------------Setting up the Pandoc Command----------------##

    # format `metadata.yaml` for use by pandoc
    # 1) create a temporary copy of `metadata.yaml` with `.md` extension
    cp metadata.yaml metadata.md
    # 2) append "..." to last line of `metadata.md`
    sed -i '$ a ...' metadata.md

    # set arguments for pandoc
    # if/else structure: embed custom fonts or not
    if [ "$CUSTOM_FONTS" = true ] ; then
      # create pandoc arguments to embed all fonts in the folder
      LIST_OF_FONTS=""
      shopt -s nullglob
      for f in $FONT_FOLDER/*.ttf ; do
        LIST_OF_FONTS+="--epub-embed-font="
        LIST_OF_FONTS+=$f
        LIST_OF_FONTS+=" "
      done
      # append arguments to pandoc command
      awk 'FNR==1{print ""}1' metadata.md "$PAGES_FOLDER"/*.md | pandoc -o "$EBOOK_FOLDER.epub" --toc $LIST_OF_FONTS
    else
      awk 'FNR==1{print ""}1' metadata.md "$PAGES_FOLDER"/*.md | pandoc -o "$EBOOK_FOLDER.epub" --toc
    fi

    # check if EPUB was created
    if [ -f "$EBOOK_FOLDER.epub" ]; then
      echo $TAG "$EBOOK_FOLDER.epub built successfully."
    else
      echo $TAG "Error: $EBOOK_FOLDER.epub not built."
    fi

    # Use kindlegen to create a MOBI file, sending kindlegen output to log file
    if [ "$COMPILE_KINDLE_MOBI" = true ] ; then
      LOG_FILE="$EBOOK_FOLDER.mobi.log"

      if hash kindlegen 2>/dev/null; then
        kindlegen "$EBOOK_FOLDER.epub" > $LOG_FILE

        # check if MOBI was created
        if [ -f "$EBOOK_FOLDER.mobi" ]; then
          echo $TAG "$EBOOK_FOLDER.mobi built successfully."
        else
          echo $TAG "Error: $EBOOK_FOLDER.mobi not built."
        fi
      else
        echo $TAG "Kindlegen is not installed, cannot generate MOBI..."
      fi
    fi

    ##-------------Optional Output Folder----------------##

    # if output folder enabled, move the generated ebooks into it
    if [[ -n "$OUTPUT_FOLDER" ]]; then
      if $( any_with_ext epub ); then
        mv *.epub ../"$OUTPUT_FOLDER"
      fi

      if $( any_with_ext mobi ); then
        mv *.mobi ../"$OUTPUT_FOLDER"
      fi

      if $( any_with_ext log ); then
        mv *.log ../"$OUTPUT_FOLDER"
      fi
    fi

    ##--------------------Cleanup-----------------------##

    # delete `metadata.md` (`metadata.yaml` not affected)
    rm metadata.md

    # return to original folder
    cd ..
done