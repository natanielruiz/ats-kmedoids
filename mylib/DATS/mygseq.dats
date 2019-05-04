(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Xanadu - Unleashing the Potential of Types!
** Copyright (C) 2018 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi
// Start Time: February, 2019
// Authoremail: gmhwxiATgmailDOTcom
//
(* ****** ****** *)
//
#staload
UN =
"prelude/SATS/unsafe.sats"
//
(* ****** ****** *)

#staload "./../mylib.sats"

(* ****** ****** *)

#staload "./../SATS/myint.sats"
#staload "./../SATS/mylist.sats"

(* ****** ****** *)
//
sortdef
tbox = type and tflt = t0ype
//
(* ****** ****** *)
//
extern
fun
{xs
:tflt}
{x0
:tflt}
streamize_vt(xs): stream_vt(x0)
//
(* ****** ****** *)
//
extern
fun
{xs:tflt}
{x0:tflt} forall(xs): bool
extern
fun
{x0:tflt} forall$test(x0): bool
//
(* ****** ****** *)
//
extern
fun
{xs:tflt}
{x0:tflt} foreach(xs): void
extern
fun
{x0:tflt} foreach$work(x0): void
//
(* ****** ****** *)
//
extern
fun
{xs:tflt}
{x0:tflt} iforall(xs): bool
extern
fun
{x0:tflt} iforall$test(int, x0): bool
//
(* ****** ****** *)
//
extern
fun
{xs:tflt}
{x0:tflt} iforeach(xs): void
extern
fun
{x0:tflt} iforeach$work(int, x0): void
//
(* ****** ****** *)

local

typedef a = int

in

implement
streamize_vt<myint><a>
  (xs) =
(
  auxint(0)
) where
{
//
  val xs = decode(xs)
//
  fun
  auxint
  (i0: a): stream_vt(a) =
  $ldelay
  (
  if
  (i0 < xs)
  then
  stream_vt_cons
    (i0, auxint(i0+1))
  // then
  else
  stream_vt_nil((*void*))
  )
}

end // end of [local]

(* ****** ****** *)

implement
(a)
streamize_vt<mylist(a)><a>
  (xs) =
(
  auxlst(xs)
) where
{
fun
auxlst
(xs: mylist(a)): stream_vt(a) =
$ldelay
(
case+ xs of
| nil() => stream_vt_nil()
| cons(x0, xs) => stream_vt_cons(x0, auxlst(xs))
)
}

(* ****** ****** *)

implement
{xs}
{x0}
forall(xs) =
(
auxlst(streamize_vt(xs))
) where
{
fun
auxlst
( xs
: stream_vt(x0)): bool =
(
case+ !xs of
| ~stream_vt_nil
   ((*void*)) => true
| ~stream_vt_cons
   ( x0, xs ) =>
  (
   if
   test
   then
   auxlst(xs)
   else
   let val () = ~xs in false end
  ) where
  {
    val test = forall$test<x0>(x0)
  } (* where *)
)
} (* end of [forall] *)

(* ****** ****** *)

implement
{xs}
{x0}
foreach
(xs) =
(
ignoret
(forall<xs><x0>(xs))
) where
{
implement
forall$test<x0>(x0) =
let
val () = foreach$work<x0>(x0) in true
end
} // mygseq_foreach

(* ****** ****** *)
//
implement
{xs}
{x0}
iforall(xs) =
(
  forall<xs><x0>(xs)
) where
{
//
var env: int = 0
val env =
$UN.cast{ref(int)}(addr@(env))
//
implement
forall$test<x0>(x0) =
let
  val i0 = !env
in
  !env := i0+1; iforall$test<x0>(i0, x0)
end // end of [forall$test]
//
}
//
(* ****** ****** *)

implement
{xs}
{x0}
iforeach
(xs) =
(
ignoret
(iforall<xs><x0>(xs))
) where
{
implement
iforall$test<x0>(i0, x0) =
let
val () = iforeach$work<x0>(i0, x0) in true
end
} // mygseq_foreach

(* ****** ****** *)
//
extern
fun
{xs:tflt}
{x0:tflt}
{y0:tflt}
map_list(xs): mylist(y0)
extern
fun
{x0:tflt}
{y0:tflt}
map_list$fopr(x0: x0): (y0)
//
(* ****** ****** *)

implement
{xs}
{x0}
{y0}
map_list(xs) =
(mylist_reverse<y0>
 ($UN.castvwtp0{ys}(!res))
) where
{
//
typedef ys = mylist(y0)
//
var
res: ys = nil()
val
res =
$UN.cast
{ref(ys)}(addr@res)
//
val () =
(
  foreach<xs><x0>(xs)
) where
{
  implement
  foreach$work<x0>(x0) =
  {
    val y0 =
    map_list$fopr<x0><y0>(x0)
    val () = (!res := cons(y0, !res))
  }
}
//
} (* end of [map_list] *)

(* ****** ****** *)

extern
fun
{xs:tflt}
{x0:tflt}
{y0:tflt}
imap_list(xs): mylist(y0)
extern
fun
{x0:tflt}
{y0:tflt}
imap_list$fopr(int, x0): (y0)

implement
{xs}
{x0}
{y0}
imap_list(xs) =
let
//
var env
  : int = 0
val env =
$UN.cast
{ref(int)}(addr@(env))
//
in
(
map_list<xs><x0><y0>(xs)
) where
{
  implement
  map_list$fopr<x0><y0>(x0) =
  let
    val i0 = !env
  in
    !env := i0 + 1;
    imap_list$fopr<x0><y0>(i0, x0)
  end // end of [map_list$fopr]
}
end // end of [imap_list]

(* ****** ****** *)

(* end of [mygseq.dats] *)
