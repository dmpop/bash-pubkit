Bash Pubkit is a tool for compiling books in the EPUB format from Markdown-formatted text files and accompanying images, fonts, and CSS stylesheets. Bash Pubkit comes with a book template and the _compile.sh_ Bash shell script that uses [Pandoc](http://johnmacfarlane.net/pandoc/) to generate book in the EPUB format.

## Requirements

- Linux, macOS, Windows with Windows Subsystem for Linux
- [Pandoc](http://johnmacfarlane.net/pandoc/) (1.12.2 or higher)

## Installation

- Install Pandoc: `sudo apt install pandoc` (Debian and Ubuntu), `sudo zypper in pandoc` (openSUSE)
- Clone the project's Git repository: `git clone https://github.com/dmpop/bash-pubkit.git`

## Usage

To compile project files into a book in the EPUB format, switch to the _bash-pubkit_ directory and run the _compile.sh_ as follows:

    ./compile.sh /path/to/book/dir

## Book template

Bash Pubkit comes with a example book project called _Book template_.

## Directory structure

A basic skeleton of a book is as follows:

- metadata.yaml
- bookcover.jpg
- pages/
  - book.md

A more complex book would typically have the following structure:

- metadata.yaml
- bookcover.jpg
- stylesheet.css
- pages/
  - 0-foreword.md
  - 00-prologue.md
  - 1-chapter-1.md
  - 2-chapter-2.md
  - 3-chapter-3.md
- images/
  - figure1.jpg
  - figure2.jpg
  - diagrams/
    - diagram1.png
    - diagram2.png
  - portraits/
    - author-portrait.jpg
    - editor-portrait.jpg
- fonts/
  - OpenSans-Regular.ttf
  - OpenSans-Italic.ttf
  - OpenSans-Bold.ttf

## Book parts

Each book includes several key source files and directories.

### metadata.yaml

The _metadata.yaml_ file is a plain text YAML configuration file that specifies key book info: the title, author, and any identifiers of the book, as specified by the [Dublin Core Metadata Standard](http://dublincore.org/documents/dces/). It is also used to specify the file name of the cover image (either _bookcover.jpg_ or _bookcover.png_) and an CSS stylesheet.

The _cover-image_ item defines the filename of the cover image to use. This cover image must be placed in the same folder as the _metadata.yaml_ file

    cover-image:  bookcover.jpg

If no cover image found, the book is compiled without one.

The _stylesheet_ item defines the name of the stylesheet used in the book:

    stylesheet:  stylesheet.css

If the stylesheet doesn't exist, the script uses Pandoc's default stylesheet.

The _title_ item has two types. The _main_ type specifies the main title of the book:

    title:
    - type: main
      text: My Book

The optional subtitle type can be used to specify the subtitle:

    - type: subtitle
      text: An investigation of metadata

The _creator_ item is used to specify author and contributors:

    creator:
    - role: author
      text: John Smith
    - role: editor
      text: Sarah Jones

The _identifier_, _publisher_, _copyright_ items can be used to provide the key information about the book if it has been already published:

    identifier:
    - scheme: DOI
      text: doi:10.234234.234/33
    publisher:  My Press
    rights:  (c) 2007 John Smith, CC BY-NC

### pages/

The _pages_ directory contains Markdown-formatted text file that comprise the book. All files must have the _.md_ file extension. Note that pages are assembled in the numerical or alphabetical order. And the best way to organize pages in the desired order is to use numerical prefixes as follows (the leading zeros ensures the correct order):

- pages/
  - 0-foreword.md
  - 00-prologue.md
  - 001-chapter-1-the-beginning.md
  - 002-chapter-2-the-second-part.md
  - 003-chapter-3-the-third-part.md

No subdirectories are allowed in the _pages_ directory.

### images/

All the images embedded in the book, except for the cover image, must be placed in the _images_  directory. To insert an image into the text, use the following Markdown code:

```markdown
![](images/foo.jpg)
![Caption goes here](images/foo.jpg)
```

Subdirectories inside the _images_ directory are allowed:

    ![](images/illustrations/illustration1.jpg)

If the image is too large for the page, use the HTML image embed tag to set the height and width manually:

```html
<img src="image1.jpg" width="42" height="42">
```

If the text has to flow around an image (float), use the HTML image embed tag. Set `style="float:left"` to make the image float to the left of the text, and `style="float:right"` to make the image float to the right.

```html
<img src="image1.gif" style="float:left">
```

### bookcover.jpg, bookcover.png

The cover image can be in either the JPEG or PNG format. The cover file must reside in the root directory of the book project directory.

### stylesheet.css

An optional _stylesheet.css_ file controls the overall appearance and layout of book. If the _stylesheet.css_ file doesn't exist, the compiler uses Pandoc's default stylesheet.

#### Font family CSS

To make a font face available, place the desired fonts files into the _fonts_ directory, and add the following code to the _stylesheet.css_ file (replace _OpenSans_ with the actual font name): 

```css
@font-face {
  font-family: OpenSans;
  font-style: normal;
  font-weight: normal;
  src: url("OpenSans-Regular.ttf");
}
@font-face {
  font-family: OpenSans;
  font-style: normal;
  font-weight: bold;
  src: url("OpenSans-Bold.ttf");
}
@font-face {
  font-family: OpenSans;
  font-style: italic;
  font-weight: normal;
  src: url("OpenSans-Italic.ttf");
}
@font-face {
  font-family: OpenSans;
  font-style: italic;
  font-weight: bold;
  src: url("OpenSans-BoldItalic.ttf");
}
body {
  font-family: "OpenSans";
}
```

### fonts

The _fonts_ directory is used to store fonts embedded into the book. No subdirectories are allowed in this directory.