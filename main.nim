import strutils


let fullLine = readLine(stdin)

proc extractPrefix(fullLine: string): (string, string) =
    (fullLine.substr(0, 1), fullLine.substr(2))

proc wrapLine(line: string, prefix: string): string =
    var lines: seq[string] = @[]

    var currentLine: seq[string] = @[]
    for word in splitWhitespace(line):
        if prefix.len + currentLine.join(" ").len + word.len > 80:
            lines.add(prefix & currentLine.join(" "))
            currentLine = @[]
        currentLine.add(word)
    lines.add(prefix & currentLine.join(" "))

    lines.join("\n")

let (prefix, line) = extractPrefix(fullLine)
echo wrapLine(line, prefix)
