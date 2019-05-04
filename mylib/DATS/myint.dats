(* ****** ****** *)

#staload "./../mylib.sats"

(* ****** ****** *)

#staload "./../SATS/myint.sats"
#staload "./../SATS/mylist.sats"

(* ****** ****** *)

local

assume
myint_t0ype = int

in // in-of-local

(*
implement
myint_encode(x0) = x0
implement
myint_decode(x0) = x0
*)

end // end of [local]

(* ****** ****** *)

implement
{}//tmp
myint_forall
 (xs) =
(
loop(0)
) where
{
//
val xs = decode(xs)
//
fun
loop(x0: int): bool =
(
if
(x0 < xs)
then
(
if 
myint_forall$test<>(x0)
then loop(x0+1) else false
) else true // end of [if]
)
} (* end of [myint_forall] *)

implement
{}//tmp
myint_exists
(xs) =
(
not(myint_forall<>(xs))
) where
{
implement
myint_forall$test<>(x) =
not(myint_exists$test<>(x))
}

(* ****** ****** *)

implement
{}//tmp
myint_foreach
(xs) =
(
ignoret
(myint_forall<>(xs))
) where
{
implement
myint_forall$test<>(x0) =
let
val () = myint_foreach$work<>(x0) in true
end
} (* end of [myint_foreach] *)

(* ****** ****** *)
//
implement
{r}//tmp
myint_foldl
  (xs) =
(
  loop(0, myint_foldl$nil<r>())
) where
{
//
val xs = decode(xs)
//
fun
loop
(x0: int, r0: r): r =
(
if
(x0 < xs)
then
loop(x0+1, myint_foldl$cons<r>(r0, x0))
else r0 // end of [else]
)
} (* end of [myint_foldl] *)
//
(* ****** ****** *)
//
implement
{r}//tmp
myint_foldr
  (xs) =
(
  loop(xs, myint_foldr$nil<r>())
) where
{
//
val xs = decode(xs)
//
fun
loop
(x0: int, r0: r): r =
(
if
(x0 > 0)
then
loop(x0-1, myint_foldr$cons<r>(x0-1, r0))
else r0 // end of [else]
)
} (* end of [myint_foldr] *)
//
(* ****** ****** *)
//
implement
{b}//tmp
myint_map(xs) =
(
mylist_reverse<b>
(
  myint_foldl<mylist(b)>(xs)
)
) where
{
//
implement
myint_foldl$nil<mylist(b)>
  () = nil()
implement
myint_foldl$cons<mylist(b)>
  (r, x) =
  cons(myint_map$fopr<b>(x), r)
//
} (* where *) // end of [myint_map]
//
(* ****** ****** *)
//
implement
{b}//tmp
myint_mapopt(xs) =
(
mylist_reverse<b>
(
  myint_foldl<mylist(b)>(xs)
)
) where
{
//
implement
myint_foldl$nil<mylist(b)>
  () = nil()
implement
myint_foldl$cons<mylist(b)>
  (r, x) = let
  val opt =
  myint_mapopt$fopr<b>(x)
in
  case+ opt of
  | myopt_none() => r
  | myopt_some(x) => cons(x, r)
end // end of [myint_foldl$cons]
//
} (* where *) // end of [myint_map]
//
(* ****** ****** *)

(* end of [myint.dats] *)
