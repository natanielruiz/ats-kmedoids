#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

#include "./../mylib/mylib.hats"
#staload "clustering.dats"

%{^
#include <math.h>
%}


// Implement the euclidean distance (L2)
implement
distance<double>(p1, p2) = 
    distance_aux(p1, p2, 0.0)
    where 
    {
        fun
        distance_aux(p1: point(double), p2: point(double), res: double) = 
            case+ p1 of
            | nil() => $extfcall(double, "sqrt", res)
            | cons(p1s, p1) =>
                case+ p2 of
                | nil() => res
                | cons(p2s, p2) => 
                let
                    val d = (p1s - p2s) * (p1s - p2s)
                in
                    distance_aux(p1, p2, res + d)
                end
    }

// Implement the L2 version of k-medoids
extern
fun
KMedoidsTrainL2
  (p: pointlst(double), n_clusters: int): (mylist(int), mylist(int), double)

implement
KMedoidsTrainL2(p, n_clusters) =
    KMedoidsTrain<double>(p, n_clusters)

implement main0() =
{
    val p1 = cons(1.0, cons(1.0, nil()))
    val p2 = cons(~1.0, cons(~4.0, nil()))
    val p3 = cons(~1.0, cons(0.0, nil()))
    val p4 = cons(3.0, cons(2.0, nil()))
    val p5 = cons(4.0, cons(2.0, nil()))
    val p6 = cons(2.0, cons(2.0, nil()))
    val p7 = cons(~2.0, cons(~2.0, nil()))
    val p8 = cons(~3.0, cons(~2.0, nil()))
    val p = cons(p1, cons(p2, cons(p3, cons(p4, cons(p5, cons(p6, cons(p7, cons(p8, nil()))))))))
    
    val n_clusters = 2
    val (medoids, clusters, cost) = KMedoidsTrainL2(p, n_clusters)
    val () = println!("associated medoids ", clusters)
    val () = println!("medoid indices ", medoids)
    val () = println!("final cost ", cost)
}

