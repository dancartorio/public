using Distributions, Plots
theme(:bright)

# Parâmetros do teste
μ0 = 0        # Média sob a hipótese nula
σ = 5         # Desvio padrão populacional
x̄ = 2.0       # Média amostral
n = 25        # Tamanho da amostra
α = 0.05      # Nível de significância

# Cálculo do escore Z
z = (x̄ - μ0) / (σ / √n)

# Valor crítico para teste unilateral (esquerda)
dist = Normal(0, 1)  # Distribuição normal padrão
z_critico_esq = quantile(dist, α)

# Geração de pontos para o gráfico
x = range(-4, 4, length=400)
y = pdf.(dist, x)

# Criação do gráfico
plt = plot(x, y, 
    title = "Teste de Hipótese Z Unilateral (Esquerda)",
    label = "Distribuição Normal Padrão",
    linewidth = 2,
    xlabel = "Z-score",
    ylabel = "Densidade de Probabilidade",
    legend = :topleft,  # Alterado para top left para melhor visualização
    xlims = (-4, 4),
    ylims = (0, 0.45))

# Área de rejeição (esquerda)
x_rejeicao_esq = range(-4, z_critico_esq, length=100)
plot!(plt, x_rejeicao_esq, pdf.(dist, x_rejeicao_esq), 
    fillrange=0, fillalpha=0.3, color=:red, label="Área de Rejeição")

# Linhas críticas e do escore Z
vline!(plt, [z_critico_esq], 
    line=:dash, color=:green, label="Valor Crítico ($(round(z_critico_esq, digits=2)))")
vline!(plt, [z], 
    line=:solid, color=:blue, linewidth=2, label="Estatística do Teste (Z = $(round(z, digits=2))")

# Anotações
annotate!(plt, z_critico_esq - 0.5, 0.05, text("α = $α", 10, :red))
annotate!(plt, z, 0.15, text("Z observado", :blue, :center, 10))

display(plt)