import strscans, strformat, strutils

# Sample input --> 4-5 m: mmpth
var min, max: int
var ch: string
var pw: string

var count = 0

let input = open("input.txt")
for line in input.lines:
    if scanf(line, "$i-$i $w: $+", min, max, ch, pw):
        # echo &"line: {line}, min: {min}, max: {max}, ch: {ch}, pw: {pw}"
        var occurances = pw.count(ch)
        if (occurances >= min and occurances <= max):
            count+=1
    else:
        echo &"FAILED to parse: {line}"

echo &"Found {count} correct passwords"