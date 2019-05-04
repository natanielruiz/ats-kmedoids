(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

#staload "libats/libc/SATS/math.sats"
#staload _ = "libats/libc/DATS/math.dats"

(* ****** ****** *)
//
#include "./../mylib.hats"
//
#staload GS = "./../DATS/mygseq.dats"
//
(* ****** ****** *)

fun
isPrime
(k : intGte(2)) : bool =
(
$GS.forall<myint><int>
  (myint(intsqrt(k)-1))
) where
{
  implement
  $GS.forall$test<int>(i) = k % (i+2) > 0
} (* end of [isPrime] *)

(* ****** ****** *)

implement main0() =
{
//
#define _1M_ 1000000
//
  val np = 
  myint_foldl<int>
  (myint(_1M_ - 2)) where
  {
   implement
   myint_foldl$nil<int>() = 0
   implement
   myint_foldl$cons<int>(res, x) =
   if isPrime($UNSAFE.cast{intGte(2)}(x+2)) then res+1 else res
  }
  val () = println! ("The number of primes < ", _1M_, " = ", np)
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [isPrime.dats] *)
