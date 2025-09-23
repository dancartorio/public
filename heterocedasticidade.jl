using Plots, Random, Statistics, Distributions

# Configurar semente para reprodutibilidade
Random.seed!(456)

# Número de observações
n = 100
x = range(1, 10, length=n)

# Função para gerar dados com diferentes padrões de heterocedasticidade
function generate_heteroscedastic_data(x, variance_pattern)
    n = length(x)
    y = 2 .+ 0.5 .* x  # Relação linear básica
    
    if variance_pattern == "hetero_linear"
        # Heterocedasticidade linear: σᵢ² = σ²Xᵢ
        σ² = 0.15 .* x
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 0.15X"
        
    elseif variance_pattern == "hetero_quadratic"
        # Heterocedasticidade quadrática: σᵢ² = α₁Xᵢ + α₂Xᵢ²
        σ² = 0.05 .* x .+ 0.01 .* x.^2
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 0.05X + 0.01X²"
        
    elseif variance_pattern == "hetero_quadratic_decrease"
        # Heterocedasticidade quadrática decrescente: σᵢ² = σ²/Xᵢ²
        σ² = 3.0 ./ x.^1.5
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 3.0/X^1.5"
        
    elseif variance_pattern == "hetero_exponential"
        # Heterocedasticidade exponencial: σᵢ² = σ²exp(αXᵢ)
        σ² = 0.05 .* exp.(0.25 .* x)
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 0.05exp(0.25X)"
        
    elseif variance_pattern == "hetero_log"
        # Heterocedasticidade logarítmica: σᵢ² = σ²log(Xᵢ)
        σ² = 0.3 .* log.(x)
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 0.3ln(X)"
        
    elseif variance_pattern == "hetero_arch"
        # Heterocedasticidade ARCH: σᵢ² depende dos resíduos passados
        σ² = ones(n)
        ε = zeros(n)
        ε[1] = rand(Normal(0, 0.8))
        σ²[1] = 0.4
        
        for i in 2:n
            σ²[i] = 0.2 + 0.5 * ε[i-1]^2  # ARCH(1)
            ε[i] = rand(Normal(0, sqrt(σ²[i])))
        end
        formula = "σ² = 0.2 + 0.5ε²ₜ₋₁"
        
    elseif variance_pattern == "hetero_multiplicative"
        # Heterocedasticidade multiplicativa: σᵢ² = σ²|Xᵢ - c|
        σ² = 0.2 .* abs.(x .- 5.5) .+ 0.1
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 0.2|X - 5.5| + 0.1"
        
    elseif variance_pattern == "hetero_threshold"
        # Heterocedasticidade com threshold: diferentes variâncias por regime
        threshold = 5.5
        σ² = ifelse.(x .< threshold, 0.3, 1.8)
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = {0.3 se X<5.5; 1.8 c.c.}"
        
    elseif variance_pattern == "hetero_periodic"
        # Heterocedasticidade periódica: σᵢ² = σ²[1 + αsin(βXᵢ)]
        σ² = 0.4 .* (1 .+ 0.7 .* sin.(π .* x / 2.5))
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 0.4[1 + 0.7sin(πX/2.5)]"
        
    elseif variance_pattern == "hetero_grouped"
        # Heterocedasticidade agrupada: diferentes variâncias por grupos
        groups = Int.(ceil.(x / 3.33))  # 3 grupos
        group_vars = [0.2, 0.8, 2.2]
        σ² = [group_vars[min(g, 3)] for g in groups]
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = {0.2, 0.8, 2.2} por grupo"
        
    elseif variance_pattern == "hetero_fan"
        # Heterocedasticidade em leque: cresce rapidamente
        σ² = 0.03 .* x.^1.8
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 0.03X^1.8"
        
    elseif variance_pattern == "hetero_extreme"
        # Heterocedasticidade extrema
        σ² = 0.02 .* x.^2.5
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 0.02X^2.5"
    end
    
    y_observed = y .+ ε
    return y_observed, σ², formula
end

# Padrões de heterocedasticidade
hetero_patterns = [
    "hetero_linear", "hetero_quadratic", "hetero_quadratic_decrease", 
    "hetero_exponential", "hetero_log", "hetero_arch",
    "hetero_multiplicative", "hetero_threshold", "hetero_periodic", 
    "hetero_grouped", "hetero_fan", "hetero_extreme"
]

hetero_titles = [
    "Linear",
    "Quadrática Crescente",
    "Quadrática Decrescente",
    "Exponencial",
    "Logarítmica", 
    "ARCH",
    "Multiplicativa",
    "Threshold", 
    "Periódica",
    "Por Grupos",
    "Em Leque",
    "Extrema"
]

# Criar plots para heterocedasticidade
hetero_plots = []

