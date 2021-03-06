import strformat

const treeSym = '#'
const AddX = 3
const AddY = 1

# const MAX_Y = 11
# const MAX_X = 12
# const fileName = "sample.txt"

const MAX_Y = 323
const MAX_X = 32
const fileName = "input.txt"

var matrix: array[MAX_Y, array[MAX_X, char]]

proc getX(x: int): int =
    result = x mod (MAX_X - 1)


var y = 0
let input = open(fileName)
for line in input.lines:
    for j, x in line.pairs:
        matrix[y][j] = x
    y += 1

# for i in 0..<MAX_Y:
#     for j in 0..<MAX_X:
#         stdout.write matrix[i][j]
#     stdout.write "\n"

y = 0
var x = 0
var trees = 0
while y < MAX_Y:
    # echo &"Looking at [{y}][{getX(x)}] ({x}) ({matrix[y][getX(x)]})"
    if matrix[y][getX(x)] == treeSym:
        trees += 1
    x += AddX
    y += AddY


echo &"Found {trees} trees"

    