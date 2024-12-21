using GibbsNearestNeighbourPointProcesses
import GibbsNearestNeighbourPointProcesses as GNNPP
using GeoStats
using CairoMakie
pts = [(0.0, 0.0), (2.0, 0.0), (1.0, 2.0)] 
nnpp = NearestNeighbourPointProcess(pts)
DT.num_points(nnpp.triangulation)
viz(GNNPP.vertices(nnpp))
fig, ax, sc = triplot(nnpp.triangulation)

rand(DT.each_solid_vertex(nnpp.triangulation))
add_point!(nnpp, 1.33, 1.33)
nnpp.history
GNNPP.vertices(nnpp)
DT.num_
DT.get_triangles(nnpp.triangulation)
fig, ax, sc = triplot(nnpp.triangulation)
GNNPP.undo_add_point!(nnpp)
GNNPP.vertices(nnpp)
DT.get_triangles(nnpp.triangulation)
fig, ax, sc = triplot(nnpp.triangulation)

add_point!(nnpp, (1.1, 1.1))
nnpp.history
GNNPP.vertices(nnpp)
DT.get_triangles(nnpp.triangulation)

add_point!(nnpp, (1.112, 1.122))
GNNPP.vertices(nnpp)

fig, ax, sc = triplot(nnpp.triangulation)
fig
delete_point!(nnpp, 4)
nnpp.history
GNNPP.vertices(nnpp)
DT.get_triangles(nnpp.triangulation)
fig, ax, sc = triplot(nnpp.triangulation)

GNNPP.undo_delete_point!(nnpp)
GNNPP.vertices(nnpp)
DT.get_triangles(nnpp.triangulation)
fig, ax, sc = triplot(nnpp.triangulation)

if false
    allpts = DT.get_points(nnpp.triangulation)
    for t in  DT.each_triangle(nnpp.history.added_triangles)
        for e in DT.triangle_edges(t)
            l = sum((allpts[e[1]] .- allpts[e[2]]).^2)
            println(e,"->", (allpts[e[1]], allpts[e[2]]), "->",l)

        end
    end
end


