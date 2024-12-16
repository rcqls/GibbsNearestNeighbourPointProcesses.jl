mutable struct NearestNeighbourPointProcess <: GeoStatsProcesses.PointProcess
    points::Union{Vector{NTuple{2, Float64}}, Matrix{Float64}}
    triangulation::Triangulation
    history::DelaunayTriangulation.InsertionEventHistory
    function NearestNeighbourPointProcess(points::Union{Vector{NTuple{2, Float64}}, Matrix{Float64}})
        npp = new()
        npp.points = points
        npp.triangulation = triangulate(npp.points)
        npp.history = DelaunayTriangulation.InsertionEventHistory(npp.triangulation)
        return npp
    end
end

function DelaunayTriangulation.add_point!(npp::NearestNeighbourPointProcess, pt...; kwargs...)
    empty!(npp.history)
    DelaunayTriangulation.add_point!(npp.triangulation, pt...; store_event_history = Val(true), event_history = npp.history, kwargs...)
end