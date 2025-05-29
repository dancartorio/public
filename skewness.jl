using Statistics
using StatsBase
using Plots
using Measures
using Random  # <-- adicione esta linha

# Gerando duas distribuições: uma normal (simétrica) e uma exponencial (assimétrica)
dados_normais = randn(1000)
dados_exponenciais = randexp(1000)

# Calculando média, mediana e skewness
media_normal = mean(dados_normais)
mediana_normal = median(dados_normais)
assimetria_normal = skewness(dados_normais)

media_exp = mean(dados_exponenciais)
mediana_exp = median(dados_exponenciais)
assimetria_exp = skewness(dados_exponenciais)

# Plotando os histogramas
p1 = histogram(
    dados_normais, bins=30, normalize=true, color=:lightblue, alpha=0.7, label="Normal",
    title="Distribuição Normal (Simétrica)",
    xlabel="Valor", ylabel="Densidade", legend=:topright, 
    bottom_margin=18mm, left_margin=20mm, right_margin=20mm
)
vline!(p1, [media_normal], label="Média", color=:red, linewidth=2)
vline!(p1, [mediana_normal], label="Mediana", color=:blue, linewidth=2)
annotate!(p1, (media_normal, 0.18), text("Média ≈ Mediana", :red, 10))
annotate!(p1, (media_normal, 0.13), text("Skewness = $(round(assimetria_normal, digits=2))", :black, 9))

# Calculando o histograma corretamente
hist_vals = fit(Histogram, dados_exponenciais)  # Remova o parâmetro 30
ymax = maximum(hist_vals.weights) / sum(hist_vals.weights)

# Agora use ymax para posicionar as anotações:
p2 = histogram(
    dados_exponenciais, bins=30, normalize=true, color=:orange, alpha=0.7, label="Exponencial",
    title="Distribuição Exponencial (Assimétrica)",
    xlabel="Valor", ylabel="Densidade", legend=:topright, 
    bottom_margin=18mm, left_margin=20mm, right_margin=20mm
)
vline!(p2, [media_exp], label="Média", color=:red, linewidth=2)
vline!(p2, [mediana_exp], label="Mediana", color=:blue, linewidth=2)
annotate!(p2, (media_exp, ymax*0.85), text("Média > Mediana", :red, 10))
annotate!(p2, (media_exp, ymax*0.65), text("Skewness = $(round(assimetria_exp, digits=2))", :black, 9))

# Para aplicar globalmente ao layout final:
plot(p1, p2, layout=(1,2), size=(900,350), titlefontsize=11, margin=20mm)