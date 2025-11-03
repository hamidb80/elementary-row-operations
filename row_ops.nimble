# Package

version       = "0.5.1"
author        = "hamidb80"
description   = "elementary row operation tester for your matrix. originally created for inspecting the mistakes in Linear Algebra course done by students."
license       = "WTFPL"
srcDir        = "src"
# bin           = @["row_ops"]


# Dependencies

requires "nim >= 2.2.4"
requires "karax"

task win, "windows":
  mkdir "./builds/"
  exec ("nim c -o:./builds/row-ops-x64-v" & version & ".exe ./src/cli.nim")

task web, "web":
  mkdir "./dist/"
  cpfile "./src/web/index.html", "./dist/index.html"
  exec "nim js -o:./dist/script.js ./src/web/script.nim"
