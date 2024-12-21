
struct Del2Interaction <: Interaction
   φ::Function # applied on l^2
end

del2(φ::Function) = Del2Interaction(φ ∘ √)

function localenergy(del2::Del2Interaction, nnpp::NearestNeighbourPointProcess)
    points = DT.get_points(nnpp.triangulation)
    return energy(del2, points, nnpp.history.added_triangles) - energy(del2, points, nnpp.history.deleted_triangles)
end

function energy(del2::Del2Interaction, points::Vector{Tuple{Float64, Float64}}, triangles::Set{Tuple{Int64, Int64, Int64}})
    entot = 0.0
    for t in  triangles
        for e in DT.triangle_edges(t)
            ## if all(e .> 0)
                l² = sum((points[e[1]] .- points[e[2]]).^2)
                entot += del2.φ(l²)
            ## end
        end
    end
    return entot
end

