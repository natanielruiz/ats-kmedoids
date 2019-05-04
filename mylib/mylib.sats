(* ****** ****** *)

macdef
stderr = stderr_ref
macdef
stdout = stdout_ref

(* ****** ****** *)

abst@ype
myint_t0ype = int

(* ****** ****** *)

typedef
myint = myint_t0ype

(* ****** ****** *)
//
castfn
myint_encode
(x0: int): myint
castfn
myint_decode
(x0: myint): int
//
overload
myint with myint_encode
overload
decode with myint_decode
//
(* ****** ****** *)

datatype
myopt(a:t@ype) =
| myopt_none of ()
| myopt_some of (a)

(* ****** ****** *)

#define none myopt_none
#define some myopt_some

(* ****** ****** *)

datatype
mylist(a:t@ype) =
| mylist_nil of ()
| mylist_cons of (a, mylist(a))

(* ****** ****** *)

#define :: mylist_cons
#define nil mylist_nil
#define cons mylist_cons

#define sing(x) cons(x, nil())

(* ****** ****** *)

(* end of [mylib.sats] *)
