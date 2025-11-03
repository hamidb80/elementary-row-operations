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

      h2:
        text "Elementary Matrix Operations"

      h3:
        text "Help"

      ul:
        li:
          code:
            text "r1 += -3/2r1"
          span:
            text ": assigns row 1 as `r1 + -(3/2).r2` here `3/2` is rational"

        li:
          code:
            text "r1 *= 3"
          span:
            text ": scales row 1 by 3"

        li:
          code:
            text "r1 <> r2"
          span:
            text ": swapes row 1 and row 2"

        li:
          code:
            text "?"
          span:
            text ": prints the matrix so far"

        li:
          code:
            text "t"
          span:
            text ": transposes the matrix"

        li:
          code:
            text "mx"
          span:
            text ": mirror to the y axis"

        li:
          code:
            text "my"
          span:
            text ": mirror to the x axis"

        li:
          code:
            text "1 2 ..."
          span:
            text ": add the row `1 2 ...` to the matrix"

      hr()

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