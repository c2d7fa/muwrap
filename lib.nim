import strutils except splitWhitespace, strip
import sequtils
import unicode

proc looksLikeCommentPrefix(word: string): bool =
    not toSeq(word.runes).anyIt(it.isAlpha)

proc extractPrefix(fullLine: string): (string, string) =
    let prefix = splitWhitespace(fullLine)[0]
    if looksLikeCommentPrefix(prefix):
        # Assume that there is a space after the prefix.
        (fullLine.substr(0, prefix.len), fullLine.substr(prefix.len + 1))
    else:
        ("", fullLine)

proc preserveTrailingWhitespace(output: string, input: string): string =
  result = output.strip(leading = false)
  if input.endsWith(" "):
    result &= " "
  elif input.endsWith("\n"):
    result &= "\n"

proc wrapLine(line: string, prefix: string): string =
    var lines: seq[string] = @[]

    proc addLine(currentLine: seq[string]) =
        lines.add(prefix & currentLine.filterIt(not it.isEmptyOrWhitespace).join(" ").strip)

    var currentLine: seq[string] = @[]
    for word in splitWhitespace(line):
        if prefix.len + currentLine.join(" ").len + word.len > 80:
            addLine(currentLine)
            currentLine = @[]
        currentLine.add(word)
    addLine(currentLine)

    lines.join("\n").preserveTrailingWhitespace(line)

proc wrap*(text: string): string =
  let (prefix, line) = extractPrefix(text)
  wrapLine(line, prefix)

