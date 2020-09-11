import strutils


let fullLine = readLine(stdin)

proc extractPrefix(fullLine: string): (string, string) =
    (fullLine.substr(0, 1), fullLine.substr(2))

proc wrapLine(line: string, prefix: string): string =
    var lines: seq[string] = @[]
    var segment = 0
    while segment * 80 < line.len:
        lines.add(prefix & line.substr(segment * 80, (segment + 1) * 80))
        segment += 1
    lines.join("\n")

let (prefix, line) = extractPrefix(fullLine)
echo wrapLine(line, prefix)
