BASC eBookGenerator is a script that creates EPUB and MOBI ebooks from Markdown pages, with all necessary pages, images, fonts, and CSS stylesheets kept in a source code folder.

It was designed for use by the Bibliotheca Anonoma StoryCorps (BASC), to compile it's archived stories into ebooks into EPUB and MOBI format, for easy viewing on an ebook reader.

## Design

The script supplements Pandoc's ability to convert Markdown pages into EPUB ebooks with the following features:

* Ebook Source Code Folders
  * All necessary files, pages, and instructions for the eBook are kept in a single folder, just like a programmer would for the source code of a program.
* One touch Makefile-style compilation.
  * Once the ebook source code is set up, just run the script `./compile-ebook.sh` each time you want to build it. No extra arguments, updates, or thought needed.
* Build multiple ebooks at once
  * The included helper script, `./compile-all-epubs.sh` will instantly compile all ebook source code folders in the same folder as the script.
* Automatically generate MOBI files for Amazon Kindle devices.
  * Amazon Kindle devices are unable to read EPUB-format ebooks, only MOBI. This script has the option to use Amazon's KindleGen to convert EPUB into MOBI-format ebooks.

## Dependencies

* **Linux or Mac OS X** - Windows with Cygwin may work, but is not recommended.
* **Bash Shell** - The default command line in Linux and Mac OS X. Required to run the bash script.
* [Pandoc](http://johnmacfarlane.net/pandoc/) (versions > 1.12.2) - Pandoc converts Markdown files into every single possible format for text to be presented in; including EPUB.
  * **Version 1.12.2 or greater** of Pandoc is required, which introduces EPUB YAML metadata support. Make sure that you have such a version; Ubuntu Trusty 14.04 is the latest Ubuntu version with it.
* [kindlegen](http://www.amazon.com/gp/feature.html?docId=1000765211) (optional) - Converts EPUB to Amazon Kindle compatible MOBI format.

If you're running Ubuntu 14.04, Pandoc 1.12.2 can be installed normally:

    sudo apt-get install pandoc

If you're using an Ubuntu version older than 14.04, install Pandoc 1.12.2 manually by using Haskell Cabal:

    sudo apt-get install cabal-install
    sudo cabal update
    sudo cabal install pandoc --global

 `kindlegen` can be downloaded from here: <http://www.amazon.com/gp/feature.html?docId=1000765211>

## Usage

Once Pandoc and Kindlegen is installed, use the Bash script `create-ebook.sh` to quickly build an ebook.

* `./compile-ebook.sh <ebook-folder>`
* `./compile-ebook.sh <ebook-folder-1> <ebook-folder-2> ...`
* `./compile-ebook.sh <ebook-folder> -k`
* `./compile-ebook.sh <ebook-folder> -o <output-folder>`

The included helper script `compile-all-epubs.sh` will find and compile every ebook folder, without having to provide folder names. It uses the same arguments as above, just omit `<ebook-folder>` .

### Options

* `-k` `--also-generate-kindle-mobi`
  * (Requires KindleGen) Amazon Kindle devices are unable to read EPUB-format ebooks, only MOBI. This script has the option to use Amazon's KindleGen to convert EPUB into MOBI-format ebooks.
* `-o --output-folder`
  * By default, the EPUB file is placed into the ebook source folder. However, this can be somewhat inconvenient. Use this option to choose an output folder where the EPUBs should be placed. (will be created if folder does not exist)

### Example Ebook: "Lorem Ipsum"

Included with this script is an example ebook, called "Lorem Ipsum". Use this command to create it:

    ./compile-ebook.sh "Lorem Ipsum"

That example ebook implements all possible features of the script.

## Folder Structure

The most basic structure for an ebook is shown below:

* `metadata.yaml`
* `cover.jpg`
* `pages/`
  * `1-everything.md`

A typical structure for a large novel is shown below:

* `metadata.yaml`
* `cover.png`
* `stylesheet.css`
* `pages/`
  * `0-foreword.md`
  * `00-prologue.md`
  * `1-chapter-1.md`
  * `2-chapter-2.md`
  * `3-chapter-3.md`
  * `4-chapter-4.md`
  * and so on...
* `images/`
  * `snakes.jpg`
  * `leaflet.png`
  * `diagrams/`
    * `figure_1.png`
    * `figure_2.png`
  * `portraits/`
    * `author-portrait.jpg`
    * `editor-portrait.jpg`
* `fonts/`
  * `LibreBaskerville-Regular.ttf`
  * `LibreBaskerville-Italic.ttf`
  * `LibreBaskerville-Bold.ttf`

For a closer look, check out and mess with the example book included in this repository, `Lorem_Ipsum`.

## Components

Each of the component files and folders are described in detail below.

### `metadata.yaml` File

> The `metadata.yaml` file is a plain text YAML filejust make sure that they are  config that specifies the title, author, and any identifiers of the book, as specified by the [Dublin Core Metadata Standard](http://dublincore.org/documents/dces/). It is also used to specify the filename of the cover image (either `cover.jpg` or `cover.png`) and CSS stylesheet.

The first entry defines the filename of the cover image to use. This cover image must be placed in the same folder as the `metadata.yaml`

    cover-image:  cover.jpg

If the cover image to use is a PNG, simply change the `.jpg` extension into `.png`.

    cover-image:  cover.png

If no cover image is found, the ebook will be simply be compiled without one, so no need to remove the entry.

The next entry defines the filename of the stylesheet used. If that stylesheet isn't found, Pandoc's default stylesheet will be used.

    stylesheet:  stylesheet.css

The `title` entry has two subtypes, `main`, which is the main title of the book.

    title:
    - type: main
      text: My Book

Optionally, a `subtitle` could be also used as a subtype of `title`.

    - type: subtitle
      text: An investigation of metadata

> **Note:** KindleGen will not convert an EPUB file with a subtitle, since subtitles are not supported in Kindle-readable MOBI.
> When generating a MOBI ebook, comment out the subtitle entry (precede the lines with `#`), or remove those lines entirely.

Give credit to contributors in this book under the `creator` entry.

    creator:
    - role: author
      text: John Smith
    - role: editor
      text: Sarah Jones

The last entries define the identifier, the publisher, and copyrights. These entries are only relevant if the book has been published.

    identifier:
    - scheme: DOI
      text: doi:10.234234.234/33
    publisher:  My Press
    rights:  (c) 2007 John Smith, CC BY-NC

The complete example `metadata.yaml` is shown below:

```yaml
    ---
    cover-image:  cover.jpg
    stylesheet:  stylesheet.css
    title:
    - type: main
      text: My Book
    - type: subtitle
      text: An investigation of metadata
    creator:
    - role: author
      text: John Smith
    - role: editor
      text: Sarah Jones
    identifier:
    - scheme: DOI
      text: doi:10.234234.234/33
    publisher:  My Press
    rights:  (c) 2007 John Smith, CC BY-NC
```

### `pages/` Folder

This folder contains the actual text of the ebook in Markdown format.

Notice that the pages will be joined together in numerical (or alphabetical) order. To keep the pages in the order desired, number them as shown below.

* `pages/`
  * `0-foreword.md`
  * `00-prologue.md`
  * `0001-chapter-1-the-beginning.md`
  * `0002-chapter-2-the-second-part.md`
  * `0003-chapter-3-the-third-part.md`
  * `0004-chapter-4-part-quattro.md`
  * ...
  * `0019-chapter-19-part-nineteen.md`
  * ...
  * `2156-chapter-2156-excessive-amount-of-chapters.md`
  * and so on...

The zeros preceding each filename number ensure that they are not misplaced by the computer. Computers use a simple method of ordering files that check character by character, causing the following numbers:

* 1
* 2
* 3
* 15
* 27

to be ordered as follows:

* 1
* 15
* 2
* 27
* 3

Adding zeros to the beginning of each number bypasses this issue.

* 0001
* 0002
* 0003
* 0133
* 4587

No subfolders are allowed in the `pages/` folder, in the interest of enforcing clarity.

### Markdown Pages

The files under the `pages/` folder contain the text of the the ebook, written in Markdown format.

Check out Mashery's [Markdown Cheatsheet](http://support.mashery.com/docs/read/customizing_your_portal/Markdown_Cheat_Sheet) for a quick overview of the format.

* Chapters are divided using H1 `# Title` header tags.
  * The header tags create the chapters, not the files. Make sure each chapter has a header tag at the top.

* Make sure to **leave an empty line at the beginning or end of each file.**
  * This is because Pandoc quite literally smashes the pages together into one file, which can cause the Chapter H1 header tags to be joined to the end of the previous file. By leaving an empty line, there is enough space to leave the header tag on it's own line.

* Markdown can also use inline HTML.
  * If there is something that Markdown can't offer (there isn't much), just use typical HTML code anywhere it's needed.

### `images/` Folder

> All the images embedded in the ebook, *except for the cover image*, are placed in the `images/` folder, and linked to using relative links.

Although images can be linked from around the internet as usual (e.g. `![](http://imgur.com/12345.jpg)` ), it is good practice to keep a local copy of all images used, placing them under the `images/` folder.

To embed an image called `picture.jpg` under the `images/` folder in the book, use the Markdown syntax shown below:

    ![](images/picture.jpg)

> **Note:** Even though the `images/` folder is above the `pages/` folder, use the above syntax as shown. Do not use `![](../images/picture.jpg)`. Pandoc interprets relative links from the root of the EPUB source code folder.

An image caption can be used, which will be displayed just below.

    ![This is a JPEG image.](images/picture.jpg)

Subfolders inside the `images/` folder are allowed, as long as the images within are linked to correctly.

For example, if the `images/` folder has a subfolder `diagrams/`, which contains the image `picture.jpg` inside, use this Markdown syntax:

    ![](images/diagrams/picture.jpg)

In fact, complicated subfolder structures are allowed as long as the Markdown link reflects the location of the image.

    ![](images/diagrams/Snakes/Pythons/Burmese_Pythons/teeth.jpg)

If the image is too big for the page, use the HTML image embed tag to set the height and width manually. Alternatively, save space and create a resized version with Photoshop, Imagemagick, or some other image editing utility.

    <img src="smiley.jpg" width="42" height="42">

If the text has to reflow around an image (float), use the HTML image embed tag. Set `style="float:left"` make the image float to the left of the text, and `style="float:right"` to make the image float to the right.

    <img src="smiley.gif" style="float:left">

### `cover.jpg` or `cover.png` File (optional)

> `cover.jpg` or `cover.png` is the image that will be used as the cover of the ebook.

The cover image can be either `JPEG` or `PNG` format. However, when switching formats, ensure that the filename in `metadata.yaml` has the correct extension.

Also, ensure that the cover image is stored at the top of the EPUB source code folder, as shown in the folder structure below:

* `cover.jpg`
* `metadata.yaml`
* `pages`
  * `1-chapter-1.md`
  * `2-chapter-2.md`
* `images/`
  * `image1.jpg`

If no cover image is needed, simply don't include one.

### `stylesheet.css` File (optional)

> Since EPUBs are based on web technologies, CSS can be used to spice up the font and formatting of the ebook. Just don't overdo it. Usually, *no changes are necessary.*

The most that should be changed is the font face; if the book is written in a Unicode language that the ; or for stylistic

Generally, leave the layout alone, since the ereader can change margins and such on it's own.

### Default Pandoc CSS

This is the basic CSS stylesheet used by Pandoc, which will be used if no `stylesheet.css` file is provided.

It is almost always enough for most purposes.

```css
    /* This defines styles and classes used in the book */
    body { margin: 5%; text-align: justify; font-size: medium; }
    code { font-family: monospace; }
    h1 { text-align: left; }
    h2 { text-align: left; }
    h3 { text-align: left; }
    h4 { text-align: left; }
    h5 { text-align: left; }
    h6 { text-align: left; }
    h1.title { }
    h2.author { }
    h3.date { }
    ol.toc { padding: 0; margin-left: 1em; }
    ol.toc li { list-style-type: none; margin: 0; padding: 0; }
```

### Font Family CSS

To make a font face available, add the CSS code below to `stylesheet.css`. 

Don't forget to place the actual `.ttf` font faces under the `fonts/` folder (explained below).

For example, the DejaVuSans font family is declared below:

```css
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
```

[Source](http://www.pigsgourdsandwikis.com/2011/04/embedding-fonts-in-epub-ipad-iphone-and.html)

### `fonts/` Folder (optional)

If `.ttf` fonts need to be embedded, create this folder and place the `.ttf` files inside. The script will automatically embed those fonts into the EPUB. Don't forget to declare the fonts in `stylesheet.css` (explained above).

No subfolders are allowed in this folder.

### Font Theming

* **Libre Baskerville** - The default Serif font used. - [Google Web Fonts](http://www.google.com/fonts/specimen/Libre+Baskerville)
* **Source Sans Pro** - The default Sans Serif font used. - [Google Web Fonts](https://www.google.com/fonts/specimen/Source+Sans+Pro)