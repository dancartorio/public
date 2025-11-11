using Statistics, LinearAlgebra, Plots, Distributions, StatsPlots
theme(:bright)
# --- Dados (2023, valores aproximados) ---
paises = ["Brasil", "EUA", "Alemanha", "Japão", "África do Sul"]
pib = [10400, 76300, 55400, 34000, 6800]
desemprego = [7.9, 3.6, 3.2, 2.6, 32.1]
X = hcat(pib, desemprego)

# --- Estatísticas básicas ---
μ = mean(X, dims=1) |> vec
Σ = cov(X)
ρ = cor(pib, desemprego)

println("="^60)
println("ESTATÍSTICAS DESCRITIVAS")
println("="^60)
println("Média vetorial: ", round.(μ, digits=2))
println("Desvio padrão PIB: ", round(std(pib), digits=2))
println("Desvio padrão Desemprego: ", round(std(desemprego), digits=2))
println("\nMatriz de covariância:")
display(round.(Σ, digits=2))
println("\nMatriz de correlação:")
display(round.(cor(X), digits=3))
println("\nCorrelação PIB × Desemprego: ", round(ρ, digits=3))
println("="^60)

# Interpretação da correlação
if abs(ρ) < 0.3
    intensidade = "fraca"
elseif abs(ρ) < 0.7
    intensidade = "moderada"
else
    intensidade = "forte"
end
direcao = ρ > 0 ? "positiva" : "negativa"
println("Interpretação: Correlação $intensidade e $direcao")
println("="^60)

# --- Função para desenhar elipse ---
function elipse_cov(μ, Σ; n=200, nivel=0.95)
    θ = range(0, 2π, length=n)
    vals, vecs = eigen(Σ)
    k2 = quantile(Chisq(2), nivel)
    elip = [μ .+ vecs * Diagonal(sqrt.(vals .* k2)) * [cos(t); sin(t)] for t in θ]
    xs = [p[1] for p in elip]
    ys = [p[2] for p in elip]
    # garantir polígono fechado (último ponto = primeiro)
    push!(xs, xs[1])
    push!(ys, ys[1])
    return xs, ys
end

# --- Gráfico principal ---
xs, ys = elipse_cov(μ, Σ)

plt = scatter(
    pib, desemprego;
    xlabel = "PIB per capita (US\$)",
    ylabel = "Taxa de desemprego (%)",
    title = "Dispersão Bivariada: PIB × Desemprego (2023)",
    label = "Países",
    color = :dodgerblue,
    alpha = 0.6,
    markersize = 8,
    legend = :topright,
    size = (800, 600),
    grid = true,
    gridstyle = :dot,
    gridalpha = 0.3,
    framestyle = :box
)

# Elipse de dispersão (preenchida)
plot!(xs, ys; seriestype=:shape, fillcolor=:orange, alpha=0.12, linecolor=:red, linewidth=2, label="Elipse 95%")

# Média vetorial
scatter!([μ[1]], [μ[2]]; 
    color = :crimson, 
    label = "Média μ", 
    markershape = :star5, 
    markersize = 12,
    markerstrokewidth = 2,
    markerstrokecolor = :black
)

# Nomes dos países com melhor posicionamento
offsets = [(2000, -1.5), (2000, 0.3), (2000, 0.3), (2000, 0.3), (2000, -1.5)]
for i in 1:length(paises)
    annotate!(pib[i] + offsets[i][1], desemprego[i] + offsets[i][2], 
              text(paises[i], 9, :left, :black))
end

# Adiciona linha de tendência
using GLM, DataFrames
df = DataFrame(PIB = pib, Desemprego = desemprego)
modelo = lm(@formula(Desemprego ~ PIB), df)
pib_range = range(minimum(pib), maximum(pib), length=100)
pred = predict(modelo, DataFrame(PIB = pib_range))
plot!(pib_range, pred; 
    color = :green, 
    linewidth = 2, 
    label = "Regressão linear",
    linestyle = :solid,
    alpha = 0.7
)

display(plt)

# --- Estatísticas adicionais ---
println("\n" * "="^60)
println("ANÁLISE DE REGRESSÃO LINEAR")
println("="^60)
println(modelo)
r2_valor = r²(modelo)
println("\nR² = ", round(r2_valor, digits=4))
println("Interpretação: $(round(r2_valor*100, digits=2))% da variação no desemprego")
println("é explicada pelo PIB per capita")
println("="^60)

# --- Gráficos adicionais ---
# Histogramas marginais
p1 = histogram(pib, bins=5, xlabel="PIB per capita", ylabel="Frequência", 
               title="Distribuição do PIB", legend=false, color=:lightblue)
vline!([μ[1]], linewidth=2, color=:red, linestyle=:dash, framestyle = :box)

p2 = histogram(desemprego, bins=5, xlabel="Taxa de desemprego (%)", 
               ylabel="Frequência", title="Distribuição do Desemprego", 
               legend=false, color=:lightgreen)
vline!([μ[2]], linewidth=2, color=:red, linestyle=:dash, framestyle = :box)

plt_hist = plot(p1, p2, layout=(1,2), size=(900, 350))
display(plt_hist)

# --- Box plots ---
p3 = boxplot(["PIB"], pib, ylabel="PIB per capita (US\$)", 
             title="Box Plot: PIB", legend=false, color=:lightblue, framestyle = :box)
p4 = boxplot(["Desemprego"], desemprego, ylabel="Taxa (%)", 
             title="Box Plot: Desemprego", legend=false, color=:lightgreen, framestyle = :box)

plt_box = plot(p3, p4, layout=(1,2), size=(900, 350))
display(plt_box)