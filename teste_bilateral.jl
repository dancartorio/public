using Distributions, Plots
theme(:bright)

# Parâmetros do teste
μ0 = 15        # Média sob a hipótese nula
σ = 4         # Desvio padrão populacional
x̄ = 16.2       # Média amostral
n = 40        # Tamanho da amostra
α = 0.05      # Nível de significância

# Cálculo do escore Z
z = (x̄ - μ0) / (σ / √n)

# Valores críticos para teste bilateral
dist = Normal(0, 1)  # Distribuição normal padrão
z_critico_inf = quantile(dist, α/2)
z_critico_sup = quantile(dist, 1 - α/2)

# Geração de pontos para o gráfico
x = range(-4, 4, length=400)
y = pdf.(dist, x)

# Criação do gráfico
plt = plot(x, y, 
    title = "Teste de Hipótese Z Bilateral",
    label = "Distribuição Normal Padrão",
    linewidth = 2,
    xlabel = "Z-score",
    ylabel = "Densidade de Probabilidade",
    legend = :topright,
    xlims = (-4, 4),
    ylims = (0, 0.45))

# Áreas de rejeição
x_rejeicao_esq = range(-4, z_critico_inf, length=100)
x_rejeicao_dir = range(z_critico_sup, 4, length=100)

plot!(plt, x_rejeicao_esq, pdf.(dist, x_rejeicao_esq), 
    fillrange=0, fillalpha=0.3, color=:red, label="Área de Rejeição")
plot!(plt, x_rejeicao_dir, pdf.(dist, x_rejeicao_dir), 
    fillrange=0, fillalpha=0.3, color=:red, label="")

# Linhas críticas e do escore Z
vline!(plt, [z_critico_inf], 
    line=:dash, color=:green, label="Valores Críticos ($(round(z_critico_inf, digits=2)), $(round(z_critico_sup, digits=2))")
vline!(plt, [z_critico_sup], 
    line=:dash, color=:green, label="")
vline!(plt, [z], 
    line=:solid, color=:blue, linewidth=2, label="Estatística do Teste (Z = $(round(z, digits=2))")

# Anotações
annotate!(plt, z_critico_inf-0.3, 0.05, text("α/2 = $(α/2)", 10, :red))
annotate!(plt, z_critico_sup+0.3, 0.05, text("α/2 = $(α/2)", 10, :red))
annotate!(plt, z, 0.15, text("Z observado", :blue, :center, 10))

display(plt)
