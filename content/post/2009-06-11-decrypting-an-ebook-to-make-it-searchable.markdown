---
author: admin
categories:
- drm
- ebook
- hacking
- imagemagick
comments: true
date: 2009-06-11T20:23:43Z
slug: decrypting-an-ebook-to-make-it-searchable
title: Decrypting an eBook to make it Searchable
wordpress_id: 364
---

So I spent $22 on an [ebook](http://www.diesel-ebooks.com/cgi-bin/item/0931541611/Voyage-of-Discovery-From-the-Big-Bang-to-the-Ice-Age-eBook.html) for school.

It has this crappy DRM that only lets me view the pdf on one computer using only "Adobe Digital Editions".

If that wasn't so bad, only a small subset of the text is OCR'd, so most of it isn't even searchable!

Now I'm pissed, but wait, what do you say? These files are just RSA encrypted, and I have the key?

Some cool guy named **[i♥cabbages](http://i-u2665-cabbages.blogspot.com/2009/02/circumventing-adobe-adept-drm-for-epub.html) **has released code do extract your key, and then decrypt the file to a good ol' plain pdf. If you want to reproduce my steps you will need to use the [PDF decrypter](http://www.cs.helsinki.fi/u/vahakang/ineptpdf.pyw) unless you have epubs.

So I use the tool and get a pdf, now I can use one of the most awesome tools in the world: [Imagemagick](http://en.wikipedia.org/wiki/ImageMagick).

Imagemagick can whip this pdf into shape. The first thing I'm going to do is convert each page into a tiff:


    $ convert -density 200 input.pdf[1-124] -depth 8 -monochrome %05d.tif


Then I'm going to run tesseract-ocr on them to get the text:


    $ for i in $(seq --format=%005.f 1 324)
    do
    tesseract $i.tif tesseract-$i -l eng
    done


Now all I have to do is cat all the text together:


    cat *.txt > output.txt


Now I have a fully searchable, plain text file. Exactly what I wanted in the first place!

For the REAL magic, I use agrep to search for strings similar to provided example test questions to help "highlight" the answers. More technical details on that magic on [my wiki](http://wiki.xkyle.com/Answer_Finder).

[![answer](/uploads/answer-300x25.jpg)](/uploads/answer.JPG)