for (i, pattern) in enumerate(hetero_patterns)
    y, σ², formula = generate_heteroscedastic_data(x, pattern)
    
    p = scatter(x, y, 
               alpha=0.7, 
               color=:darkred, 
               markersize=4,
               label="Dados",
               title=hetero_titles[i],
               xlabel="X",
               ylabel="Y",
               titlefontsize=10,
               labelfontsize=8)
    
    # Linha de regressão
    y_reg = 2 .+ 0.5 .* x
    plot!(p, x, y_reg, 
          color=:blue, 
          linewidth=2, 
          linestyle=:dash,
          label="E[Y|X]")
    
    # Banda de confiança (vermelha para heterocedasticidade)
    upper_band = y_reg .+ 2 .* sqrt.(σ²)
    lower_band = y_reg .- 2 .* sqrt.(σ²)
    plot!(p, x, upper_band, 
          fillrange=lower_band, 
          alpha=0.25, 
          color=:lightpink, 
          label="±2σ(X)",
          linealpha=0)
    
    # Adicionar fórmula no plot
    annotate!(p, 2.5, maximum(y) - 0.8, text(formula, 8, :left, :darkblue))
    
    push!(hetero_plots, p)
end

# Plot final da heterocedasticidade
hetero_final = plot(hetero_plots...,
                    layout=(3,4), 
                    size=(1200, 900),
                    plot_title="TIPOS DE HETEROCEDASTICIDADE",
                    titlefontsize=16)

display(hetero_final)

# Teste de Breusch-Pagan para heterocedasticidade
function breusch_pagan_test(x, residuals)
    n = length(residuals)
    e_squared = residuals.^2
    X = [ones(n) x]
    β = (X' * X) \ (X' * e_squared)
    e_squared_pred = X * β
    ss_total = sum((e_squared .- mean(e_squared)).^2)
    ss_residual = sum((e_squared .- e_squared_pred).^2)
    r_squared = 1 - ss_residual / ss_total
    lm_statistic = n * r_squared
    return lm_statistic, r_squared
end

# Função para medir grau de heterocedasticidade
function heteroscedasticity_measure(σ²)
    cv = std(σ²) / mean(σ²)  # Coeficiente de variação das variâncias
    return cv  # Quanto maior, mais heterocedástico
end

# Análise quantitativa dos tipos de heterocedasticidade
println("\n" * "="^80)
println("ANÁLISE QUANTITATIVA DOS TIPOS DE HETEROCEDASTICIDADE")
println("="^80)

for (i, pattern) in enumerate(hetero_patterns)
    y, σ², formula = generate_heteroscedastic_data(x, pattern)
    
    # Ajustar regressão OLS
    X_reg = [ones(n) collect(x)]
    β_ols = (X_reg' * X_reg) \ (X_reg' * y)
    residuals = y .- X_reg * β_ols
    
    # Testes
    test_stat, r2 = breusch_pagan_test(collect(x), residuals)
    hetero_index = heteroscedasticity_measure(σ²)
    
    # Classificação do grau de heterocedasticidade
    if hetero_index > 2.0
        classification = "🔴 ALTAMENTE HETEROCEDÁSTICO"
    elseif hetero_index > 1.0
        classification = "🟠 MODERADAMENTE HETEROCEDÁSTICO"  
    elseif hetero_index > 0.5
        classification = "🟡 LEVEMENTE HETEROCEDÁSTICO"
    else
        classification = "🟢 QUASE-HOMOCEDÁSTICO"
    end
    
    # Resultado do teste
    test_result = test_stat > 3.84 ? "REJEITA H₀" : "NÃO REJEITA H₀"
    
    println("$(i+1). $(hetero_titles[i]):")
    println("    Fórmula: $formula")
    println("    Variância média: $(round(mean(σ²), digits=3))")
    println("    Coef. variação σ²: $(round(hetero_index, digits=3))")
    println("    Teste BP: $(round(test_stat, digits=2)) - $test_result")
    println("    Classificação: $classification")
    println()
end

println("="^80)
println("CARACTERÍSTICAS DA HETEROCEDASTICIDADE")
println("="^80)
println("⚠️  DEFINIÇÃO: Var(εᵢ|Xᵢ) = σᵢ² ≠ constante")
println("📉 PROBLEMA: OLS perde eficiência (não é mais BLUE)")
println("❌ CONSEQUÊNCIA: Erros-padrão incorretos, testes inválidos")
println("🔍 DETECÇÃO: Breusch-Pagan, White, plots dos resíduos")
println("💊 SOLUÇÕES: Erros robustos, GLS/WLS, transformações")
println("🎨 COR DA BANDA: VERMELHA indica heterocedasticidade")
println("📊 VALOR CRÍTICO: χ²(1, 0.05) = 3.84 para teste BP")
println("="^80)

println("\n📋 APLICAÇÕES PRÁTICAS DOS TIPOS:")
println("• LINEAR: Dados de renda, tamanho de empresas")
println("• QUADRÁTICA: Aceleração de processos econômicos") 
println("• EXPONENCIAL: Crescimento populacional, inflação")
println("• LOGARÍTMICA: Retornos decrescentes")
println("• ARCH: Volatilidade em séries financeiras")
println("• THRESHOLD: Quebras estruturais, mudanças de regime")
println("• PERIÓDICA: Sazonalidade, ciclos econômicos")
println("• AGRUPADA: Diferenças por setor, região, período")
println("="^80)