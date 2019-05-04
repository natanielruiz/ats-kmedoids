(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

#include "./../mylib.hats"

(* ****** ****** *)

#define N 8

(* ****** ****** *)

typedef board = mylist(int)

(* ****** ****** *)

(*
fun
board_fprint
(out: FILEref, xs: board): void =
(
case+ xs of
| nil() => ()
| cons(x0, xs) =>
  (
  board_fprint(out, xs);
  (
    foreach(myint(N))
  ) where
  {
  implement
  myint_foreach$work<>(i0) =
  if
  (i0 = x0)
  then fprint(out, "Q ") else fprint(out, ". ")
  } ; fprint_newline(out)
  )
) (* end of [board_fprint] *)
*)

fun
board_fprint
(out: FILEref, xs: board): void =
(
  rforeach(xs)
) where
{
implement
mylist_rforeach$work<int>(x) =
(
  foreach(myint(N)); fprint_newline(out)
) where
{
implement
myint_foreach$work<>(i) =
  if i != x then fprint(out, ". ") else fprint(out, "Q ")
}
}

(* ****** ****** *)
//
fun
board_cons_test
(x0: int, xs: board): bool =
(
iforall(xs)
) where
{
  implement
  mylist_iforall$test<int>
    (i, x) = (x0 != x && abs(x0-x) != i+1)
}
//
(* ****** ****** *)

fun
board_extend_all
( xs
: board )
: mylist(board) =
(
myint_mapopt<board>(myint(N))
) where
{
  implement
  myint_mapopt$fopr<board>(x0) =
  if board_cons_test(x0, xs) then some(cons(x0, xs)) else none()
} (* end of [board_extend_all] *)

(* ****** ****** *)

fun
qsolve
(
) : mylist(board) =
(
  helper(0)
) where
{
fun
helper
(i: int): mylist(board) =
  if
  (i < N)
  then let
    val xss = helper(i+1)
  in
    mylist_concat<board>
    (
      mylist_map<board><mylist(board)>(xss)
    ) where
    {
      implement
      mylist_map$fopr<board><mylist(board)>(xs) = board_extend_all(xs)
    }
  end else sing(nil())
} (* end of [qsolve] *)

(* ****** ****** *)

implement
main0() = () where
{
//
(*
val () =
println!
("\
QueenPuzzle: \
not yet ready for testing!\
")(*println!*)
*)
//
val
xss = qsolve()
//
val ((*void*)) =
(
  iforeach(xss)
) where
{
implement
mylist_iforeach$work<board>
  (i, board) =
(
  if i > 0 then
    fprintln!(stdout_ref);
  // end of [if]
  fprintln!
  ( stdout_ref
  , "Solution#", i+1, ": ");
  board_fprint(stdout, board)
)
}
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [QueenPuzzle.dats] *)
