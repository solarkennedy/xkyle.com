---
layout: post
title: "A Comparison of Image to ASCII Conversion Tools"
date: 2015-09-26 19:35:56 -0700
comments: true
categories: 
---

Inspired by [ponysay](https://github.com/erkin/ponysay), I think wicked
ascii/ansi artwork on the terminal is great.

I decided to survey all the tools I could find that aid in this conversion
to see if there were any dramatic differences in results.

## Methodology

For these tests I used an image with a 160px width, twice that of
a standard terminal. Then I `cat`'d the image in plain xterm and
took a screenshot of the results.

The original has been scaled up (6X) to be the same relative size as
the resulting screenshots.

My entire methodology is on [github](https://github.com/solarkennedy/ascii-art-converter-comparison)
if you wish to see exactly how I made these images. In theory
it is 100% reproducible from `make`. (assuming on a linux desktop)

## Tools Compared

* [img2xterm](https://github.com/rossy/img2xterm)
* [util-say](https://github.com/maandree/util-say/)
* [catimg](https://github.com/posva/catimg) (C and Bash versions)
* [img-cat](https://github.com/saikobee/img-cat/)
* [img2txt](http://manpages.ubuntu.com/manpages/hardy/man1/img2txt.1.html)
* [jp2a](https://csl.name/jp2a/)

## Results

### bender.png
![bender.png converted using original](/uploads/bender.original.png 'bender.png converted using original')
![bender.png converted using img2xterm](/uploads/bender.img2xterm.png 'bender.png converted using img2xterm')
![bender.png converted using util-say](/uploads/bender.util-say.png 'bender.png converted using util-say')
![bender.png converted using catimg](/uploads/bender.catimg.png 'bender.png converted using catimg')
![bender.png converted using catimg-bash](/uploads/bender.catimg-bash.png 'bender.png converted using catimg-bash')
![bender.png converted using img-cat](/uploads/bender.img-cat.png 'bender.png converted using img-cat')
![bender.png converted using img2txt](/uploads/bender.img2txt.png 'bender.png converted using img2txt')
![bender.png converted using jp2a](/uploads/bender.jp2a.png 'bender.png converted using jp2a')

### lenna.png
![lenna.png converted using original](/uploads/lenna.original.png 'lenna.png converted using original')
![lenna.png converted using img2xterm](/uploads/lenna.img2xterm.png 'lenna.png converted using img2xterm')
![lenna.png converted using util-say](/uploads/lenna.util-say.png 'lenna.png converted using util-say')
![lenna.png converted using catimg](/uploads/lenna.catimg.png 'lenna.png converted using catimg')
![lenna.png converted using catimg-bash](/uploads/lenna.catimg-bash.png 'lenna.png converted using catimg-bash')
![lenna.png converted using img-cat](/uploads/lenna.img-cat.png 'lenna.png converted using img-cat')
![lenna.png converted using img2txt](/uploads/lenna.img2txt.png 'lenna.png converted using img2txt')
![lenna.png converted using jp2a](/uploads/lenna.jp2a.png 'lenna.png converted using jp2a')

### nyan.png
![nyan.png converted using original](/uploads/nyan.original.png 'nyan.png converted using original')
![nyan.png converted using img2xterm](/uploads/nyan.img2xterm.png 'nyan.png converted using img2xterm')
![nyan.png converted using util-say](/uploads/nyan.util-say.png 'nyan.png converted using util-say')
![nyan.png converted using catimg](/uploads/nyan.catimg.png 'nyan.png converted using catimg')
![nyan.png converted using catimg-bash](/uploads/nyan.catimg-bash.png 'nyan.png converted using catimg-bash')
![nyan.png converted using img-cat](/uploads/nyan.img-cat.png 'nyan.png converted using img-cat')
![nyan.png converted using img2txt](/uploads/nyan.img2txt.png 'nyan.png converted using img2txt')
![nyan.png converted using jp2a](/uploads/nyan.jp2a.png 'nyan.png converted using jp2a')

## Conclusion

[img2xterm](https://github.com/rossy/img2xterm) stands out to me as the most
accurate and true to the original, with [util-say](https://github.com/maandree/util-say/)
as a close second. Both of these tools understand "[half-block](http://www.theasciicode.com.ar/extended-ascii-code/bottom-half-block-ascii-code-220.html)"
characters with two colors, effectively doubling the horizontal resolution of the resulting
characters. (two colors per "pixel")

[catimg](https://github.com/posva/catimg) and [img-cat](https://github.com/saikobee/img-cat/)
both have good color representation, but lack the additional resolution compared to the
other tools, giving it a more "pixelated" look.

[img2txt](http://manpages.ubuntu.com/manpages/hardy/man1/img2txt.1.html) and [jp2a](https://csl.name/jp2a/)
are "true ascii" tools, they are really not in the same league as the others. I included them
here for completeness.
