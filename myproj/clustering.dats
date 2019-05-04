(* ****** ****** *)
// Work of Nataniel Ruiz
(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

#include "./../mylib/mylib.hats"

// Sketch of algorithm //

// k-medoids clustering
// with different distance metrics
// using templates

// k_medoids_train
// 1. Initialize k medoids from n points
// 2. Associate each point to closest medoid
// 3. While cost function decreases
//      - For each medoid m and each non-medoid data point o
//          1. Swap m and o, associate each data point to the closest medoid, recompute the cost
//          2. If the total cost of the configuration increased in the previous step, undo the swap
// INPUT: 
// points: list of list of type a
// n_clusters: int
// OUTPUT:
// medoids, clusters, cost
//

// Data types //
typedef
point(a:t@ype) = mylist(a)

typedef
pointlst(a:t@ype) = mylist(point(a))

// TEMPLATES //
// k-medoids template
// output: medoids, clusters, cost
extern
fun
{a:t@ype}
KMedoidsTrain
  (p: pointlst(a), n_clusters: int): (mylist(int), mylist(int), double)

// k-medoids iteration
extern
fun
{a:t@ype}
KMedoidsTrainIter
(p: pointlst(a), n_clusters: int, medoids: mylist(int), clusters: mylist(int), old_cost: double, i: int, j: int, step: int, max_steps: int): (mylist(int), mylist(int), double)

// Initialize the medoids to the first points in the point list
extern
fun
{a:t@ype}
init_medoids
(p: pointlst(a), n_clusters: int): mylist(int)

// Associate points p to appropriate medoids
extern
fun
{a:t@ype}
associate_points
(p: pointlst(a), n_clusters: int, medoids: mylist(int)): mylist(int)

// Find the medoid for point p1
extern
fun
{a:t@ype}
find_medoid
(p1: point(a), p_medoids: pointlst(a), old_medoid: int, index: int, min_d: double): int

// Gives pointlst(a) of medoids
extern
fun
{a:t@ype}
lookup_medoids
(p: pointlst(a), medoids: mylist(int)): pointlst(a)

// Swap i-th medoid with j-th point
extern
fun
{a:t@ype}
swap
(medoids: mylist(int), i: int, j: int): mylist(int)

// Compute cost of clustering instance
extern
fun
{a:t@ype}
costf
(p: pointlst(a), medoids: mylist(int), clusters: mylist(int)): double

// Distance function: this one is implemented individually for your problem
extern
fun
{a:t@ype}
distance
(p1: point(a), p2: point(a)): double

// IMPLEMENTATIONS //
implement
{a}
KMedoidsTrain
(p, n_clusters) = 
let
    val medoids = init_medoids(p, n_clusters)
    val clusters = associate_points(p, n_clusters, medoids)
    val cost = costf(p, medoids, clusters)
in
    KMedoidsTrainIter(p, n_clusters, medoids, clusters, cost, 0, 0, 0, 100)
end

extern
fun
{}
next_iter(i: int, j: int, step: int, n_points: int, n_clusters: int): (int, int, int)

implement
{}
next_iter(i, j, step, n_points, n_clusters) = 
    if i + 1 < n_points then (i+1, j, step)
    else if j + 1 < n_clusters then (0, j+1, step)
    else (0, 0, step+1)

implement
{a}
KMedoidsTrainIter
(p, n_clusters, medoids, clusters, old_cost, i, j, step, max_steps) = 
if (step < max_steps) then
    let
        val new_medoids = swap(medoids, j, i)
        val new_clusters = associate_points(p, n_clusters, new_medoids)
        val cost = costf(p, new_medoids, new_clusters)
        val n_points = mylist_length(p)
        val ni = next_iter(i, j, step, n_points, n_clusters)
    in
        if cost < old_cost then
            KMedoidsTrainIter(p, n_clusters, new_medoids, new_clusters, cost, ni.0, ni.1, ni.2, max_steps)
        else
            KMedoidsTrainIter(p, n_clusters, medoids, clusters, old_cost, ni.0, ni.1, ni.2, max_steps)
    end
else
    (medoids, clusters, old_cost)

implement
{a}
init_medoids
(p, n_clusters) = 
    if n_clusters > mylist_length(p) then 
        $raise ListSubscriptExn()
    else
        n_first(n_clusters)
        where
        {
            // Enumerates n first ints
            fun
            n_first(n: int): mylist(int) = 
                if n > 0 then
                    cons(n-1, n_first(n-1))
                else nil()
        }

implement
{a}
associate_points
(p, n_clusters, medoids) = 
    let
        val p_medoids = lookup_medoids(p, medoids)
    in
        associate_points_aux(p, n_clusters, p_medoids, nil())
    where {
        fun
        {a:t@ype}
        associate_points_aux
        (p: pointlst(a), n_clusters: int, p_medoids: pointlst(a), res: mylist(int)): mylist(int) =
            case+ p of
            | nil() => reverse(res)
            | cons(p1, p) => 
                let 
                    val c = find_medoid(p1, p_medoids, 0, 0, 10000.0)
                in 
                    associate_points_aux(p, n_clusters, p_medoids, cons(c, res)) 
                end
    }
    end

implement
{a}
find_medoid(p1, p_medoids, old_medoid, medoid_index, min_d) = 
    case+ p_medoids of
    | nil() => old_medoid
    | cons(pm, p_medoids) => 
    let
        val d = distance(p1, pm)
    in
        if d < min_d then
            find_medoid(p1, p_medoids, medoid_index, medoid_index+1, d)
        else
            find_medoid(p1, p_medoids, old_medoid, medoid_index+1, min_d)
    end

implement
{a}
lookup_medoids(p, medoids) = 
    lookup_medoids_aux(p, medoids, nil())
    where
    {
        fun
        lookup_medoids_aux(p: pointlst(a), medoids: mylist(int), res: pointlst(a)) = 
            case+ medoids of
            | nil() => reverse(res)
            | cons(m, medoids) => 
                let
                    val pm = mylist_get_at_exn(p, m)
                in
                    lookup_medoids_aux(p, medoids, cons(pm, res))
                end
    }

implement
{a}
swap(medoids, i, j) = 
    mylist_replace_at(medoids, i, j)


implement
{a}
costf
(p, medoids, clusters) =
    costf_aux(p, lookup_medoids(p, medoids), clusters, 0.0)
    where
    {
        fun
        costf_aux(p: pointlst(a), medoid_pts: pointlst(a), clusters: mylist(int), res: double) = 
            case+ p of
            | nil() => res
            | cons(p1, p) => 
                let
                    val-cons(c1, clusters) = clusters
                    val m = mylist_get_at_exn(medoid_pts, c1)
                    val d = distance(p1, m)
                in
                    costf_aux(p, medoid_pts, clusters, res + d)
                end
    }

// implement main0() =
// {
// }