(* ****** ****** *)

#staload "./../mylib.sats"

(* ****** ****** *)

#staload "./../SATS/myint.sats"
#staload "./../SATS/mylist.sats"

(* ****** ****** *)

implement
{a}
mylist_length(xs) =
(
  loop(xs, 0)
) where
{
fun
loop
(xs: mylist(a), r0: int): int =
(
case+ xs of
| nil() => r0
| cons(_, xs) => loop(xs, r0 + 1)
)
} // mylist_length

(* ****** ****** *)

implement
{a}//tmp
mylist_get_at_exn
  (xs, n) =
(
  auxlst(xs, 0(*beg*))
) where
{
//
fun
auxlst
( xs
: mylist(a)
, i0: int): (a) =
(
case+ xs of
| nil() =>
  $raise ListSubscriptExn()
| cons(x0, xs) =>
  if i0 < n then auxlst(xs, i0+1) else x0
)
//
} (* end of [mylist_get_at_exn] *)

(* ****** ****** *)

implement
{a}
mylist_append
(xs, ys) =
(
auxlst(xs)
) where
{
fun
auxlst
(xs: mylist(a)): mylist(a) =
(
case+ xs of
| nil() => ys
| cons(x0, xs) => cons(x0, auxlst(xs))
)
} // mylist_append

(* ****** ****** *)

implement
{a}
mylist_revapp
(xs, ys) =
(
auxlst(xs, ys)
) where
{
fun
auxlst
( xs: mylist(a)
, ys: mylist(a)): mylist(a) =
(
case+ xs of
| nil() => ys
| cons(x0, xs) => auxlst(xs, cons(x0, ys))
)
} // mylist_revapp

(* ****** ****** *)

(*
implement
{a}
mylist_concat
(xss) =
(
  auxlst(xss)
) where
{
fun
auxlst
( xss
: mylist(mylist(a))): mylist(a) =
(
case+ xss of
| nil() => nil()
| cons(xs0, xss) =>
  mylist_append<a>(xs0, auxlst(xss))
)
} (* end of [mylist_concat] *)
*)

implement
{a}
mylist_concat
(xss) =
(
  reverse(auxlst(xss, nil()))
) where
{
fun
auxlst
( xss
: mylist(mylist(a))
, res: mylist(a)): mylist(a) =
(
case+ xss of
| nil() => res
| cons(xs0, xss) =>
  auxlst(xss, mylist_revapp<a>(xs0, res))
)
} (* end of [mylist_concat] *)

(* ****** ****** *)

implement
{a}
mylist_forall
 (xs) =
(
loop(xs)
) where
{
fun
loop(xs: mylist(a)): bool =
(
case+ xs of
| nil() => true
| cons(x0, xs) =>
  if 
  mylist_forall$test<a>(x0)
  then loop(xs) else false
)
} // end of [mylist_forall]

implement
{a}
mylist_exists
(xs) =
(
not(mylist_forall<a>(xs))
) where
{
implement
mylist_forall$test<a>(x) =
not(mylist_exists$test<a>(x))
} // end of [mylist_exists]

(* ****** ****** *)

implement
{a}
mylist_foreach
(xs) =
(
ignoret
(mylist_forall<a>(xs))
) where
{
implement
mylist_forall$test<a>(x0) =
let
val () = mylist_foreach$work<a>(x0) in true
end
} // mylist_foreach

(* ****** ****** *)

implement
{a}
mylist_rforall
 (xs) =
(
auxlst(xs)
) where
{
fun
auxlst
(xs: mylist(a)): bool =
(
case+ xs of
| nil() => true
| cons(x0, xs) =>
  if
  auxlst(xs)
  then
  mylist_rforall$test<a>(x0) else false
)
} // end of [mylist_rforall]

(* ****** ****** *)

implement
{a}
mylist_rforeach
(xs) =
(
ignoret
(mylist_rforall<a>(xs))
) where
{
implement
mylist_rforall$test<a>(x0) =
let
val () = mylist_rforeach$work<a>(x0) in true
end
} // mylist_rforeach

(* ****** ****** *)

(*
implement
{a}
mylist_length(xs) =
(
  mylist_foldl<a><int>(xs)
) where
{
implement
mylist_foldl$nil<a><int>() = 0
implement
mylist_foldl$cons<a><int>(r, x) = r + 1
}
*)

(* ****** ****** *)

implement
{a}{r}
mylist_foldl
  (xs) =
(
  loop(xs, mylist_foldl$nil<a><r>())
) where
{
fun
loop
(xs: mylist(a), r0: r): r =
(
case+ xs of
| nil() => r0
| cons(x0, xs) =>
  loop(xs, mylist_foldl$cons<a><r>(r0, x0))
)
}

(* ****** ****** *)

implement
{a}{r}
mylist_foldr
  (xs) =
(
  auxlst(xs, mylist_foldr$nil<a><r>())
) where
{
fun
auxlst
(xs: mylist(a), r0: r): r =
(
case+ xs of
| nil() => r0
| cons(x0, xs) =>
  mylist_foldr$cons<a><r>(x0, auxlst(xs, r0))
)
}

(* ****** ****** *)

implement
{a}
mylist_reverse(xs) =
(
  mylist_foldl<a><r>(xs)
) where
{
//
typedef r = mylist(a)
//
implement
mylist_foldl$nil<a><r>() = nil()
implement
mylist_foldl$cons<a><r>(r, x) = cons(x, r)
}

