#!/bin/bash

# BASC EBOOKGenerator
# ./compile-all-epubs.sh
# Wrapper for `./compile-epub.sh` that grabs a list of all folders in the current
# directory and passes them to that script

##-------------Functions----------------##

# usage prompt
usage(){
cat <<EOF
$0 [OPTIONS]

Wrapper for BASC EPUBGenerator that grabs a list of all folders in the current
directory and generates EPUBs for each one

Usage:
  $0 -k
  $0 -o <output-folder>
  $0 -k -o <output-folder>

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
}

##-------------Global Variables----------------##

# initial value
COMPILE_KINDLE_MOBI=false
OUTPUT_FOLDER=""
EPUB_COMPILER="./compile-ebook.sh"

##-------------Getopt Setup----------------##

# available options
OPTS=`getopt -o ko: -l also-generate-kindle-mobi,output-folder: -- "$@"`

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

##-------------Pass over ./compile-epub.sh arguments----------------##

# create a list of all folders within current folder
find_cmd="""find . -mindepth 1 -maxdepth 1 -type d -exec"""

if [[ -n "$OUTPUT_FOLDER" ]]; then
  if [ "$COMPILE_KINDLE_MOBI" = true ] ; then
    $find_cmd $EPUB_COMPILER -k '{}' -o "$OUTPUT_FOLDER" \;
  else
    $find_cmd $EPUB_COMPILER '{}' -o "$OUTPUT_FOLDER" \;
  fi
else
  if [ "$COMPILE_KINDLE_MOBI" = true ] ; then
    $find_cmd $EPUB_COMPILER -k '{}' \;
  else
    $find_cmd $EPUB_COMPILER '{}' \;
  fi
fi