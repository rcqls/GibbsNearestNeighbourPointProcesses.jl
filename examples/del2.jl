using GibbsNearestNeighbourPointProcesses
using GeoStats
using CairoMakie
import GibbsNearestNeighbourPointProcesses as GNNPP
# del2(x -> 3x)
gnnpp = GibbsNearestNeighbourPointProcess([single(1.0),del2(x -> 3x)]) # l = length

viz(GNNPP.vertices(gnnpp))
length(GNNPP.vertices(gnnpp))