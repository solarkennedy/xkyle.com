---
title: "A Detailed Comparison of YAML Formatters"
date: 2022-11-29T00:00:00-00:00
---

This is a survey of the current state of YAML formatters.
For this blog post, I'm comparing tools that take YAML files on disk and rewrite them to some standard.
This is beyond the scope of a normal YAML linter.

If you ask me, all file formats deserve a `fmt` tool.
YAML is not exception, especially as it is [not the best](https://www.arp242.net/yaml-config.html).
In fact there is even `StrictYAML` with [features removed](https://hitchdev.com/strictyaml/features-removed/).
This isn't quite a `fmt` tool, but limiting the craziness you can put in a YAML file certainly makes it easier to format!

After looking these formatters, **_I think they still do not go far enough_**.
None of them block the [Norway problem](https://hitchdev.com/strictyaml/why/implicit-typing-removed/).
All of them (except Prettier) turn multiline complexity into multiline insanity.
Maybe someday I'll write my own YAML formatter, probably based on `StrictYAML`, that blocks nonsense and homogenizes _everything_.

Till then, if I missed a linter or missed a feature you are interested in, just [email me](kyle@xkyle.com?subject=YAML Formatters).
Or better yet make a [pull request on the code I used](https://github.com/solarkennedy/yaml-formatter-comparison).

## The List

- [Google (unofficial) yamlfmt](https://github.com/google/yamlfmt): Standalone tool for formatting YAML
- [pre-commit-hook-yamlfmtl](https://github.com/jumanjihouse/pre-commit-hook-yamlfmt): a hook for the [pre-commit](http://pre-commit.com/) system
- [Python yamlfmt](https://pypi.org/project/yamlfmt/): A CLI wrapper around the [python ruamel.yaml](https://pypi.org/project/ruamel.yaml/) library
- [Prettier](https://github.com/prettier/prettier): A general purpose formatting tool for many languages

And here is a TLDR summary of the results given default settings:

| Formatter                           | Google yamlfmt                             | Pre-commit yamlfmt             | Python yamlfmt                 | Prettier     |
| ----------------------------------- | ------------------------------------------ | ------------------------------ | ------------------------------ | ------------ |
| Language                            | golang                                     | python                         | python                         | nodejs       |
| Preserves anchors                   | Yes (adds explicit `!!merge`)              | Yes (misplaces comment)        | Yes (misplaces comment)        | Yes          |
| Homogenizes horizontal whitespace   | Yes (removed blank newlines)               | No                             | No                             | No           |
| Homogenizes indents?                | Defaults to 2 spaces                       | Defaults to 4 spaces           | Preserves original             | 2 spaces     |
| Multiline strings? (already insane) | Converts newlines to `\n` unless using `>` | Adds `"` and escapes with `\"` | Adds `"` and escapes with `\"` | Preserves    |
| `---` Header?                       | Removes it                                 | Adds it                        | Removes it                     | Preserves it |
| `!!TYPE` explicit types             | Preserves                                  | Removes                        | Removes                        | Preserves    |

None of the formatters had features I wanted:

- Homogenize bools (no more `NO`s)
- Normalize nulls (no more emptiness being null or `~`)
- Normalize date formats
- Normalize floats
- Normalize hex strings

I guess I mostly want something that morphs YAML's leniency into whatever JSON has as its final representation.

## Input

See the [input file here](https://github.com/solarkennedy/yaml-formatter-comparison/blob/master/in.yaml).
I tried to add as many weird things in there as possible, to exercise the formatters to their maximum.

## Results

### Google yamlfmt

Google yamlfmt produced some of them most opinionated outputs, but is also the most configurable.
It has the _potential_ to be the formatter I want, I think it just needs a special `kyle` formatter instead of the [basic](https://github.com/google/yamlfmt/tree/main/formatters/basic) one :).
Still, the fact that it removes horizontal whitespace seems weird to me (Defaults with `retain_line_breaks: false`).
I think line breaks should be preserved, but multiple line breaks should be normalized to 1 (Prettier's behavior).

There is also something to be said about a golang tool that can be installed via a binary.
I appreciate that the Google yamlfmt tool doesn't impose installing ... anything except itself (no npm, node, python, etc).

### Pre-commit yamlfmt

The Pre-commit yamlfmt tool is designed to be used with the [pre-commit](http://pre-commit.com/) ecosystem, but it can be used in a standalone way.
It has some configuration, with the current defaults:

    mapping: 4 spaces
    sequence: 6 spaces
    offset: 4 spaces
    colons: do not align top-level colons
    width: None (use ruamel default)

### Python yamlfmt

This standalone python script has no configuration.
In some sense it is the _most_ opinionated tool!
Yet in a different way, it did the _least_ actual formatting.

### Prettier

Prettier is a general purpose formatting tool.
If your needs extend past YAML and include other formats, it may be worth it to just use one tool (Prettier), if you don't mind install node/npm.

Prettier is also very opinionated (very few options), and it does impose some of those opinions.

## Conclusion

My preference is for google yamlfmt.
After working with Python professionally, I'm tired of fighting Python interpreters and pip.
I also lost little faith after these python yaml [code execution](https://www.cvedetails.com/cve/CVE-2019-20478/) [vulnerabilities](https://www.cvedetails.com/cve/CVE-2020-14343/).
(Ruby is [not immune](https://www.sitepoint.com/anatomy-of-an-exploit-an-in-depth-look-at-the-rails-yaml-vulnerability/))
I do appreciate Prettier.
If you need to format lots of different stuff in one project, it might be easier to let prettier do it all.

YAML is in a weird position where it's desire to be human-friendly leads to weirdness.
Its flexibility is its downside, and its not opinionated enough in the right places to prevent more mistakes.

Till then, as with all file formats, I'm happy for any computer-enforced style guide (aka a `fmt` tool).
I hope this review inspires you to adopt one, any one.
