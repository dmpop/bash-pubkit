Bash PubKit is a tool set for compiling ebooks in the EPUB, MOBI, and PDF formats from Markdown-formatted text files and accompanying images, fonts, and an CSS stylesheet.

## Description

The key part of the Bash PubKit bundle is the *compile-ebook.sh* Bash shell script. The script uses [Pandoc](http://johnmacfarlane.net/pandoc/) to generate ebook in the EPUB format. The script offers the following features:

* Dedicated directory for each ebook project. All ebook source files such as a configuration file, images, a stylesheet, and pages are stored in a separate directory.
* Straightforward compilation process. The *compile-ebook.sh* script takes care of the entire ebook generation process.
* Option to generate ebooks in the PDF and MOBI format using Calibre *ebook-convert* tool.

## Requirements

* Linux or Mac OS X
* Bash shell
* [Pandoc](http://johnmacfarlane.net/pandoc/) (1.12.2 or higher)
* Optional [Calibre](http://calibre-ebook.com/)

On Ubuntu 14.04, Pandoc 1.12.2 can be installed using the following command:

	sudo apt-get install pandoc

On older version of Ubuntu, Pandoc 1.12.2 can be installed manually using Haskell Cabal:

	sudo apt-get install cabal-install
	sudo cabal update
	sudo cabal install pandoc --global

## Usage

To compile project files into an ebook in the EPUB format, run the *compile-ebook.sh* as follows:

	./compile-ebook.sh "Book of Foo"

### Options

* -m --generate-mobi Generates an ebook in the MOBI format (requires Calibre).
* -p --generate-pdf Generates an ebook in the PDF format (requires Calibre).
* -o --output-folder Specifies an alternative location for the generated files.

### Template

Bash PubKit comes with an example ebook project called *Template*. To compile it, run the following command:

    ./compile-ebook.sh "Template"

## Folder Structure

The most basic structure for an ebook is shown below:

* metadata.yaml
* cover.jpg
* pages/
  * book.md

A typical structure for a large novel is shown below:

* metadata.yaml
* cover.png
* stylesheet.css
* pages/
  * 0-foreword.md
  * 00-prologue.md
  * 1-chapter-1.md
  * 2-chapter-2.md
  * 3-chapter-3.md
  * 4-chapter-4.md
  * and so on...
* images/
  * snakes.jpg
  * leaflet.png
  * diagrams/
    * figure_1.png
    * figure_2.png
  * portraits/
    * author-portrait.jpg
    * editor-portrait.jpg
* fonts/
  * LibreBaskerville-Regular.ttf
  * LibreBaskerville-Italic.ttf
  * LibreBaskerville-Bold.ttf

## Book Parts

Each book includes several key files and directories.

### metadata.yaml

The *metadata.yaml* file is a plain text YAML configuration file that specifies the title, author, and any identifiers of the book, as specified by the [Dublin Core Metadata Standard](http://dublincore.org/documents/dces/). It is also used to specify the filename of the cover image (either *bookcover.jpg* or *bookcover.png*) and an CSS stylesheet.

The *cover-image* item defines the filename of the cover image to use. This cover image must be placed in the same folder as the *metadata.yaml* file

    cover-image:  bookcover.png

If no cover image found, the ebook will be compiled without one.

The *stylesheet* item defines the name of the stylesheet used in the ebook:

    stylesheet:  stylesheet.css

If the stylesheet  doesn't exist, the script uses Pandoc's default stylesheet.

The *title* item has two types. The *main* type specifies the main title of the book:

    title:
    - type: main
      text: My Book

The optional ssubtitle type can be used to specify the subtitle:

    - type: subtitle
      text: An investigation of metadata

The *credit* item is use to specify author and contributors:

    creator:
    - role: author
      text: John Smith
    - role: editor
      text: Sarah Jones

The *identifier*, *publisher*, *copyright* items can be used to provide the key information about the book if it has been already published:

    identifier:
    - scheme: DOI
      text: doi:10.234234.234/33
    publisher:  My Press
    rights:  (c) 2007 John Smith, CC BY-NC

### pages/

The *pages* directory contains Markdown-formatted text file that comprise the book. All files must have the *.md* file extension. Note that pages are assembled in the numerical or or alphabetical order. And the best way to organize pages in the desired order is to use numerical prefixes as follows (the leading zeros ensures the correct order):

* pages/
  * 0-foreword.md
  * 00-prologue.md
  * 001-chapter-1-the-beginning.md
  * 002-chapter-2-the-second-part.md
  * 003-chapter-3-the-third-part.md
  * 004-chapter-4-part-quattro.md
  * 019-chapter-19-part-nineteen.md

No subfolders are allowed in the *pages* directory.

### images/

All the images embedded in the ebook, except for the cover image, must be placed in the *images*  directory. To insert an image into the text, use the following Markdown code:

    ![](images/foo.jpg)

    ![Caption goes here](images/foo.jpg)

Sub-folders inside the *images* directory are allowed:

    ![](images/illustrations/foo.jpg)

In fact, complicated subfolder structures are allowed as long as the Markdown link reflects the location of the image.

    ![](images/diagrams/Snakes/Pythons/Burmese_Pythons/teeth.jpg)

If the image is too large for the page, use the HTML image embed tag to set the height and width manually:

    <img src="smiley.jpg" width="42" height="42">

If the text has to flow around an image (float), use the HTML image embed tag. Set *style="float:left"* to make the image float to the left of the text, and *style="float:right"* to make the image float to the right.

    <img src="smiley.gif" style="float:left">

### bookcover.jpg, bookcover.png

The cover image can be in either the JPEG or PNG format. Also, the cover file must reside in the root directory of the book project directory.

### stylesheet.css

The option *stylesheet.css* file controls the overall appearance and layout of book. If the *stylesheet.css* file does't exist, the compiler will use Pandoc's default stylesheet.

#### Font Family CSS

To make a font face available, place the desired fonts files into the *fonts* directory, and add the following code to the *stylesheet.css* file (replace *DejaVuSans* with the actual font name): 

    @font-face {
    font-family: DejaVuSans;
    font-style: normal;
    font-weight: normal;
    src:url("DejaVuSans-Regular.ttf");
    }
    @font-face {
    font-family: DejaVuSans;
    font-style: normal;
    font-weight: bold;
    src:url("DejaVuSans-Bold.ttf");
    }
    @font-face {
    font-family: DejaVuSans;
    font-style: italic;
    font-weight: normal;
    src:url("DejaVuSans-Oblique.ttf");
    }
    @font-face {
    font-family: DejaVuSans;
    font-style: italic;
    font-weight: bold;
    src:url("DejaVuSans-BoldOblique.ttf");
    }
    body { font-family: "DejaVuSans"; }

### fonts

The *fonts* directory is used to store fonts embedded into the ebook. No sub-folders are allowed in this directory.

## mvdir Bash Shell Script

The *mvdir.sh* Bash shell script dramatically simplifies the test of renaming multiple files, which can be useful if you need to rearrange pages. The script scans the specified path and opens a list of all found files and directories in a default text editor. Edit then the names, and the script automatically renames the modified files and directories when you close the editor.

## License

Bash PubKit is based on [BASC-eBookGenerator](https://github.com/bibanon/BASC-eBookGenerator).

Copyright (c) 2014 Dmitri Popov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
