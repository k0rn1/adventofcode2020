import strscans, strformat, strutils

# Sample input --> 4-5 m: mmpth
var pos1, pos2: int
var ch: string
var pw: string

var count = 0

let input = open("input.txt")
for line in input.lines:
    # somehow cannot us $c with char
    if scanf(line, "$i-$i $w: $+", pos1, pos2, ch, pw):
        # echo &"line: {line}, pos1: {pos1}, pos2: {pos2}, ch: {ch}, pw: {pw}"
        var occurances = 0
        if pos1 <= pw.len() and pw[pos1 - 1] == ch[0]: occurances+=1
        if pos2 <= pw.len() and pw[pos2 - 1] == ch[0]: occurances+=1
        if occurances == 1:
            count+=1
    else:
        echo &"FAILED to parse: {line}"

echo &"Found {count} correct passwords"