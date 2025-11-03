import std/[strutils, strformat, rationals, sequtils, os, times, terminal]
import ./core

proc doOperations(fcontent: string): Matrix =
  for l in fcontent.splitLines:
    if not isEmptyOrWhitespace l:
      let op = parseOperation l
      case op.kind
      of okPrint:
        echo ">>"
        echo result.toHumanReadable
      else:
        result = result.applyOperation op

proc main =
  if paramCount() == 1:
    let fpath = paramStr 1

    var lastTime = now().toTime
    var firstTime = true

    while true:
      let mtime = getLastModificationTime fpath
      if firstTime or mtime > lastTime:
        eraseScreen stdout

        try:
          let content = readFile fpath
          discard doOperations content

          echo "---------------------------"

        except ValueError, AssertionDefect:
          let msg = getCurrentExceptionMsg()
          let cuti = msg.find ')'
          echo "[ERROR]: ", msg.substr cuti+1

        lastTime = mtime
        firstTime = false
        

  else:
    echo "\n\tUSAGE: app path/to/operations.txt\n"

main()
