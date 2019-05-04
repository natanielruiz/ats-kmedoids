(* ****** ****** *)

#staload "./../mylib.sats"

(* ****** ****** *)

fun
{a:t@ype}
mylist_length
(xs: mylist(a)): int

overload
length with mylist_length

fun
{a:t@ype}
mylist_reverse
(xs: mylist(a)): mylist(a)

overload
reverse with mylist_reverse

(* ****** ****** *)

fun
{a:t@ype}
mylist_get_at_exn
(xs: mylist(a), n: int): a

(* ****** ****** *)

fun
{a:t@ype}
mylist_append
( xs: mylist(a)
, ys: mylist(a)): mylist(a)

fun
{a:t@ype}
mylist_revapp
( xs: mylist(a)
, ys: mylist(a)): mylist(a)

fun
{a:t@ype}
mylist_concat
(xss: mylist(mylist(a))): mylist(a)
//
overload append with mylist_append
overload concat with mylist_concat
//
(* ****** ****** *)

fun
{a:t@ype}
mylist_forall
(xs: mylist(a)): bool
fun
{a:t@ype}
mylist_forall$test(x0: a): bool

overload forall with mylist_forall

fun
{a:t@ype}
mylist_exists
(xs: mylist(a)): bool
fun
{a:t@ype}
mylist_exists$test(x0: a): bool

overload exists with mylist_exists

(* ****** ****** *)

fun
{a:t@ype}
mylist_foreach
(xs: mylist(a)): void
fun
{a:t@ype}
mylist_foreach$work(x0: a): void

overload foreach with mylist_foreach

(* ****** ****** *)

fun
{a:t@ype}
mylist_rforall
(xs: mylist(a)): bool
fun
{a:t@ype}
mylist_rforall$test(x0: a): bool

overload rforall with mylist_rforall

(* ****** ****** *)

fun
{a:t@ype}
mylist_rforeach
(xs: mylist(a)): void
fun
{a:t@ype}
mylist_rforeach$work(x0: a): void

overload rforeach with mylist_rforeach

(* ****** ****** *)

fun
{a:t@ype}
{r:t@ype}
mylist_foldl
(xs: mylist(a)): r

fun
{a:t@ype}
{r:t@ype}
mylist_foldl$nil(): r
fun
{a:t@ype}
{r:t@ype}
mylist_foldl$cons(r, a): r

(* ****** ****** *)

fun
{a:t@ype}
{r:t@ype}
mylist_foldr
(xs: mylist(a)): r

fun
{a:t@ype}
{r:t@ype}
mylist_foldr$nil(): r
fun
{a:t@ype}
{r:t@ype}
mylist_foldr$cons(a, r): r

(* ****** ****** *)
//
fun
{a:t@ype}
{b:t@ype}
mylist_map
(xs: mylist(a)): mylist(b)
fun
{a:t@ype}
{b:t@ype}
mylist_map$fopr(x0: a): (b)
//
(* ****** ****** *)
//
fun
{a:t@ype}
{b:t@ype}
mylist_mapopt
(xs: mylist(a)): mylist(b)
fun
{a:t@ype}
{b:t@ype}
mylist_mapopt$fopr(x0: a): Option_vt(b)
//
(* ****** ****** *)
//
fun
{a:t@ype}
mylist_mcons
(a, mylist(mylist(a))): mylist(mylist(a))
//
(* ****** ****** *)

fun
{a:t@ype}
mylist_iforall
(xs: mylist(a)): bool
fun
{a:t@ype}
mylist_iforall$test
(i0: int, x0: a): bool

overload iforall with mylist_iforall

(* ****** ****** *)

fun
{a:t@ype}
mylist_iforeach
(xs: mylist(a)): void
fun
{a:t@ype}
mylist_iforeach$work
(i0: int, x0: a): void

overload iforeach with mylist_iforeach

(* ****** ****** *)

fun
{a:t@ype}
{r:t@ype}
mylist_ifoldl
(xs: mylist(a)): r

fun
{a:t@ype}
{r:t@ype}
mylist_ifoldl$nil(): r
fun
{a:t@ype}
{r:t@ype}
mylist_ifoldl$cons(r, int, a): r

(* ****** ****** *)
//
fun
{a:t@ype}
{b:t@ype}
mylist_imap
(xs: mylist(a)): mylist(b)
fun
{a:t@ype}
{b:t@ype}
mylist_imap$fopr(i0: int, x0: a): (b)
//
(* ****** ****** *)
//
fun
{a:t@ype}
mylist_choose1_rest
  (xs: mylist(a)): mylist(@(a, mylist(a)))
//
(* ****** ****** *)
//
fun
{a:t@ype}
mylist_print(mylist(a)): void
fun
{a:t@ype}
mylist_prerr(mylist(a)): void
//
fun
{a:t@ype}
mylist_fprint
(out: FILEref, xs: mylist(a)): void
fun{}
mylist_fprint$sep(out: FILEref): void
//
overload print with mylist_print
overload prerr with mylist_prerr
overload fprint with mylist_fprint
//
(* ****** ****** *)

(* end of [mylist.sats] *)

fun
{a:t@ype}
mylist_replace_at
(xs: mylist(a), n: int, r: a): mylist(a)