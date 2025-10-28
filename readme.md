# Elementary Row Operation Tester for Matrix

originally created for inspecting the mistakes in Linear Algebra course done by students.

it is inspired by [Jello](https://www.youtube.com/watch?v=tNaZykHHHWs) and Jupyter notebook.


## Usage

open a file like `ops.txt` and then run the app by `app ops.txt`, here's the example content for `ops.txt`:

```
3 7 5 6
1 3 3 -2
0 1 4 -4

r2 += -3r3
r1 += 3r2
r1 <> r2
r2 += -7/4r3
r3 <> r2

?
```

the app watches for changes in the `ops.txt` and reruns when new modification detected

## Operations
- `r1 += -3/2r1`: assigns row 1 as `r1 + -(3/2).r2` here `3/2` is rational i.e. $\frac{3}{2}$
- `r1 *= 3`: scales row 1 by 3
- `r1 <> r2`: swapes row 1 and row 2
- `?`: prints matrix so far
- `1 2 ...`: add the row `1 2 ...` to the matrix


## Features
- [x] support rational numbers

## Limitations
- [ ] cannot use floating point numbers, it must be represented in rational form.
