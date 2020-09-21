# muwrap

`muwrap` is a simple command-line utility for wrapping text.

Pipe text into `muwrap`, and it'll echo a wrapped version of that text. It
automatically handles comment characters.

    $ cat >example
    // This is an example of a long comment. Let me show you how to use muwrap to automatically wrap this comment into multiple lines.
    $ muwrap <example
    // This is an example of a long comment. Let me show you how to use muwrap to
    // automatically wrap this comment into multiple lines.

## Building

`muwrap` is written in Nim. Install Nim, and then run this command to compile it:

    $ nim compile main.nim

This will create the `main` executable. You should put this somewhere in your
path. For example, if you have `~/bin/` in your path, run:

    $ mv main ~/bin/muwrap

## Kakoune

I use this with [Kakoune](https://kakoune.org/). Just select some text, and then
type `|muwrap<ret>` to replace it with the wrapped version, assuming you have
`muwrap` in your path. You can bind it to `,w` with this line in your `kakrc`:

    map global user w '|muwrap<ret>'
