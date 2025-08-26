using Distributions, Plots, StatsBase, Random
using Printf

# Configurando seed para reprodutibilidade
Random.seed!(123)

println("=== DEMONSTRAÇÃO DE ERROS TIPO I E TIPO II ===")
println("Cenário: Teste de eficácia de um novo medicamento")
println("H₀: O medicamento NÃO é eficaz (μ = 100)")
println("H₁: O medicamento É eficaz (μ > 100)")
println()

# Parâmetros do experimento
μ₀ = 100        # Média sob H₀ (medicamento ineficaz)
σ = 15          # Desvio padrão populacional (conhecido)
n = 30          # Tamanho da amostra
α = 0.05        # Nível de significância
μ₁ = 110        # Média real quando H₁ é verdadeira

# Calculando valores críticos
z_crítico = quantile(Normal(), 1 - α)
x_crítico = μ₀ + z_crítico * (σ/√n)

println("Parâmetros do teste:")
println("• Tamanho da amostra: $n")
println("• Nível de significância: $α")
println("• Valor crítico: $(round(x_crítico, digits=2))")
println("• Z crítico: $(round(z_crítico, digits=3))")
println()

# Função para realizar teste de hipótese
function teste_hipotese(amostra, μ₀, σ, n, α)
    x_bar = mean(amostra)
    z_estatística = (x_bar - μ₀) / (σ/√n)
    p_valor = 1 - cdf(Normal(), z_estatística)
    rejeita_h0 = p_valor < α
    
    return (x_bar=x_bar, z_stat=z_estatística, p_valor=p_valor, rejeita=rejeita_h0)
end

# SIMULAÇÃO DE ERROS TIPO I E TIPO II
n_simulações = 10000

# ERRO TIPO I: H₀ é verdadeira, mas rejeitamos H₀
println("=== SIMULAÇÃO DO ERRO TIPO I ===")
global erro_tipo_I = 0
global amostras_tipo_I = []

for i in 1:n_simulações
    # Gerando amostra quando H₀ é verdadeira (μ = 100)
    amostra = rand(Normal(μ₀, σ), n)
    resultado = teste_hipotese(amostra, μ₀, σ, n, α)
    
    if resultado.rejeita
        global erro_tipo_I += 1
        if length(amostras_tipo_I) < 100  # Guardando algumas amostras
            push!(amostras_tipo_I, resultado.x_bar)
        end
    end
end

taxa_erro_I = erro_tipo_I / n_simulações
println("Erros Tipo I observados: $erro_tipo_I de $n_simulações")
println("Taxa de Erro Tipo I: $(round(taxa_erro_I, digits=4)) (esperado ≈ $α)")
println()

# ERRO TIPO II: H₁ é verdadeira, mas não rejeitamos H₀
println("=== SIMULAÇÃO DO ERRO TIPO II ===")
global erro_tipo_II = 0
global amostras_tipo_II = []

for i in 1:n_simulações
    # Gerando amostra quando H₁ é verdadeira (μ = 110)
    amostra = rand(Normal(μ₁, σ), n)
    resultado = teste_hipotese(amostra, μ₀, σ, n, α)
    
    if !resultado.rejeita
        global erro_tipo_II += 1
        if length(amostras_tipo_II) < 100
            push!(amostras_tipo_II, resultado.x_bar)
        end
    end
end

taxa_erro_II = erro_tipo_II / n_simulações
poder = 1 - taxa_erro_II

println("Erros Tipo II observados: $erro_tipo_II de $n_simulações")
println("Taxa de Erro Tipo II (β): $(round(taxa_erro_II, digits=4))")
println("Poder do teste (1-β): $(round(poder, digits=4))")
println()

# CRIANDO OS PLOTS
gr()

# Plot 1: Distribuições e região crítica
p1 = plot(size=(800, 500), dpi=150)

# Criando as distribuições
x_range = 85:0.1:125
dist_h0 = Normal(μ₀, σ/√n)
dist_h1 = Normal(μ₁, σ/√n)

# Plotando as distribuições
plot!(x_range, pdf.(dist_h0, x_range), 
      label="H₀: μ = $μ₀", linewidth=3, color=:blue, alpha=0.8)
plot!(x_range, pdf.(dist_h1, x_range), 
      label="H₁: μ = $μ₁", linewidth=3, color=:red, alpha=0.8)

