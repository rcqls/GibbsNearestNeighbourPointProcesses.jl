using GibbsNearestNeighbourPointProcesses
import GibbsNearestNeighbourPointProcesses as GNNPP
nnpp = NearestNeighbourPointProcess([(0.0, 0.0)])
pts = [(0.0, 0.0), (2.0, 0.0), (1.0, 2.0)] 
nnpp = NearestNeighbourPointProcess(pts)
nnpp.points
add_point!(nnpp, 1.33, 1.33)
nnpp.history
DT.get_triangles(nnpp.triangulation)

add_point!(nnpp, (1.4, 1.2))
nnpp.history

add_point!(nnpp, 1.9, 1.1)
nnpp.history
DT.get_neighbours(nnpp.triangulation, 4)

delete_point!(nnpp, 4)

if false
    allpts = DT.get_points(nnpp.triangulation)
    for t in  DT.each_triangle(nnpp.history.added_triangles)
        for e in DT.triangle_edges(t)
            l = sum((allpts[e[1]] .- allpts[e[2]]).^2)
            println(e,"->", (allpts[e[1]], allpts[e[2]]), "->",l)

        end
    end
end


