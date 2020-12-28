import strformat, sequtils, strutils, typetraits, json

# byr (Birth Year)
# iyr (Issue Year)
# eyr (Expiration Year)
# hgt (Height)
# hcl (Hair Color)
# ecl (Eye Color)
# pid (Passport ID)
# cid (Country ID)


# ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
# byr:1937 iyr:2017 cid:147 hgt:183cm

const optionalField: seq[string] = @["cid"]

type
  Passport = object
    byr, iyr, eyr, hgt, hcl, ecl, pid, cid : string

proc hasField(x: var Passport, name: string): bool =
   for n, v in x.fieldPairs:
      if n == name:
         result = true
         break

proc set[T](x: var Passport, s: string, val: T) =
   for n, v in x.fieldPairs:
      if n == s:
         v = val
         break

proc isValid(x: Passport): bool =
    for n, v in x.fieldPairs:
        if v.len == 0 and not(optionalField.contains(n)):
            return false
    return true

proc getPassport(text: string): Passport =
    var passport = Passport()
    var parts = text.split(' ')
    for part in parts.items:
        let keyValue = part.split(':')
        let key = keyValue[0]
        let value = keyValue[1]
        if (passport.hasField(key)):
            passport.set(key, value)
    result = passport


var entries : seq[Passport] = @[]

var entry = ""
let input = open("input.txt")
# let input = open("sample.txt")
for line in input.lines:
    if line.len() > 0:
        if entry.len() == 0:
            entry = entry & line
        else:
            entry = entry & ' '  & line
    else:
        entries.add(getPassport(entry))
        entry = ""
if entry.len() > 0:
    entries.add(getPassport(entry))

# for pass in entries.items:
#     echo $(%* pass)

echo &"{entries.map(isValid).count(true)} of {entries.len()} passports are valid"
    