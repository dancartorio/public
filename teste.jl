using LinearAlgebra
using DifferentialEquations
using Plots

# --------------------------
# 1. Definindo o Sistema
# --------------------------

A = [-3 4;
     -2 3]

function sistema!(du, u, p, t)
    du[:] = A * u
end

# --------------------------
# 2. Autovalores e Autovetores
# --------------------------

λ, v = eigen(A)
println("Autovalores: ", λ)
println("Autovetores (colunas de v):")
println(v)

# --------------------------
# 3. Simulações
# --------------------------

iniciais = [
    [2.0, 1.0], [-2.0, -1.0],
    [1.0, -2.0], [-1.0, 2.0],
    [3.0, 3.0], [-3.0, -3.0]
]

tspan = (0.0, 3.0)
solucoes = [solve(ODEProblem(sistema!, u0, tspan)) for u0 in iniciais]

# --------------------------
# 4. Campo Vetorial
# --------------------------

xrange = -4:0.5:4
yrange = -4:0.5:4
U = [A[1,1]*x + A[1,2]*y for x in xrange, y in yrange]
V = [A[2,1]*x + A[2,2]*y for x in xrange, y in yrange]

# --------------------------
# 5. Animação do Fluxo com Legenda
# --------------------------

@gif for t in range(0, 3, length=60)
    plot(
        quiver(xrange, yrange, quiver=(U, V),
            color=:gray, alpha=0.4,
            xlabel="x", ylabel="y",
            title="Fluxo do Sistema Linear — Ponto de Sela",
            xlims=(-4,4), ylims=(-4,4),
            legend=:bottomright)
    )

    # Trajetórias com rótulo
    for (i, sol) in enumerate(solucoes)
        tvals = sol.t[sol.t .<= t]
        if !isempty(tvals)
            plot!(sol[1, 1:length(tvals)], sol[2, 1:length(tvals)],
                  lw=2, label=i == 1 ? "Trajetórias" : "")
            scatter!([sol(t)[1]], [sol(t)[2]], color=:red, markersize=4,
                     label=i == 1 ? "Posições no tempo" : "")
        end
    end

    # Autovetores com legenda
    quiver!([0,0], [0,0],
        quiver=([v[1,1]], [v[2,1]]),
        color=:red, lw=3, label="λ₁ = $(round(λ[1], digits=2)) (estável)")

    quiver!([0,0], [0,0],
        quiver=([v[1,2]], [v[2,2]]),
        color=:blue, lw=3, label="λ₂ = $(round(λ[2], digits=2)) (instável)")

    # Ponto de equilíbrio
    scatter!([0], [0], color=:black, label="Ponto de sela (0,0)")
end every 2
