mutable struct NearestNeighbourPointProcess
    triangulation::DT.Triangulation
    history::DT.InsertionEventHistory
    function NearestNeighbourPointProcess(points::Union{Vector{NTuple{2, Float64}}, Matrix{Float64}})
        nnpp = new()
        nnpp.triangulation = triangulate(points)
        nnpp.history = DT.InsertionEventHistory(nnpp.triangulation)
        return nnpp
    end
end

NearestNeighbourPointProcess() = NearestNeighbourPointProcess(NTuple{2, Float64}[])

function DT.add_point!(nnpp::NearestNeighbourPointProcess, pt...; kwargs...)
    empty!(nnpp.history)
    DT.add_point!(nnpp.triangulation, pt...; store_event_history = Val(true), event_history = nnpp.history, kwargs...)
end

function DT.delete_point!(nnpp::NearestNeighbourPointProcess, vertex; kwargs...)
    empty!(nnpp.history)
    DT.delete_point!(nnpp.triangulation, vertex; store_event_history = Val(true), event_history = nnpp.history, kwargs...)
end

vertices(nnpp::NearestNeighbourPointProcess) = PointSet(DT.get_points(nnpp.triangulation))

# function Meshes.viz(nnpp::NearestNeighbourPointProcess)

# end