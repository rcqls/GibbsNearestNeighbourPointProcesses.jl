mutable struct GibbsNearestNeighbourPointProcess
    nnpp::NearestNeighbourPointProcess
    interactions::Vector{Interaction}
    domain::Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}
    border::Float64
    insidebox::Box

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
    dom = domain(gpp, inside = false)
    n = 100
    pts = collect(zip(rand(Uniform(dom[1]...),n),rand(Uniform(dom[2]...),n)))
    gpp.nnpp = NearestNeighbourPointProcess(pts)
    domins = domain(gpp, inside = true)
    gpp.insidebox = Box((domins[1][1],domins[2][1]),(domins[1][2],domins[2][2]))
end

vertices(gnnpp::GibbsNearestNeighbourPointProcess) = vertices(gnnpp.nnpp)

domain(gpp::GibbsNearestNeighbourPointProcess; inside = true) = return inside ? gpp.domain : (gpp.domain[1] .+ (-gpp.border, gpp.border), gpp.domain[2] .+ (-gpp.border, gpp.border))

function num_points_outside(gpp::GibbsNearestNeighbourPointProcess)
    cpt = 0
    for pt in vertices(gpp)
        if !(pt ∈ gpp.insidebox)
            cpt += 1
        end
    end
    return cpt
end

function localenergy(gpp::GibbsNearestNeighbourPointProcess)
    en = 0.0
    for interaction in gpp.interactions
        en += localenergy(interaction, gpp.nnpp)
    end
    return en
end

function Base.rand(rng::AbstractRNG, gpp::GibbsNearestNeighbourPointProcess; nsim = 10000, inside = true)
    g = domain(gpp, inside = inside)
    size = (g[1][2] - g[1][1]) * (g[2][2] - g[2][1])
    num_pts_outside = inside ? num_points_outside(gpp) : 0
    cpt = Dict(:ins => 0, :del => 0)
    for _ in 1:nsim
        if rand(rng) < .5
            newpt = rand(rng, GibbsNearestNeighbourPointProcess, g)
            add_point!(gpp.nnpp, newpt)
            if rand(rng) < size / (DT.num_points(gpp.nnpp.triangulation) - num_pts_outside) * exp( localenergy(gpp))
                cpt[:ins] += 1
            else
                undo_add_point!(gpp.nnpp)
            end
        else
            vertex = rand(rng, gpp,  Int64, inside = inside)  
            delete_point!(gpp.nnpp, vertex)
            if rand(rng) < (DT.num_points(gpp.nnpp.triangulation) - num_pts_outside) / size * exp( -localenergy(gpp))
                cpt[:del] += 1
            else
                undo_delete_point!(gpp.nnpp)
            end
        end 
    end
end

Base.rand(gpp::GibbsNearestNeighbourPointProcess; kwargs...) = rand(Random.default_rng(), gpp; kwargs...)

## Choose a vertex randomly 
function Base.rand(rng::AbstractRNG, gpp::GibbsNearestNeighbourPointProcess, ::Type{Int64}; inside = true)
    vertex = rand(rng, each_solid_vertex(gpp.nnpp.triangulation))  
    println(vertex)
    pt = Point(get_point(gpp.nnpp, vertex))
    println(pt)
    if inside && !(pt ∈ gpp.insidebox)
        vertex = rand(rng, gpp, Int64, inside = inside)
    end
    return vertex
end
Base.rand(gpp::GibbsNearestNeighbourPointProcess, ::Type{Int64}; inside = true) = rand(Random.default_rng(), gpp, Int64; inside = inside)

## Choose a point in the domain for Gibbs
Base.rand(rng::AbstractRNG, ::Type{GibbsNearestNeighbourPointProcess}, domain::Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}) = (rand(rng, Uniform(domain[1]...)), rand(Uniform(domain[2]...)))
Base.rand(::Type{GibbsNearestNeighbourPointProcess}, domain::Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}) = rand(Random.default_rng(), GibbsNearestNeighbourPointProcess, domain)