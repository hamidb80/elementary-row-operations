import std/[strutils]
import ../core

import karax / [karax, karaxdsl]
include karax / prelude

# -------------------------------------------

var printed: seq[kstring] = @[]
var errormsg: string


proc doOperations(fcontent: string): Matrix =
  printed = @[]

  for l in fcontent.splitLines:
    if not isEmptyOrWhitespace l:
      let op = parseOperation l
      case op.kind
      of okPrint:
        printed.add result.toHumanReadable
      else:
        result = result.applyOperation op


proc createDom(): VNode =
  result =
    buildHtml tdiv:

      span:
        text "write something ..."

      textarea:
        proc oninput(ev: Event; n: VNode) =
          let k = n.value
          try:
            discard doOperations ($k)
            errormsg = ""
          except:
            errormsg =  getCurrentExceptionMsg()

        text """1 2 3
4 5 6
7 8 9
10 11 12

t
?

r1 <> r3
?
"""

      if errormsg.len != 0:
        pre:
          text errormsg

      pre:
        for x in printed:
          text x

      

setRenderer createDom