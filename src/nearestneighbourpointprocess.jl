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

function DT.add_point!(nnpp::NearestNeighbourPointProcess, pt...; kwargs...)
    empty!(nnpp.history)
    DT.add_point!(nnpp.triangulation, pt...; store_event_history = Val(true), event_history = nnpp.history, kwargs...)
end

undo_add_point!(nnpp::NearestNeighbourPointProcess) = DT.undo_insertion!(nnpp.triangulation, nnpp.history)

function DT.delete_point!(nnpp::NearestNeighbourPointProcess, vertex; kwargs...)
    empty!(nnpp.history)
    DT.delete_point!(nnpp.triangulation, vertex; store_event_history = Val(true), event_history = nnpp.history, kwargs...)
end

undo_delete_point!(nnpp::NearestNeighbourPointProcess) = DT.undo_insertion!(nnpp.triangulation, nnpp.history, Val(false))

## Would like to say: vertex is an Int and point is a Point
vertices(nnpp::NearestNeighbourPointProcess) = PointSet([DT.get_point(nnpp.triangulation, vertex) for vertex in DT.each_solid_vertex(nnpp.triangulation)]) #PointSet(DT.get_points(nnpp.triangulation))

get_point(nnpp::NearestNeighbourPointProcess, vertex::Int64) = DT.get_point(nnpp.triangulation, vertex)

# function Meshes.viz(nnpp::NearestNeighbourPointProcess)

# end