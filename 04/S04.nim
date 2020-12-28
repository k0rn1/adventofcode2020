import strformat, sequtils, strutils, typetraits, json, macros, re

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

type
  MappedField = object
    fieldName*: string
    regex*: string
    isOptional*: bool

template restrict(pattern: string) {.pragma.}

proc getFieldPragmas(res: var seq[MappedField], node: NimNode) =
  var mf = MappedField()
  var toValidate = false
  for n in node:
    if n.kind == nnkPragmaExpr:
      for nn in n:
        if nn.kind == nnkIdent:
          mf.fieldName = nn.strVal
        if nn.kind == nnkPragma:
          if nn[0][0].kind == nnkSym and nn[0][0].strVal == "restrict":
            toValidate = true
            mf.regex = nn[0][1].strVal
      if toValidate:
        res.add(mf)
      mf = MappedField()
      toValidate = false
    else:
      getFieldPragmas(res, n)
  
proc checkField(mf: MappedField): seq[NimNode]= 
  result.add(
    newIfStmt((
        parseStmt(&"not(match(obj.{mf.fieldName}, re\"^{mf.regex}$\"))"),
        newStmtList(
            parseStmt(&"echo \"  {mf.fieldName} failed obj.{mf.fieldName}\""),
            parseStmt(&"echo \"    \", obj.{mf.fieldName}"),
            parseStmt("return false")
        )
    ))
  )

macro addValidators(t: typedesc): untyped =
  var sol: seq[MappedField]
  getFieldPragmas(sol, t.getImpl)

  var stmts: seq[NimNode] = @[]
  for x in sol:
    var  fildConds = checkField(x)
    for subFilds in fildConds:
      stmts.add(subFilds)
  stmts.add(parseStmt("return true"))

  result = newProc(
        name = ident("validate"),
        params = [ident("bool"), newIdentDefs(ident("obj"), ident("Passport"))],
        body = newStmtList(stmts),
    )



const optionalField: seq[string] = @["cid"]

#[
    byr (Birth Year) - four digits; at least 1920 and at most 2002.
    iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    hgt (Height) - a number followed by either cm or in:
    * If cm, the number must be at least 150 and at most 193.
    * If in, the number must be at least 59 and at most 76.
    hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    pid (Passport ID) - a nine-digit number, including leading zeroes.
    cid (Country ID) - ignored, missing or not.
]#

type
  Passport = object
    byr {.restrict("(192\\d|19[3-9]\\d|200[0-2])").} : string 
    iyr {.restrict("201\\d|2020").} : string 
    eyr {.restrict("202\\d|2030").} : string 
    hgt {.restrict("(59|6\\d|7[0-6])in|(15\\d|1[6-8]\\d|19[0-3])cm").} : string 
    hcl {.restrict("#[0-9a-f]{6}").} : string 
    ecl {.restrict("amb|blu|brn|gry|grn|hzl|oth").} : string 
    pid {.restrict("\\d{9}").} : string 
    cid : string

addValidators(Passport)

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
    echo x
    for n, v in x.fieldPairs:
        if v.len == 0 and not(optionalField.contains(n)):
            return false
    return x.validate()

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
# let input = open("test.txt")
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

echo &"{entries.map(isValid).count(true)} of {entries.len()} passports are valid"
    