import strutils
let targetSum = 2020;

let input = open("input.txt")
var sq : seq[int] = @[]
for line in input.lines:
    sq.add(parseInt(line))

block findCandidates:
    for i, x in sq.pairs:
        for j, y in sq.pairs:
            for k, z in sq.pairs:
                if i != j and i != k:
                    # echo x + y
                    if (x + y + z) == targetSum:
                        echo "C1:", x
                        echo "C2:", y
                        echo "C3:", z
                        echo "Solution: ", x*y*z
                        break findCandidates
input.close()
