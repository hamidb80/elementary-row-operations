# Elementary Row Operation Tester for Matrix

originally created for inspecting the mistakes in Linear Algebra course done by students.


## Usage

open a file like `ops.txt` and then run the app by `app ops.txt`, here's the example content for `ops.txt`:

```
3 7 5 6
1 3 3 -2
0 1 4 -4

r2 += -3r3
r1 += -3r2
r1 <> r2
r2 += -7r3
r3 <> r2

?
```

## Operations
- `r1 += -3r1`: r1 <-- r1 -3.r2
- `r1 *= 3`: r1 <-- 3.r1
- `r1 <> r2`: swapes row 1 and row 2
- `?`: prints matrix so far
- `1 2 ...`: add the row `1 2 ...` to the matrix
