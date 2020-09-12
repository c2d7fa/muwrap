# `muwrap`

`muwrap` is a simple command-line utility for wrapping text.

Pipe text into `muwrap`, and it'll echo a wrapped version of that text. It
automatically handles comment characters.

## Kakoune

I use this with [Kakoune](https://kakoune.org/). Just select some text, and then
type `|muwrap<ret>` to replace it with the wrapped version, assuming you have
`muwrap` in your path. You can bind it to `,w` with this line in your `kakrc`:

    map global user w '|muwrap<ret>'