# Região crítica (Erro Tipo I)
x_crítica = x_crítico:0.1:125
y_crítica = pdf.(dist_h0, x_crítica)
plot!(x_crítica, y_crítica, fillrange=0, alpha=0.3, color=:red, 
      label="Erro Tipo I (α = $α)")

# Região de Erro Tipo II
x_beta = 85:0.1:x_crítico
y_beta = pdf.(dist_h1, x_beta)
plot!(x_beta, y_beta, fillrange=0, alpha=0.3, color=:orange, 
      label="Erro Tipo II (β = $(round(taxa_erro_II, digits=3)))")

# Linha crítica
vline!([x_crítico], color=:black, linestyle=:dash, linewidth=2, 
       label="Valor Crítico = $(round(x_crítico, digits=1))")

title!("Distribuições sob H₀ e H₁ - Erros Tipo I e II")
xlabel!("Média Amostral")
ylabel!("Densidade")
plot!(legend=:topright)

# Plot 2: Simulações dos erros
p2 = plot(size=(800, 400), dpi=150)

if length(amostras_tipo_I) > 0
    histogram!(amostras_tipo_I, bins=20, alpha=0.6, color=:red, 
               label="Amostras com Erro Tipo I", normalize=:probability)
end

if length(amostras_tipo_II) > 0
    histogram!(amostras_tipo_II, bins=20, alpha=0.6, color=:orange, 
               label="Amostras com Erro Tipo II", normalize=:probability)
end

vline!([x_crítico], color=:black, linestyle=:dash, linewidth=2, 
       label="Valor Crítico")
vline!([μ₀], color=:blue, linestyle=:dot, linewidth=2, 
       label="H₀: μ = $μ₀")
vline!([μ₁], color=:red, linestyle=:dot, linewidth=2, 
       label="H₁: μ = $μ₁")

title!("Distribuição das Médias Amostrais dos Erros")
xlabel!("Média Amostral")
ylabel!("Probabilidade")

# Combinando os plots
plot_final = plot(p1, p2, layout=(2,1), size=(800, 800))
display(plot_final)

# TABELA RESUMO
println("=== RESUMO DOS RESULTADOS ===")
println("┌─────────────────────────────────────────────┐")
println("│              MATRIZ DE CONFUSÃO             │")
println("├─────────────────────────────────────────────┤")
println("│           │    H₀ Verdadeira │ H₁ Verdadeira │")
println("├─────────────────────────────────────────────┤")
printf("│ Não Rejeitar H₀ │ ✓ Correto (%.3f) │ ✗ Erro II (%.3f) │\n", 
       1-taxa_erro_I, taxa_erro_II)
printf("│ Rejeitar H₀     │ ✗ Erro I (%.3f)  │ ✓ Poder (%.3f)   │\n", 
       taxa_erro_I, poder)
println("└─────────────────────────────────────────────┘")
println()

println("INTERPRETAÇÃO:")
println("• Erro Tipo I (α): Probabilidade de rejeitar H₀ quando ela é verdadeira")
println("  → Concluir que o medicamento é eficaz quando NÃO é")
println("  → Taxa observada: $(round(taxa_erro_I*100, digits=2))% (próxima aos 5% esperados)")
println()
println("• Erro Tipo II (β): Probabilidade de não rejeitar H₀ quando H₁ é verdadeira")
println("  → Concluir que o medicamento NÃO é eficaz quando É eficaz")
println("  → Taxa observada: $(round(taxa_erro_II*100, digits=2))%")
println()
println("• Poder do Teste (1-β): Probabilidade de detectar um efeito quando ele existe")
println("  → $(round(poder*100, digits=2))% de chance de detectar que o medicamento é eficaz quando realmente é")
println()
println("EXEMPLO PRÁTICO:")
exemplo_amostra = rand(Normal(μ₁, σ), n)
resultado_exemplo = teste_hipotese(exemplo_amostra, μ₀, σ, n, α)
println("Em uma amostra real com média $(round(resultado_exemplo.x_bar, digits=2)):")
println("• Z-estatística: $(round(resultado_exemplo.z_stat, digits=3))")
println("• P-valor: $(round(resultado_exemplo.p_valor, digits=4))")
if resultado_exemplo.rejeita
    println("• Decisão: REJEITAR H₀ - O medicamento parece ser eficaz!")
else
    println("• Decisão: NÃO REJEITAR H₀ - Não há evidência suficiente de eficácia")
end