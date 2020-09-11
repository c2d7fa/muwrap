import strutils

let line = readLine(stdin)

proc wrapLine(line: string): string =
    var lines: seq[string] = @[]
    var segment = 0
    while segment * 80 < line.len:
        lines.add(line.substr(segment * 80, (segment + 1) * 80))
        segment += 1
    lines.join("\n")

echo wrapLine(line)
