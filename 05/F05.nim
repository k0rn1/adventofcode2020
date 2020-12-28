import sequtils, strutils, typetraits, json, math, sequtils, strutils, strutils

type
  Seat = object
    row: int
    column: int
    seatId: int  

# BFFFBBFRRR: row 70, column 7, seat ID 567.
# FFFBBBFRRR: row 14, column 7, seat ID 119.
# BBFFBBFRLL: row 102, column 4, seat ID 820.
    
proc binarySpacePart(input: var string, first: int, last: int, seat: var Seat) =
    # echo input, " first ", first, " last ", last
    var sym = input[0]
    var ff, ll: int
    case sym:
    of {'F', 'L'}:
        ff = first
        ll = first + trunc((last - first) / 2 ).int
    of {'B', 'R'}:
        ll = last
        ff = last - trunc((last - first) / 2).int
    else:
        raise newException(ValueError, "Unrecognized letter")

    input.delete(0, 0)
    if ff == ll:
        if input.len > 2:
            seat.row = ff
            ff = 0
            ll = 7
        else:
            seat.column = ff
            seat.seatId = seat.row * 8 + seat.column
    if input.len > 0:
        var ss = input
        binarySpacePart(ss, ff, ll, seat)


var entries : seq[Seat] = @[]

let input = open("input.txt")
for line in input.lines:
    var solution = Seat()
    var s = line
    binarySpacePart(s, 0, 127, solution)
    entries.add(solution)

echo entries.map(proc(x: Seat): int = x.seatId).max(), " is the highest seatId"
