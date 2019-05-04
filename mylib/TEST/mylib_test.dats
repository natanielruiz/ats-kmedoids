(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

#include "./../mylib.hats"

(* ****** ****** *)

implement main0() = ()

(* ****** ****** *)
//
fun
fact(n: int): int =
(
myint_foldl<int>(myint(n))
) where
{
implement
myint_foldl$nil<int>() = 1
implement
myint_foldl$cons<int>(r, x) = (x+1) * r
}
//
val () =
println!
("fact(10) = ", fact(10))
//
(* ****** ****** *)
//
fun
fact(n: int): int =
(
myint_foldr<int>(myint(n))
) where
{
implement
myint_foldr$nil<int>() = 1
implement
myint_foldr$cons<int>(x, r) = (x+1) * r
}
//
val () =
println!
("fact(10) = ", fact(10))
//
(* ****** ****** *)

val xs =
cons(1, 2 :: 3 :: nil())

val () =
(
foreach<int>(xs)
) where
{
implement
mylist_foreach$work<int>
  (x0) = println!(x0)
}

val () =
assertloc
(6 = length<int>(append<int>(xs, xs)))

(* ****** ****** *)

val-
true =
(
forall<int>(xs)
) where
{
implement
mylist_forall$test<int>(x0) = (x0 > 0)
}

val-
false =
(
exists<int>(xs)
) where
{
implement
mylist_exists$test<int>(x0) = (x0 > 3)
}

(* ****** ****** *)

fun
{a:t@ype}
permute
(
xs: mylist(a)
) : mylist(mylist(a)) =
(
case+ xs of
| nil() => sing(nil())
| cons _ =>
  (
    mylist_concat<xs>
    (
      mylist_map<xxs><xss>
      (mylist_choose1_rest<a>(xs))
    )
  ) where
  {
    typedef xs = mylist(a)
    typedef xxs = @(a, mylist(a))
    typedef xss = mylist(mylist(a))
    implement
    mylist_map$fopr<xxs><xss>(xxs) =
    mylist_mcons(xxs.0, permute<a>(xxs.1))
  }
)

(* ****** ****** *)
//
val
xss = permute<int>(xs)
//
val ((*void*)) =
(
println!("xss =\n", xss)
) where
{
implement
mylist_fprint$sep<>
(out) = fprint_newline(out)
implement
fprint_val<mylist(int)>
(out, xs) =
(
mylist_fprint<int>(out, xs)
) where
{
implement
mylist_fprint$sep<>
(out) = fprint_string(out, ",")
}
}
//
val ((*void*)) = println!("|xss| = ", length(xss))
//
(* ****** ****** *)

val xs1 =
  cons(1, nil())
val xs2 =
  cons(2, nil())
val xs3 =
  cons(3, nil())
val xss =
  cons
  ( xs1
  , cons
    ( xs2
    , cons(xs3, nil())
    )
  )
val yss =
(
mylist_map<xs><ys>
  (xss)
) where
{
typedef x0 = int
typedef xs = mylist(x0)
typedef y0 = string
typedef ys = mylist(y0)
implement
mylist_map$fopr<xs><ys>
  (xs) =
(
  mylist_map<x0><y0>(xs)
) where
{
implement
mylist_map$fopr<x0><y0>(x) =
strptr2string(g0int2string(x*x))
}
} (* end of [val yss] *)

val ( ) =
(
  println!("yss = ", yss)
) where
{
implement
fprint_val<string>
  (out, y) = fprint!(out, "\"", y, "\"")
} (* end of [val ( )] *)

(* ****** ****** *)

val ( ) =
let
//
  val () = mysrand<>()
//
in
  println!("myrand() = ", myrand<>());
  println!("mydrand() = ", mydrand<>())
end // end of [val]

(* ****** ****** *)

(* end of [mylib_test.dats] *)
