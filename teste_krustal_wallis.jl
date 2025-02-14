# Carregar pacotes necessários
using HypothesisTests
using Plots, StatsPlots
using DataFrames
using Random

# Configurar semente para reproduzibilidade
Random.seed!(123)

# Gerar dados de exemplo (3 grupos diferentes)
n = 30  # número de observações por grupo
groupA = randn(n) .- 1       # Grupo A: distribuição normal com média -1
groupB = randn(n)            # Grupo B: distribuição normal padrão
groupC = 2 .* rand(n) .+ 0.5 # Grupo C: distribuição uniforme entre 0.5 e 2.5

# Realizar o teste de Kruskal-Wallis
test_result = KruskalWallisTest(groupA, groupB, groupC)

# Mostrar resultados do teste
println("Resultado do Teste de Kruskal-Wallis:")
println(test_result)

# Preparar dados para visualização
df = DataFrame(
    Group = vcat(fill("A", n), fill("B", n), fill("C", n)),
    Value = vcat(groupA, groupB, groupC)
)

# Criar gráfico de caixa com pontos individuais
plt = @df df boxplot(:Group, :Value, 
    legend=false, 
    xlabel="Grupo", 
    ylabel="Valores",
    title="Distribuição por Grupo (Teste Kruskal-Wallis)",
    linewidth=1.5,
    whisker_width=1)

@df df dotplot!(:Group, :Value, 
    color=:black, 
    alpha=0.5,
    markersize=5,
    marker=:circle)

# Mostrar gráfico
display(plt)
