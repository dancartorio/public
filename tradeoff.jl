using Random, Distributions, Statistics, Plots, StatsBase, Printf

# Configuração do experimento
Random.seed!(123)

"""
Experimento para demonstrar o trade-off entre erros Tipo I (α) e Tipo II (β)

Cenário: Teste de hipótese para média de uma distribuição normal
H₀: μ = μ₀ (hipótese nula)
H₁: μ = μ₁ (hipótese alternativa), onde μ₁ > μ₀

Parâmetros:
- μ₀: média sob H₀
- μ₁: média sob H₁ (efeito verdadeiro)
- σ: desvio padrão (conhecido)
- n: tamanho da amostra
"""

function simular_teste_hipotese(μ₀, μ₁, σ, n, α, num_simulacoes=10000)
    """
    Simula testes de hipótese e calcula as taxas de erro Tipo I e II
    
    Retorna:
    - taxa_erro_tipo_I: proporção de rejeições incorretas de H₀ quando H₀ é verdadeira
    - taxa_erro_tipo_II: proporção de não-rejeições incorretas de H₀ quando H₁ é verdadeira
    - poder: 1 - β (probabilidade de detectar o efeito quando existe)
    """
    
    # Distribuições sob H₀ e H₁
    dist_H₀ = Normal(μ₀, σ/√n)
    dist_H₁ = Normal(μ₁, σ/√n)
    
    # Valor crítico para teste unilateral à direita
    z_crítico = quantile(Normal(0,1), 1-α)
    valor_crítico = μ₀ + z_crítico * (σ/√n)
    
    # Simulação sob H₀ (para calcular erro Tipo I)
    amostras_H₀ = rand(dist_H₀, num_simulacoes)
    rejeicoes_H₀ = sum(amostras_H₀ .> valor_crítico)
    taxa_erro_tipo_I = rejeicoes_H₀ / num_simulacoes
    
    # Simulação sob H₁ (para calcular erro Tipo II)
    amostras_H₁ = rand(dist_H₁, num_simulacoes)
    nao_rejeicoes_H₁ = sum(amostras_H₁ .<= valor_crítico)
    taxa_erro_tipo_II = nao_rejeicoes_H₁ / num_simulacoes
    
    poder = 1 - taxa_erro_tipo_II
    
    return taxa_erro_tipo_I, taxa_erro_tipo_II, poder, valor_crítico
end

function calcular_beta_teorico(μ₀, μ₁, σ, n, α)
    """
    Calcula o valor teórico de β (erro Tipo II)
    """
    z_α = quantile(Normal(0,1), 1-α)
    z_β = z_α - (μ₁ - μ₀) / (σ/√n)
    β_teorico = cdf(Normal(0,1), z_β)
    return β_teorico
end

# Parâmetros do experimento
μ₀ = 100    # Média sob H₀
μ₁ = 105    # Média sob H₁ (efeito de 5 unidades)
σ = 15      # Desvio padrão
n = 25      # Tamanho da amostra

# Diferentes valores de α para analisar o trade-off
valores_α = [0.001, 0.005, 0.01, 0.025, 0.05, 0.10, 0.15, 0.20]

println("=== EXPERIMENTO: TRADE-OFF ENTRE ERROS TIPO I E II ===\n")
println("Parâmetros do experimento:")
println("μ₀ = $μ₀, μ₁ = $μ₁, σ = $σ, n = $n")
println("Efeito verdadeiro: δ = μ₁ - μ₀ = $(μ₁ - μ₀)")
println("Erro padrão: σ/√n = $(σ/√n)")
println("\n" * repeat("=", 70))

# Arrays para armazenar resultados
resultados = Dict(
    :alpha => Float64[],
    :erro_tipo_I_sim => Float64[],
    :erro_tipo_II_sim => Float64[],
    :erro_tipo_II_teorico => Float64[],
    :poder_sim => Float64[],
    :poder_teorico => Float64[]
)

# Executar simulações para cada valor de α
for α in valores_α
    println("\nTeste com α = $α:")
    
    # Simulação
    erro_I, erro_II, poder, v_critico = simular_teste_hipotese(μ₀, μ₁, σ, n, α)
    
    # Cálculo teórico
    erro_II_teorico = calcular_beta_teorico(μ₀, μ₁, σ, n, α)
    poder_teorico = 1 - erro_II_teorico
    
    # Armazenar resultados
    push!(resultados[:alpha], α)
    push!(resultados[:erro_tipo_I_sim], erro_I)
    push!(resultados[:erro_tipo_II_sim], erro_II)
    push!(resultados[:erro_tipo_II_teorico], erro_II_teorico)
    push!(resultados[:poder_sim], poder)
    push!(resultados[:poder_teorico], poder_teorico)
    
    println("  Valor crítico: $(round(v_critico, digits=3))")
    println("  Erro Tipo I (simulado): $(round(erro_I, digits=4)) (esperado: $α)")
    println("  Erro Tipo II (simulado): $(round(erro_II, digits=4))")
    println("  Erro Tipo II (teórico): $(round(erro_II_teorico, digits=4))")
    println("  Poder (simulado): $(round(poder, digits=4))")
    println("  Poder (teórico): $(round(poder_teorico, digits=4))")
