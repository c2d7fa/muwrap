import unittest
import lib

import strutils
import sequtils

proc lines(text: string): int = text.splitLines.len
proc allLines(text: string, pred: proc(line: string): bool): bool = text.splitLines.all(pred)
proc isShort(line: string): bool = line.len < 80
proc hasNoSpaceSequences(text: string): bool = not text.contains("  ")

proc first[T](xs: seq[T]): T = xs[0]
proc rest[T](xs: seq[T]): seq[T] = xs[1..^0]

proc eachStartsWith(strings: seq[string], prefix: string): bool =
  strings.all(proc (s: string): bool = s.startsWith(prefix))
proc noneContains(strings: seq[string], search: string): bool =
  not strings.any(proc (s: string): bool = s.contains(search))

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

suite "Collapsing whitespace":
  test "Trailing whitespace inside a paragraph is collapsed when all newlines are removed":
    check wrap("Hello, this is a paragraph that should be   \nwrapped onto a single line.").hasNoSpaceSequences

  test "Trailing whitespace inside a paragraph is collapsed when the paragraph is otherwise correctly wrapped":
    let paragraph = "This is an example of a paragraph that is already correctly wrapped at the 80  \ncharacter column, with the notable exception that some lines in this paragraph  \ncontains trailing whitespace."
    check wrap(paragraph).hasNoSpaceSequences

  test "Mulitple sequential spaces are collapsed":
    check wrap("This    string   has   too    many   spaces!").hasNoSpaceSequences

suite "Preserving indentation":
  let longLine = r"    This line is indented by four spaces. When it is wrapped, it will retain the indentation, and the following lines will also be indented by four spaces."

  test "Long line with indentation is wrapped":
    check wrap(longLine).lines > 1

#  test "All lines preserve indentation":
#    check wrap(longLine).splitLines.eachStartsWith("    ")

#suite "Wrapping an indented list item":
#  let longLineHyphen = r"  - This is a list item that is indented by two spaces and begins with a hyphen (or asterisk), which is considered a list character. It will be wrapped such that the following text is indented to the first line."
#  let longLineAsterisk = longLineHyphen.replace("-", "*")
#
#  test "Preserves the indentation on the first line":
#    check wrap(longLineHyphen).splitLines.first.startsWith("  - ")
#    check wrap(longLineAsterisk).splitLines.first.startsWith("  * ")
#
#  test "Adds extra indentation on the following lines":
#    check wrap(longLineHyphen).splitLines.rest.eachStartsWith("    ")
#    check wrap(longLineAsterisk).splitLines.rest.eachStartsWith("    ")
#
#  test "Doesn't repeat the list character on the following lines":
#    check wrap(longLineHyphen).splitLines.rest.noneContains("-")
#    check wrap(longLineAsterisk).splitLines.rest.noneContains("*")

#suite "Examples":
#  test "Example 1":
#    let input = "    # The prefix is everything until the first word character, including\n    # any indentation and comment syntax. For example, the prefix of this\n    # line would be \"    # \"."
#    let expectedOutput = "TODO"
#    check wrap(input) == expectedOutput
