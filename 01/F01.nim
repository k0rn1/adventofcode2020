import strutils
let targetSum = 2020;

let input = open("input.txt")
var sq : seq[int] = @[]
for line in input.lines:
    sq.add(parseInt(line))

block findCandidates:
    for i, x in sq.pairs:
        for j, y in sq.pairs:
            if i != j:
                # echo x + y
                if (x + y) == targetSum:
                    echo "C1:", x
                    echo "C2:", y
                    echo "Solution: ", x*y
                    break findCandidates
input.close()