end

println("\n" * repeat("=", 70))
println("GERANDO GRÁFICOS...")

# Gráfico 1: Trade-off α vs β
p1 = plot(resultados[:alpha], resultados[:erro_tipo_II_sim], 
         label="β (Simulado)", marker=:circle, linewidth=2, markersize=6,
         xlabel="α (Erro Tipo I)", ylabel="β (Erro Tipo II)",
         title="Trade-off entre Erros Tipo I e II",
         legend=:topright, grid=true)

plot!(p1, resultados[:alpha], resultados[:erro_tipo_II_teorico], 
      label="β (Teórico)", marker=:square, linewidth=2, markersize=5,
      linestyle=:dash)

# Adicionar linha de referência y=x para mostrar quando α = β
plot!(p1, [0, 0.2], [0, 0.2], label="α = β", color=:gray, linestyle=:dot, linewidth=1)

# Gráfico 2: α vs Poder (1-β)
p2 = plot(resultados[:alpha], resultados[:poder_sim], 
         label="Poder (Simulado)", marker=:circle, linewidth=2, markersize=6,
         xlabel="α (Erro Tipo I)", ylabel="Poder (1-β)",
         title="Relação entre α e Poder do Teste",
         legend=:bottomright, grid=true)

plot!(p2, resultados[:alpha], resultados[:poder_teorico], 
      label="Poder (Teórico)", marker=:square, linewidth=2, markersize=5,
      linestyle=:dash)

# Gráfico 3: Curvas das distribuições para diferentes α
p3 = plot()
x_range = 85:0.1:120

# Distribuições sob H₀ e H₁
dist_H₀_plot = Normal(μ₀, σ/√n)
dist_H₁_plot = Normal(μ₁, σ/√n)

plot!(p3, x_range, pdf.(dist_H₀_plot, x_range), 
      label="H₀: μ=$μ₀", linewidth=2, color=:blue)
plot!(p3, x_range, pdf.(dist_H₁_plot, x_range), 
      label="H₁: μ=$μ₁", linewidth=2, color=:red)

# Adicionar valores críticos para alguns α
for (i, α) in enumerate([0.05, 0.10, 0.20])
    _, _, _, v_critico = simular_teste_hipotese(μ₀, μ₁, σ, n, α, 100)
    vline!(p3, [v_critico], label="Crítico (α=$α)", 
           linestyle=:dash, linewidth=1.5)
end

xlabel!(p3, "Média Amostral")
ylabel!(p3, "Densidade")
title!(p3, "Distribuições sob H₀ e H₁")

# Combinar gráficos
layout = @layout [a b; c]
plot_final = plot(p1, p2, p3, layout=layout, size=(800, 600))

# Salvar gráfico (opcional)
# savefig(plot_final, "tradeoff_alpha_beta.png")

display(plot_final)

println("\n" * repeat("=", 70))
println("ANÁLISE DOS RESULTADOS:")
println("\n1. TRADE-OFF FUNDAMENTAL:")
println("   - Quando α ↑ (mais liberal), β ↓ (menos erro Tipo II)")
println("   - Quando α ↓ (mais conservador), β ↑ (mais erro Tipo II)")

println("\n2. IMPLICAÇÕES PRÁTICAS:")
idx_min_β = argmin(resultados[:erro_tipo_II_sim])
idx_max_poder = argmax(resultados[:poder_sim])

println("   - Menor β: α = $(resultados[:alpha][idx_min_β]) → β = $(round(resultados[:erro_tipo_II_sim][idx_min_β], digits=4))")
println("   - Maior poder: α = $(resultados[:alpha][idx_max_poder]) → Poder = $(round(resultados[:poder_sim][idx_max_poder], digits=4))")

println("\n3. RECOMENDAÇÕES:")
println("   - Para detectar efeitos importantes: use α maior (ex: 0.10)")
println("   - Para evitar falsos positivos: use α menor (ex: 0.01)")
println("   - α = 0.05 é um compromisso razoável na maioria dos casos")

# Tabela resumo
println("\n4. TABELA RESUMO:")
println("α\t\tErro I\t\tErro II\t\tPoder")
println(repeat("-", 50))
for i in 1:length(valores_α)
    @printf("%.3f\t\t%.4f\t\t%.4f\t\t%.4f\n", 
            resultados[:alpha][i],
            resultados[:erro_tipo_I_sim][i], 
            resultados[:erro_tipo_II_sim][i],
            resultados[:poder_sim][i])
end

println("\n" * repeat("=", 70))
println("EXPERIMENTO CONCLUÍDO!")