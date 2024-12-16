using GibbsNearestNeighbourPointProcesses
#
import DelaunayTriangulation as DT
pts = [(0.0, 0.0), (2.0, 0.0), (1.0, 2.0)] 
npp = NearestNeighbourPointProcess(pts)

DT.get_points(npp.triangulation)
add_point!(npp, 1.33, 1.33)
npp.history
DT.get_triangles(npp.triangulation)

add_point!(npp, 1.4, 1.2)
npp.history

add_point!(npp, 1.9, 1.1)
npp.history
DT.get_neighbours(npp.triangulation, 4)