using Distributions, Plots, StatsBase, Random
using Printf

# Configurando seed para reprodutibilidade
Random.seed!(123)

println("=== DEMONSTRAÇÃO DE ERROS TIPO I E TIPO II ===")
println("Cenário: Eficiência de uma nova recepcionista de cartório")
println("H₀: A nova recepcionista NÃO é mais eficiente (μ = 50 ligações/dia)")
println("H₁: A nova recepcionista É mais eficiente (μ > 50 ligações/dia)")
println()

# Parâmetros do experimento
μ₀ = 50         # Média sob H₀ (recepcionista padrão: 50 ligações/dia)
σ = 8           # Desvio padrão populacional (conhecido)
n = 25          # Tamanho da amostra (25 dias de observação)
α = 0.05        # Nível de significância
μ₁ = 58         # Média real quando H₁ é verdadeira (nova recepcionista mais eficiente)

# Calculando valores críticos
z_crítico = quantile(Normal(), 1 - α)
x_crítico = μ₀ + z_crítico * (σ/√n)

println("Parâmetros do teste:")
println("• Tamanho da amostra: $n dias de observação")
println("• Nível de significância: $α")
println("• Valor crítico: $(round(x_crítico, digits=1)) ligações/dia")
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

# Função para simular Erro Tipo I
function simular_erro_tipo_I(n_sim, μ₀, σ, n, α)
    contador_erros = 0
    amostras_erro = Float64[]
    
    for i in 1:n_sim
        # Gerando amostra quando H₀ é verdadeira (recepcionista padrão: 50 ligações/dia)
        amostra = rand(Normal(μ₀, σ), n)
        resultado = teste_hipotese(amostra, μ₀, σ, n, α)
        
        if resultado.rejeita
            contador_erros += 1
            if length(amostras_erro) < 100  # Guardando algumas amostras
                push!(amostras_erro, resultado.x_bar)
            end
        end
    end
    
    return contador_erros, amostras_erro
end

# Função para simular Erro Tipo II
function simular_erro_tipo_II(n_sim, μ₀, μ₁, σ, n, α)
    contador_erros = 0
    amostras_erro = Float64[]
    
    for i in 1:n_sim
        # Gerando amostra quando H₁ é verdadeira (nova recepcionista: 58 ligações/dia)
        amostra = rand(Normal(μ₁, σ), n)
        resultado = teste_hipotese(amostra, μ₀, σ, n, α)
        
        if !resultado.rejeita
            contador_erros += 1
            if length(amostras_erro) < 100
                push!(amostras_erro, resultado.x_bar)
            end
        end
    end
    
    return contador_erros, amostras_erro
end

# ERRO TIPO I: H₀ é verdadeira, mas rejeitamos H₀
println("=== SIMULAÇÃO DO ERRO TIPO I ===")
erro_tipo_I, amostras_tipo_I = simular_erro_tipo_I(n_simulações, μ₀, σ, n, α)

taxa_erro_I = erro_tipo_I / n_simulações
println("Erros Tipo I observados: $erro_tipo_I de $n_simulações")
println("Taxa de Erro Tipo I: $(round(taxa_erro_I, digits=4)) (esperado ≈ $α)")
println()

# ERRO TIPO II: H₁ é verdadeira, mas não rejeitamos H₀
println("=== SIMULAÇÃO DO ERRO TIPO II ===")
erro_tipo_II, amostras_tipo_II = simular_erro_tipo_II(n_simulações, μ₀, μ₁, σ, n, α)

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
x_range = 35:0.1:70
dist_h0 = Normal(μ₀, σ/√n)
dist_h1 = Normal(μ₁, σ/√n)

# Plotando as distribuições
plot!(x_range, pdf.(dist_h0, x_range), 
      label="H₀: μ = $μ₀ ligações/dia", linewidth=3, color=:blue, alpha=0.8)
plot!(x_range, pdf.(dist_h1, x_range), 
      label="H₁: μ = $μ₁ ligações/dia", linewidth=3, color=:red, alpha=0.8)

# Região crítica (Erro Tipo I)
x_crítica = x_crítico:0.1:70
y_crítica = pdf.(dist_h0, x_crítica)
plot!(x_crítica, y_crítica, fillrange=0, alpha=0.3, color=:red, 
      label="Erro Tipo I (α = $α)")

# Região de Erro Tipo II
x_beta = 35:0.1:x_crítico
y_beta = pdf.(dist_h1, x_beta)
plot!(x_beta, y_beta, fillrange=0, alpha=0.3, color=:orange, 
      label="Erro Tipo II (β = $(round(taxa_erro_II, digits=3)))")

# Linha crítica
vline!([x_crítico], color=:black, linestyle=:dash, linewidth=2, 
       label="Valor Crítico = $(round(x_crítico, digits=1)) ligações")

title!("Performance da Recepcionista - Erros Tipo I e II")
xlabel!("Média de Ligações por Dia")
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
       label="H₀: μ = $μ₀ ligações/dia")
vline!([μ₁], color=:red, linestyle=:dot, linewidth=2, 
       label="H₁: μ = $μ₁ ligações/dia")

title!("Distribuição das Médias Diárias dos Erros")
xlabel!("Média de Ligações por Dia")
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
println("  → Concluir que a nova recepcionista é mais eficiente quando NÃO é")
println("  → Taxa observada: $(round(taxa_erro_I*100, digits=2))% (próxima aos 5% esperados)")
println()
println("• Erro Tipo II (β): Probabilidade de não rejeitar H₀ quando H₁ é verdadeira")
println("  → Concluir que a nova recepcionista NÃO é mais eficiente quando É mais eficiente")
println("  → Taxa observada: $(round(taxa_erro_II*100, digits=2))%")
println()
println("• Poder do Teste (1-β): Probabilidade de detectar melhoria quando ela existe")
println("  → $(round(poder*100, digits=2))% de chance de detectar que a nova recepcionista é mais eficiente")
println()
println("EXEMPLO PRÁTICO:")
exemplo_amostra = rand(Normal(μ₁, σ), n)
resultado_exemplo = teste_hipotese(exemplo_amostra, μ₀, σ, n, α)
println("Em 25 dias de observação com média de $(round(resultado_exemplo.x_bar, digits=1)) ligações/dia:")
println("• Z-estatística: $(round(resultado_exemplo.z_stat, digits=3))")
println("• P-valor: $(round(resultado_exemplo.p_valor, digits=4))")
if resultado_exemplo.rejeita
    println("• Decisão: REJEITAR H₀ - A nova recepcionista é mais eficiente!")
    println("• Ação: Contratar definitivamente a nova recepcionista")
else
    println("• Decisão: NÃO REJEITAR H₀ - Não há evidência suficiente de melhoria")
    println("• Ação: Manter a recepcionista atual ou continuar testando")
end