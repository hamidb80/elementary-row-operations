import std/[strutils, strformat, rationals, sequtils, os, times, terminal]

# Types ------------------------------

type
  Number = Rational[int]
  Row = seq[Number]
  Matrix = seq[Row]

  OperationKind = enum
    okAdd
    okScale
    okSwap
    okPrint
    okAppendRow
    okTranspose
    okMirrorX
    okMirrorY

  Operation = object
    kind: OperationKind
    r1: int
    r2: int
    coeff: Number
    row: Row

# Utils ------------------------------

func even(n: int): bool = 
  n mod 2 == 0

func odd(n: int): bool = 
  not even n

func parseRational(s: string): Number =
  if s.isEmptyOrWhitespace: toRational 1
  else:
    let t = s.split '/'
    case t.len
    of 1: toRational parseint s
    of 2: initRational(parseInt t[0], parseInt t[1])
    else: raise newException(ValueError, "inv len")

func isRational(s: string): bool =
  try:
    let _ = parseRational s
    true
  except:
    false


# Matrix Tools ------------------------------

func width(m: Matrix): int = m[0].len
func height(m: Matrix): int = m.len

func initMatrix(rows, cols: int, dflt: Number = 0.toRational): Matrix = 
  let r = newSeqWith(cols, dflt)
  newSeqWith(rows, r)

proc printMatrix(m: Matrix) =
  var acc: seq[string]

  for row in m:
    for cell in row:
      add acc:
        if cell.den == 1: $cell.num
        else: $cell

  let maxCellLen = max acc.mapit it.len

  for y in 0..<m.height:
    for x in 0..<m.width:
      let i = y * m.width + x
      stdout.write acc[i].align maxCellLen + 1
    stdout.write '\n'
  stdout.write '\n'

func parseRowNumber(s: string): int =
  # r1 // 1
  case s[0]
  of 'r': parseInt s.substr(1)
  else: raise newException(ValueError, fmt"invalid row number: {s}")

proc parseOperation(l: string): Operation =
  # r1 += -3r1 // r1 <-- r1 -3.r2
  # r1 *= 3    // r1 <-- 3.r1
  # r1 <> r2   // [itself]
  # ?          // prints the whole matrix
  # 1 2 ...    // add this row to the matrix

  try:
    let parts = l.strip.splitWhitespace

    case parts[0]
    of "?":
      Operation(kind: okPrint)
    of "t":
      Operation(kind: okTranspose)
    of "mx":
      Operation(kind: okMirrorX)
    of "my":
      Operation(kind: okMirrorY)
    elif isRational parts[0]:
      Operation(kind: okAppendRow, row: parts.mapit(parseRational it))
    else:
      let r1 = parseRowNumber parts[0]
      let k =
        case parts[1]
        of "+=": okAdd
        of "*=": okScale
        of "<>": okSwap
        else: raise newException(ValueError,
            fmt"invalid operation: '{parts[0]}'")

      case k
      of okAdd:
        let term = parts[2].split('r')
        let c = parseRational term[0]
        let r2 = parseInt term[1]
        Operation(kind: k, r1: r1, r2: r2, coeff: c)

      of okScale:
        let c = parseRational parts[2]
        Operation(kind: k, r1: r1, coeff: c)

      of okSwap:
        let r2 = parseRowNumber parts[2]
        Operation(kind: k, r1: r1, r2: r2)

      else:
        raiseAssert "unreachable"
  except:
    echo fmt"failed to parse {l}"
    raise

proc applyOperation(m: sink Matrix, op: Operation): Matrix =
  # debugecho op

  case op.kind
  of okPrint:
    echo ">> "
    printMatrix m

  of okAppendRow:
    if m.height == 0 or m.width == op.row.len:
      add m, op.row
    else:
      raise newException(ValueError, fmt "the length of row does not match. the matrix size {m.height}x{m.width} but the row size is: {op.row.len} \nhere's the row: {op.row}")

  of okScale:
    for i in 0..<m.width:
      m[op.r1-1][i] *= op.coeff

  of okAdd:
    for i in 0..<m.width:
      m[op.r1-1][i] += op.coeff * m[op.r2-1][i]

  of okSwap:
    (m[op.r1-1], m[op.r2-1]) = (m[op.r2-1], m[op.r1-1])

  of okTranspose:
    var newm = initMatrix(m.width, m.height)
    for y in 0..<m.height:
      for x in 0..<m.width:
        newm[x][y] = m[y][x]
    m = newm

  of okMirrorX:
    for y in 0..<m.height:
      let lim = 
        if even m.width: m.width div 2 - 1
        else: m.width div 2 
      for x in 0..lim:
        swap m[y][x], m[y][m.width - x - 1]

  of okMirrorY:
    let lim =
      if even m.height: m.height div 2 - 1
      else: m.height div 2 

    for x in 0..<m.width:
      for y in 0..lim:
        swap m[y][x], m[m.height - y - 1][x]

  m

proc doOperations(fcontent: string): Matrix =
  for l in fcontent.splitLines:
    if not isEmptyOrWhitespace l:
      let op = parseOperation l
      result = result.applyOperation op

# Run ------------------------------

proc main =
  if paramCount() == 1:
    let fpath = paramStr 1

    var lastTime = now().toTime
    var firstTime = true

    while true:
      let mtime = getLastModificationTime fpath
      if firstTime or mtime > lastTime:
        eraseScreen stdout

        let content = readFile fpath
        discard doOperations content

        echo "---------------------------"

        lastTime = mtime
        firstTime = false

  else:
    echo "\n\tUSAGE: app path/to/operations.txt\n"

main()
