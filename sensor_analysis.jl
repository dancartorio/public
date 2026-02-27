# ============================================================
#  🏭 FÁBRICA DE SENSORES DE TEMPERATURA — Julia
#  Instale as deps uma única vez:
#    julia -e 'using Pkg; Pkg.add(["Plots","QuadGK","Printf","LaTeXStrings"])'
# ============================================================

using Plots
using QuadGK
using Printf
using LaTeXStrings
using Random

gr()   # backend GR — gera PNG

# ── Paleta dark industrial ───────────────────────────────────
BG     = RGB(0.059, 0.059, 0.094)
PANEL  = RGB(0.086, 0.086, 0.122)
BLUE   = RGB(0.227, 0.557, 0.902)
ORANGE = RGB(0.910, 0.408, 0.125)
GOLD   = RGB(0.961, 0.773, 0.259)
RED    = RGB(0.910, 0.251, 0.251)
WHITE  = RGB(0.941, 0.941, 0.941)

default(
    background_color         = BG,
    background_color_outside = BG,
    background_color_inside  = PANEL,
    foreground_color         = WHITE,
    foreground_color_axis    = WHITE,
    foreground_color_border  = RGB(0.165, 0.165, 0.220),
    foreground_color_grid    = RGB(0.165, 0.165, 0.220),
    foreground_color_text    = WHITE,
    foreground_color_guide   = WHITE,
    gridlinewidth            = 0.6,
    tick_direction           = :out,
    framestyle               = :box,
    titlefontsize            = 11,
    guidefontsize            = 9,
    tickfontsize             = 8,
    legendfontsize           = 8,
    legend_background_color  = RGBA(0,0,0,0.4),
    legend_foreground_color  = WHITE,
    fontfamily               = "monospace",
    dpi                      = 160,
)

# ============================================================
#  Funções
# ============================================================
f(x)       = 2x
F(x)       = x < 0 ? 0.0 : x > 1 ? 1.0 : x^2
f_jt(x, y) = 6x * y

xs = range(0, 1, length=1000)

# ============================================================
#  Cálculos
# ============================================================
prob1, _ = quadgk(f, 0.2, 0.6)
F05      = F(0.5)
EX,  _   = quadgk(x -> x * f(x), 0, 1)
EX2, _   = quadgk(x -> x^2 * f(x), 0, 1)
varX     = EX2 - EX^2
sigX     = sqrt(varX)
prob5, _ = quadgk(0, 0.5) do y
    quadgk(x -> f_jt(x, y), 0, 0.5)[1]
end

println("=" ^ 60)
println("  FÁBRICA DE SENSORES DE TEMPERATURA")
println("=" ^ 60)
@printf "\n🔹 1) P(0.2 ≤ X ≤ 0.6) = %.6f  ✔ %.2f%%\n"   prob1  prob1*100
@printf "🔹 2) F(0.5)           = %.6f  ✔ 25%% ≤ 0.5°C\n" F05
@printf "🔹 3) E(X)             = %.6f  (exato: 2/3)\n"   EX
@printf "🔹 4) Var(X)           = %.6f  σ=%.4f\n"         varX   sigX
@printf "🔹 5) P(X≤0.5,Y≤0.5)  = %.6f  ✔ %.4f%%\n"       prob5  prob5*100
println("=" ^ 60)

# ============================================================
#  SUBPLOT 1 — PDF + área destacada
# ============================================================
xf = range(0.2, 0.6, length=300)
p1 = plot(xs, f.(xs),
    lw        = 2.5,
    color     = BLUE,
    label     = L"f(x)=2x",
    title     = "1) PDF  f(x) = 2x",
    xlabel    = "Erro (°C)",
    ylabel    = "Densidade",
    ylims     = (0, 2.2),
)
plot!(p1, xf, f.(xf),
    fillrange = 0,
    fillcolor = RGBA(0.227, 0.557, 0.902, 0.30),
    linecolor = :transparent,
    label     = @sprintf("P(0.2≤X≤0.6) = %.4f", prob1),
)
annotate!(p1, 0.40, 0.50,
    text(@sprintf("P = %.4f", prob1), BLUE, :center, 9, :bold))

# ============================================================
#  SUBPLOT 2 — CDF
# ============================================================
p2 = plot(xs, F.(xs),
    lw     = 2.5,
    color  = ORANGE,
    label  = L"F(x)=x^2",
    title  = "2) CDF  F(x) = x²",
    xlabel = "Erro (°C)",
    ylabel = "Prob. acumulada",
    ylims  = (0, 1.05),
)
scatter!(p2, [0.5], [F05],
    ms    = 8,
    color = GOLD,
    label = @sprintf("F(0.5) = %.2f", F05),
)
vline!(p2, [0.5], lw=1.2, ls=:dash, color=GOLD, label="")
hline!(p2, [F05], lw=1.2, ls=:dash, color=GOLD, label="")

# ============================================================
#  SUBPLOT 3 — Histograma amostral + PDF + E(X) ± σ
# ============================================================
Random.seed!(42)
samples = sqrt.(rand(20_000))   # F⁻¹(u) = √u → X ~ f(x)=2x

p3 = histogram(samples,
    bins      = 50,
    normalize = :pdf,
    color     = RGBA(0.227, 0.557, 0.902, 0.45),
    linecolor = :transparent,
    label     = "Amostra (n=20 000)",
    title     = "3-4) Distribuição Empírica + E(X) e Var(X)",
    xlabel    = "Erro (°C)",
    ylabel    = "Densidade",
)
plot!(p3, xs, f.(xs), lw=2.5, color=BLUE, label=L"f(x)=2x")
vline!(p3, [EX],
    lw    = 2.0,
    color = GOLD,
    label = @sprintf("E(X) = %.4f", EX),
)
vline!(p3, [EX - sigX, EX + sigX],
    lw    = 1.5,
    ls    = :dash,
    color = RED,
    label = @sprintf("±σ  (σ=%.4f)", sigX),
)

# ============================================================
#  SUBPLOT 4 — Heatmap densidade conjunta
# ============================================================
xg = range(0, 1, length=120)
yg = range(0, 1, length=120)
Z  = [f_jt(x, y) for y in yg, x in xg]

p4 = heatmap(xg, yg, Z,
    color          = :plasma,
    title          = "5) Densidade Conjunta f(x,y) = 6xy",
    xlabel         = "Erro X (°C)",
    ylabel         = "Tempo Y (s)",
    colorbar_title = "f(x,y)",
    clims          = (0, maximum(Z)),
)
vline!(p4, [0.5], lw=1.8, ls=:dash, color=WHITE, alpha=0.8, label="x=0.5")
hline!(p4, [0.5], lw=1.8, ls=:dash, color=WHITE, alpha=0.8, label="y=0.5")
rect_x = [0.0, 0.5, 0.5, 0.0, 0.0]
rect_y = [0.0, 0.0, 0.5, 0.5, 0.0]
plot!(p4, rect_x, rect_y, lw=2, color=GOLD, label="")
annotate!(p4, 0.25, 0.25,
    text(@sprintf("P=%.5f\n≈%.3f%%", prob5, prob5*100),
         WHITE, :center, 9, :bold))

# ============================================================
#  COMPOSIÇÃO FINAL
# ============================================================
fig = plot(p1, p2, p3, p4,
    layout             = (2, 2),
    size               = (1400, 900),
    plot_title         = "Analise de Qualidade — Sensores de Temperatura",
    plot_titlefontsize = 13,
    margin             = 6Plots.mm,
)

savefig(fig, "sensor_analysis.png")
println("\n✅  sensor_analysis.png salvo!")
