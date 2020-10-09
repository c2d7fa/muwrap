import unittest
import lib

import strutils
import sequtils

proc lines(text: string): int = text.splitLines.len
proc allLines(text: string, pred: proc(line: string): bool): bool = text.splitLines.all(pred)
proc isShort(line: string): bool = line.len < 80

block:
  suite "Wrapping lines with <80 characters doesn't change anything":
    test "When there is no trailing whitespace":
      check wrap("Hello, this is a short string.") == "Hello, this is a short string."

    test "When there is a single trailing space":
      check wrap("Hello, this is a short string. ") == "Hello, this is a short string. "

    test "When there is a trailing newline":
      check wrap("Hello, this is a short string.\n") == "Hello, this is a short string.\n"

block:
  let longLine = r"This is a single line of text that is quite long, so when we ask muwrap to wrap it, we would expect it to take up multiple lines. Hopefully the unit tests will be able to automatically tell whether that's the case or not."

  test "Wrapping a line with >80 characters splits it up into multiple lines":
    check longLine.lines == 1
    check wrap(longLine).lines > 1

  test "Wrapping a line with >80 characters gives a string where each line is <=80 characters":
    check wrap(longLine).allLines(isShort)

  test "Wrapping a line with >80 characters gives a string with the same words.":
    check wrap(longLine).splitWhitespace == longLine.splitWhitespace

block:
  let commentLine = r"// This string looks like it could be a code comment. So when muwrap tries to wrap it, it should insert the comment prefix at the beginning of each line. Like uncommented lines, it should be wrapped at 80 characters."

  test "Wrapping a comment line with >80 characters splits it up into multiple lines":
    check commentLine.lines == 1
    check wrap(commentLine).lines > 1

  test "Wrapping a comment line with >80 characters gives a string where each line is <=80 characters":
    check wrap(commentLine).allLines(isShort)

  test "Wrapping a comment line with >80 characters inserts the comment prefix at each line in the output":
    check wrap(commentLine).allLines(proc (line: string): bool = line.startsWith("//"))

  test "A normal word is not repeated, even if it contains an apostrophe":
    let textLine = r"I've noticed that before this bug was fixed, it was the case that a word like ""I've"" would be detected as a comment prefix because it contains a punctuation character."
    check not wrap(textLine).allLines(proc (line: string): bool = line.startsWith("I've"))

block:
  let longLine = r"This is a single line of text that is quite long, so when we ask muwrap to wrap it, we would expect it to take up multiple lines. Hopefully the unit tests will be able to automatically tell whether that's the case or not."

  test "Rewrapping a correctly wrapped paragraph doesn't change anything":
    check wrap(longLine) == wrap(wrap(longLine))
