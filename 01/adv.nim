import strutils, sequtils

var sq : seq[int] = @[]

proc findSum(solution: var seq[int], target: int, max_level: int, level: int = 0, interim: int = 0): bool =
    if level <= max_level:
        for idx, num in sq.pairs:
            if num + interim == target:
                solution.add(num)
                return true
            var test = solution
            test.add(num)
            let found = findSum(test, target, max_level, level + 1, interim + num)
            if found:
                solution = test
                return true
    else:
        return false


let input = open("input.txt")
for line in input.lines:
    sq.add(parseInt(line))
input.close()

const target = 2020
const max_level = 2

var solution: seq[int]
let found = findSum(solution, target, max_level)

echo "Looking for: ", target
echo "Max Level: ", max_level
echo "Found solution? ", found

if found:
    doAssert solution.foldl(a + b) == target
    echo "Numbers: ", solution.join(",")
    echo "Multiplied: ", solution.foldl(a * b)

