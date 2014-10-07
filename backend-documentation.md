This script uses Pandoc as the primary backend for doing the dirty work of converting Markdown to HTML, and packing everything together into an EPUB file.  This script expands upon the converter by automating everything, and adding some more structure.

## Folder Structure

These files are needed for Pandoc to create an EPUB file.

* `my-ebook.md` - The contents of the ebook itself, in Markdown format. Chapters are divided using H1 `# Chapter Title` tags.
* `cover.jpg` - The cover image to be used on the ebook. For best results, the image should be Vertical Rectangular, and less than 1000px.
* `stylesheet.css` - Defines the look of the EPUB, using CSS. We will use it to set our fonts.

Files to be embedded into the book will also be stored under these folders:

* `images/` - Folder containing all the images linked to in `my-ebook.md`. Pandoc will automatically embed them into the ebook.
* `fonts/` - Folder containing all the fonts to be embedded into the EPUB. The location of each font has to be specified in a Pandoc argument: `--epub-embed-font="<font>"`

### `my-ebook.md` - Markdown Ebook Source Code

The Markdown ebook source should be combined into one file, with each Chapter seperated with the H1 tag `# Chapter Title`. 

Pandoc will automatically embed any images referenced in the markdown file into the ebook.

The format will look as follows:

```markdown
    # Chapter 1
    
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque id faucibus augue, ac iaculis nibh. Donec volutpat pellentesque elementum. Pellentesque massa urna, porta scelerisque nisl id, dapibus egestas enim. Aenean sed nibh orci. Nullam a consectetur tortor. Sed et pellentesque turpis, id rutrum eros. Quisque id vestibulum justo, id posuere dolor. Sed felis nunc, porta et tortor ac, eleifend sagittis magna.
    
    # Chapter 2
    
    Donec faucibus, lacus eget dignissim imperdiet, nisi massa dictum massa, vel aliquam justo magna sed odio. Donec sagittis nulla ac gravida posuere. Morbi fringilla sem ligula, vel consequat nibh dignissim eu. Donec sodales odio eu dolor vehicula molestie.
    
    ## Subsection I
    
    Aliquam vitae massa nisi. Integer eleifend, mi eget euismod lobortis, ante urna mollis erat, id vulputate massa purus et velit. Suspendisse rutrum semper felis quis porttitor.
    
    * Sed eget ligula eu velit sollicitudin rutrum.
    * Aliquam eleifend nisi at urna commodo adipiscing. 
    
    ## Subsection II
    
    Nulla pellentesque scelerisque metus, sit amet lobortis felis consectetur eget. Ut non tortor vestibulum, faucibus arcu fermentum, mattis est. Etiam scelerisque rutrum orci, ut laoreet mauris ullamcorper sit amet. Duis fringilla tincidunt dui. Curabitur vel ullamcorper nibh.
    
    ### Subsubsection A
    
    ![Fig. 1: Aliquam eleifend fermentum sapien](images/aliquam.jpg)
    
    Suspendisse pulvinar in diam volutpat facilisis. Nunc viverra consectetur ullamcorper. Aliquam eleifend fermentum sapien, id aliquet quam rhoncus id. Integer dictum ullamcorper ligula, id sollicitudin turpis feugiat eu. 
    
    ### Subsubsection B
    
    Cras quis ultrices quam. Duis eleifend ac lectus et vestibulum. Etiam ultrices non nunc non venenatis. Aliquam pharetra quis orci sit amet dapibus. Donec porta vestibulum lacus non fermentum. Vestibulum fringilla dui eget vehicula laoreet. 
```

* There are ways for Pandoc to grab Chapter in seperate files, but we'd like to keep it simple, so stick to one monolithic file.
* Alternatively, by setting the `--toc-depth=2` command in Pandoc, H2 tags `## Chapter Title` can be used as Chapter seperators. But you should only use this when the story was already in one single file when taken from the wiki.

### YAML Metadata Block

[Pandoc supports a special YAML metadata block](http://johnmacfarlane.net/pandoc/demo/example9/epub-metadata.html), instead of having to use `metadata.xml`. 

It is also used to specify the cover image (either in JPG or PNG format) and CSS stylesheet, without needing to use a Pandoc argument.

See [Dublin Core Metadata Elements](http://dublincore.org/documents/dces/) for more information on what goes in this block.

---

Place the metadata block into the very top of your Markdown file, and edit the fields accordingly:

```
    ---
    cover-image:  cover.png
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
    ...
```

### `stylesheet.css` - Style and Font settings

Use this to specify fonts and HTML styling to use. Make sure that you embed the actual font files into the ebook using the Pandoc argument `--epub-embed-font="<font>"`

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

### Download the Font files from Google Web Fonts

Use wget, and put them into the `fonts` folder. We will embed them into the ebook in the next command.

* **Libre Baskerville** - The default Serif font used. - [Google Web Fonts](http://www.google.com/fonts/specimen/Libre+Baskerville)
* **Source Sans Pro** - The default Sans Serif font used. - [Google Web Fonts](https://www.google.com/fonts/specimen/Source+Sans+Pro)

## Pandoc Command

When everything is set, use this Pandoc command to generate the ebook:

    pandoc my-ebook.md -o my-ebook.epub --toc

### Explanation

* `-o "my-ebook.epub"`
  * Tells pandoc to generate an EPUB file with the filename `my-ebook.epub`
* `"my-ebook.md"`
    * The actual ebook content in Markdown format. It contains multiple H1 tags, which will get split into different chapters. Other `.md` files can be placed after this argument to add more chapters. HTML can also be passed as input; even URLs can be used.

* *The options below are superseded by Pandoc's YAML Metadata block, so are not needed, only kept here for reference.*
  * `"title.txt"`
    * Reads this file to create a title page and some title and author metadata. Optionally, this information may be appened to the beginning of the first input document.
  * `--epub-cover-image="cover.jpg"`
    * Creates a cover image file (from either JPG or PNG) and embeds the proper metadata
  * `--epub-metadata="metadata.xml"`
    * Additional Dublin core tags may be defined in this file, including published date, author, publisher, rights, and language. Some of information is pulled from `title.txt`, such as title, author & published date.
  * `--epub-stylesheet="stylesheet.css"`
    * Utilizes a custom stylesheet for any CSS changes or tweaks. Here, the stylesheet name is `stylesheet.css` 

* `--toc`
  * Tells Pandoc to add an HTML table of contents to the beginning of the EPUB file. The machine navigation and toc.ncx file are generated automatically, but at times, the HTML version was not always included.

* `--toc-depth=2`
  * Tells Pandoc to look at the H2 tags and add then as secondary navigation links within both the navigation file and the HTML index. By default, it will look at a depth of 3..

* `--epub-embed-font="<font>"`
  * Use this to embed font into the EPUB. Note that the fonts still need to be specified in `stylesheet.css`.

## Generate MOBI with KindleGen

The Amazon Kindle is the most popular ebook reader in the US, but it is unable to read EPUB-formatted books. Instead a MOBI format ebook must be created, using Amazon's `kindlegen` EPUB to MOBI converter.

[Install `kindlegen`](http://www.amazon.com/gp/feature.html?docId=1000765211) and run this command to convert EPUBs.

    kindlegen my-ebook.epub

A MOBI ebook, `my-ebook.mobi`, will be generated.

## Sources

* [JohnMcFarlane.net - Creating an ebook with Pandoc](http://johnmacfarlane.net/pandoc/epub.html)
* [PuppetLabs - Automated Ebook Generation with Pandoc and Markdown](http://puppetlabs.com/blog/automated-ebook-generation-convert-markdown-epub-mobi-pandoc-kindlegen)