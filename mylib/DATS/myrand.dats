(* ****** ****** *)

%{#
#include <time.h>
#include <stdlib.h>
%} // end '%{^'

(* ****** ****** *)

extern
fun{}
mysrand(): void
extern
fun{}
mysrand$seed(): uint

(* ****** ****** *)

extern
fun{}
myrand(): int
extern
fun{}
mydrand(): double

(* ****** ****** *)

implement
{}(*tmp*)
mysrand() =
(
$extfcall(void, "srand", seed)
) where
{
  val seed = mysrand$seed<>()
}

implement
{}(*tmp*)
mysrand$seed() =
$extfcall(uint, "time", the_null_ptr)

(* ****** ****** *)

implement
{}//tmp
myrand() = $extfcall(int, "rand")
implement
{}//tmp
mydrand() =
1.0 * myrand<>() / $extval(int, "RAND_MAX")

(* ****** ****** *)

(* end of [myrand.dats] *)
