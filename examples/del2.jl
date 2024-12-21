using GibbsNearestNeighbourPointProcesses 
using DelaunayTriangulation
using GeoStats
using CairoMakie
import GibbsNearestNeighbourPointProcesses as GNNPP
# del2(x -> 3x)
gnnpp = GibbsNearestNeighbourPointProcess([single(3.0),del2(l -> ( 10 < l < 20) * 3)]) # l = length
rand(gnnpp)
viz(GNNPP.vertices(gnnpp))
length(GNNPP.vertices(gnnpp))
fig, ax, sc = triplot(gnnpp.nnpp.triangulation)