#import "../../lib.typ": *

First of all, remember that:
// Without using the 'smash' function.
// $
// dif overbrace(y, "dependent variable")
// $

$
  (dif overbrace(y, smash("dependent variable"))) /
  (dif underbrace(x, smash("independent variable"))) = 5 x y
$

Solve the following exercise:
$
  (1 + t^2) (dif y)/(dif t) + 4 t y = t;
  space.quad space.quad
  y(1) = 1/4
$

