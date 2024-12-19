struct SingletonInteraction <: Interaction
    α::Union{Float64,Function}
 end
 
 single(α::Float64) = SingletonInteraction(α)
 single(α::Function) = SingletonInteraction(α)
 
 function localenergy(s::SingletonInteraction, nnpp::NearestNeighbourPointProcess)
     point = DT.get_points(nnpp.triangulation)[end]
     return energy(s, point)
 end
 
 energy(s::SingletonInteraction, point::Tuple{Float64, Float64}) = s.α isa Float64 ? s.α : s.α(point)

 
 