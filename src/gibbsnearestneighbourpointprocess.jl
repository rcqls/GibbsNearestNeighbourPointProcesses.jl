mutable struct GibbsNearestNeighbourPointProcess <: GeoStatsProcesses.PointProcess
    nnpp::NearestNeighbourPointProcess
    interactions::Vector{Interaction}
    domain::Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}
    border::Float64
    function GibbsNearestNeighbourPointProcess(interactions::Vector; domain = ((-100.0,100.0),(-100.0,100.0)), border = 50.0)
        gpp = new()
        gpp.interactions = convert.(Interaction,interactions)
        gpp.domain = domain
        gpp.border = border
        initpoints!(gpp)
        return gpp
    end
end

function initpoints!(gpp::GibbsNearestNeighbourPointProcess)
    g = domain(gpp, inside = false)
    n = 100
    pts = collect(zip(rand(Uniform(g[1]...),n),rand(Uniform(g[1]...),n)))
    gpp.nnpp = NearestNeighbourPointProcess(pts)
end

vertices(gnnpp::GibbsNearestNeighbourPointProcess) = vertices(gnnpp.nnpp)

function GeoStatsProcesses.randsingle(rng::AbstractRNG, gpp::GibbsNearestNeighbourPointProcess, g)

end

domain(gpp::GibbsNearestNeighbourPointProcess; inside = true) = return inside ? gpp.domain : (gpp.domain[1] .+ (-gpp.border, gpp.border), gpp.domain[2] .+ (-gpp.border, gpp.border))

