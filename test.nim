import unittest
import lib

import strutils
import sequtils

test "Wrapping a line with <80 characters doesn't change anything":
  check wrap(r"Hello, this is a short string.") == r"Hello, this is a short string."

block:
  let longLine = r"This is a single line of text that is quite long, so when we ask muwrap to wrap it, we would expect it to take up multiple lines. Hopefully the unit tests will be able to automatically tell whether that's the case or not."

  proc lines(text: string): int = text.splitLines.len
  proc isShort(text: string): bool = text.len < 80
  proc allLinesShort(text: string): bool = text.splitLines.all(isShort)

  test "Wrapping a line with >80 characters splits it up into multiple lines":
    check longLine.lines == 1
    check wrap(longLine).lines > 1

  test "Wrapping a line with >80 characters gives a string where each line is <=80 characters":
    check wrap(longLine).allLinesShort

  test "Wrapping a line with >80 characters gives a string with the same words.":
    check wrap(longLine).splitWhitespace == longLine.splitWhitespace