(* ****** ****** *)
//
implement
{a}{b}
mylist_map(xs) =
(
mylist_reverse<b>
(
  mylist_foldl<a><mylist(b)>(xs)
)
) where
{
//
implement
mylist_foldl$nil<a><mylist(b)>
  () = nil()
implement
mylist_foldl$cons<a><mylist(b)>
  (r, x) =
  cons(mylist_map$fopr<a><b>(x), r)
//
} (* where *) // end of [mylist_map]
//
(* ****** ****** *)
//
implement
{a}
mylist_mcons(x0, xss) =
(
mylist_map<mylist(a)><mylist(a)>(xss)
) where
{
implement
mylist_map$fopr<mylist(a)><mylist(a)>(xs) = cons(x0, xs)
}
//
(* ****** ****** *)
//
implement
{a}{b}
mylist_mapopt(xs) =
(
mylist_reverse<b>
(
  mylist_foldl<a><mylist(b)>(xs)
)
) where
{
//
implement
mylist_foldl$nil<a><mylist(b)>
  () = nil()
implement
mylist_foldl$cons<a><mylist(b)>
  (r, x) = let
  val opt =
  mylist_mapopt$fopr<a><b>(x)
in
  case+ opt of
  | ~None_vt() => r
  | ~Some_vt(x) => cons(x, r)
end // end of [mylist_foldl$cons]
//
} (* where *) // end of [mylist_map]
//
(* ****** ****** *)

implement
{a}
mylist_iforall
 (xs) =
(
loop(0, xs)
) where
{
fun
loop
( i0: int
, xs: mylist(a)): bool =
(
case+ xs of
| nil() => true
| cons(x0, xs) =>
  if 
  mylist_iforall$test<a>(i0, x0)
  then loop(i0+1, xs) else false
)
}

(* ****** ****** *)

implement
{a}
mylist_iforeach
(xs) =
(
ignoret
(mylist_iforall<a>(xs))
) where
{
implement
mylist_iforall$test<a>(i0, x0) =
let
val () = mylist_iforeach$work<a>(i0, x0) in true
end
}

(* ****** ****** *)

implement
{a}{r}
mylist_ifoldl
  (xs) =
(
  loop(0, xs, mylist_ifoldl$nil<a><r>())
) where
{
fun
loop
(i0: int, xs: mylist(a), r0: r): r =
(
case+ xs of
| nil() => r0
| cons(x0, xs) =>
  loop(i0+1, xs, mylist_ifoldl$cons<a><r>(r0, i0, x0))
)
} // mylist_ifoldl

(* ****** ****** *)
//
implement
{a}{b}
mylist_imap(xs) =
(
mylist_reverse<b>
(
  mylist_ifoldl<a><mylist(b)>(xs)
)
) where
{
//
implement
mylist_ifoldl$nil<a><mylist(b)>
  () = nil()
implement
mylist_ifoldl$cons<a><mylist(b)>
  (r, i, x) =
  cons(mylist_imap$fopr<a><b>(i, x), r)
//
} (* where *) // end of [mylist_imap]
//
(* ****** ****** *)

implement
{a}
mylist_choose1_rest
  (xs) = 
(
  auxlst(xs)
) where
{
//
typedef
xxs = @(a, mylist(a))
//
fun
auxlst
(
xs: mylist(a)
) : mylist(xxs)  =
(
case+ xs of
| nil() => nil()
| cons(x0, xs) =>
  (
    cons
    ( (x0, xs)
    , mylist_map<xxs><xxs>(auxlst(xs))
    )
  ) where
  {
    implement
    mylist_map$fopr<xxs><xxs>(xxs) = (xxs.0, cons(x0, xxs.1))
  } (* end of [cons] *)
)
} (* end of [mylist_choose1_rest] *)

(* ****** ****** *)

implement
{}
mylist_fprint$sep
(out) =
fprint_string(out, ", ")

(* ****** ****** *)

implement
{a}
mylist_print(xs) =
mylist_fprint(stdout_ref, xs)
implement
{a}
mylist_prerr(xs) =
mylist_fprint(stderr_ref, xs)
implement
{a}
mylist_fprint(out, xs) =
(
mylist_iforeach<a>(xs)
) where
{
implement
mylist_iforeach$work<a>
(i0, x0) =
(
if
i0 > 0
then
mylist_fprint$sep<>(out)
; fprint_val<a>(out, x0)
) (* end of [work] *)
} (* end of [mylist_fprint] *)

(* ****** ****** *)

implement
(a)//tmp
fprint_val<mylist(a)> = mylist_fprint<a>

(* ****** ****** *)

(* end of [mylist.dats] *)


implement
{a}//tmp
mylist_replace_at
  (xs, n (*index*), r (*replace*)) =
(
  auxlst(xs, nil(), r, 0(*beg*))
) where
{
//
fun
{a:t@ype}
auxlst
( xs: mylist(a), res: mylist(a), r: a, i0: int): mylist(a) =
(
case+ xs of
| nil() => $raise ListSubscriptExn()
| cons(x0, xs) =>
  if i0 < n then 
    auxlst(xs, cons(x0, res), r, i0+1)
  else
    mylist_append(reverse(cons(r,res)), xs)
)
//
} 