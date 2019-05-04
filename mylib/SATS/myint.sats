(* ****** ****** *)

#staload "./../mylib.sats"

(* ****** ****** *)

fun{}
myint_forall
(xs: myint): bool
fun{}
myint_forall$test(x0: int): bool
fun{}
myint_exists
(xs: myint): bool
fun{}
myint_exists$test(x0: int): bool

overload forall with myint_forall
overload exists with myint_exists

(* ****** ****** *)

fun{}
myint_foreach
(xs: myint): void
fun{}
myint_foreach$work(x0: int): void

overload foreach with myint_foreach

(* ****** ****** *)

fun
{r:t@ype}
myint_foldl
(xs: myint): r

fun
{r:t@ype}
myint_foldl$nil(): r
fun
{r:t@ype}
myint_foldl$cons(r, int): r

fun
{r:t@ype}
myint_foldr
(xs: myint): r

fun
{r:t@ype}
myint_foldr$nil(): r
fun
{r:t@ype}
myint_foldr$cons(int, r): r

(* ****** ****** *)
//
fun
{b:t@ype}
myint_map
(xs: myint): mylist(b)
fun
{b:t@ype}
myint_map$fopr(x0: int): (b)
//
(* ****** ****** *)
//
fun
{b:t@ype}
myint_mapopt
(xs: myint): mylist(b)
fun
{b:t@ype}
myint_mapopt$fopr(x0: int): myopt(b)
//
(* ****** ****** *)

(* end of [mynt.sats] *)
