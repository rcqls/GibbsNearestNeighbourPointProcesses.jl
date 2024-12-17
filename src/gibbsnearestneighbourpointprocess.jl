mutable struct GibbsNearestNeighbourPointProcess <: GeoStatsProcesses.PointProcess
    nnpp::NearestNeighbourPointProcess
    interactions::Vector{Interaction}
end

GibbsNearestNeighbourPointProcess(interactions::Vector{Interaction}) = GibbsNearestNeighbourPointProcess(NearestNeighbourPointProcess(), interactions)

