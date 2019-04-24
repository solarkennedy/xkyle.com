---
categories: null
comments: true
date: 2019-XX-XXT19:35:56Z
published: true
title: epaper-watch Project: Cleaning the Literary Quotes Database
---

Epaper-watch intro

## Cleaning The Dataset

The CSV has over 1,400 quotes in it. As much as possible I used tools to programmatically clean this data and used `git diff` to check the output at each step.

The original database of quotes comes from quotes collected by
[The Guardian](https://www.theguardian.com/books/booksblog/2011/apr/15/christian-marclay-the-clock-literature)
for an art installation.

I used an annotated version from of that database built by Jaap Meijers for a
[Kindle-based](https://www.instructables.com/id/Literary-Clock-Made-From-E-reader/)
version of this clock.

To fit on my tiny epaper display, I had to clean up the dataset.

## Quotation Mark Cleaning

The database is full of lots of quotes, as in quotation marks. Lots of them. Triple-double quotes, smart quotes, smart single quotes, backticks, etc.

Vim macros help me manually clean up the zoo of quotation marks and strip out all the extra ones. Given the limited number of characters I can display on the watch face, I don't think there is any need to put quotes around the quote itself, just print the thing:

```
-"""I am going to lock you in. It is-"" he consulted his watch, ""five minutes to midnight. Miss Granger, three turns should do it. Good luck."""|Harry Potter and the Prisoner of Azkaban|J. K. Rowling
+"I am going to lock you in. It is-" he consulted his watch, "five minutes to midnight. Miss Granger, three turns should do it. Good luck."|Harry Potter and the Prisoner of Azkaban|J. K. Rowling
```

```
-"""What makes you think it's for real?"" ""Just a hunch, really. He sounded for real. Sometimes you can just tell about people""-he smiled-""even if you're a dull old WASP."" ""I thi
ny?"" ""I just do. Why would someone from the government want to help you?"" ""Good question. Guess I'll find out."" She went back into the kitchen.""What time are you meeting him?"" she called out. ""Eleven oh-three,"" he said. ""That made me think he's for real. Military and intelligence types set precise appointment times to eliminate confusion and ambiguity. Nothing ambiguous about eleven oh-three."""|Little Green Men|Christopher Buckley
+"Good question. Guess I'll find out." She went back into the kitchen. "What time are you meeting him?" she called out. "Eleven oh-three," he said.|Little Green Men|Christopher Buckley
```

## Duplicates

By sorting the dataset, duplicate quotes become more visible. Literally identical quotes can be removed programmatically:

```
sort litclock_annotated.csv | uniq > tmp && mv tmp litclock_annotated.csv
```

Many quotes are used multiple times for multiple minutes, so it isn't safe to blindly remove any quote that is used more than once.

## Manually Shrinking the Text

Many quotes are very long and contain lots of context. Some quotes are very floral and contain long run-on sentences.

I couldn't think of a programmatic way of reducing the length of the quote to less than 180 characters.

This step was mostly manual work, tool-assisted by having the code generation python script raise an exception if it parsed a quote longer than 180 chars:

```
-It was eight minutes to midnight. Just nice time, I said to myself. Indoors, everything was quiet and in darkness. Splendid. I went to the bar and fetched a tumbler, a siphon of soda and a bottle of Glen Grant, took a weak drink and a pill, and settled down in the public dining-room to wait the remaining two minutes.|The Green Man|Kingsley Amis
+It was eight minutes to midnight. Just nice time, I said to myself. Indoors, everything was quiet and in darkness. Splendid.|The Green Man|Kingsley Amis
```
I tried to keep the time string located somewhere in the middle of the quote, with context around it. I took some artistic license in shortening the quotes and replacing the missing text with `...`.

## Removing Non-ASCII Characters

I didn't bother updating the epaper library to support Unicode characters on
custom fonts. That would be a nice addition someday.

Till then I used `sed` to replace non-ascii characters en-masse with a
[script](https://github.com/solarkennedy/epaper-watch/blob/master/replace-non-ascii.sh).

## Author Annotation

## Duplicating AM / PM Timed Quotes
