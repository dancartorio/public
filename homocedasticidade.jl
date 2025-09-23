using Plots, Random, Statistics, Distributions

# Configurar semente para reprodutibilidade
Random.seed!(123)

# Número de observações
n = 100
x = range(1, 10, length=n)

# Função para gerar dados com diferentes padrões de homocedasticidade
function generate_homoscedastic_data(x, variance_pattern)
    n = length(x)
    y = 2 .+ 0.5 .* x  # Relação linear básica
    
    if variance_pattern == "homo_perfect"
        # Homocedasticidade perfeita: variância exatamente constante
        σ² = fill(1.0, n)
        ε = rand(Normal(0, 1), n)
        formula = "σ² = 1.0"
        
    elseif variance_pattern == "homo_low_variance"
        # Homocedasticidade com baixa variância
        σ² = fill(0.3, n)
        ε = rand(Normal(0, sqrt(0.3)), n)
        formula = "σ² = 0.3"
        
    elseif variance_pattern == "homo_high_variance"
        # Homocedasticidade com alta variância
        σ² = fill(3.0, n)
        ε = rand(Normal(0, sqrt(3.0)), n)
        formula = "σ² = 3.0"
        
    elseif variance_pattern == "homo_approximate"
        # Homocedasticidade aproximada: pequenas flutuações aleatórias
        base_var = 1.0
        σ² = base_var .+ 0.05 .* randn(n)  # Flutuações pequenas
        σ² = max.(σ², 0.2)  # Garantir positividade
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² ≈ 1.0 ± 0.05"
        
    elseif variance_pattern == "homo_clustered"
        # Homocedasticidade por clusters: constante dentro de grupos
        group_size = div(n, 4)
        σ² = repeat([1.2, 1.2, 1.2, 1.2], inner=group_size)
        if length(σ²) < n
            σ² = vcat(σ², fill(1.2, n - length(σ²)))
        end
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 1.2 (por grupo)"
        
    elseif variance_pattern == "homo_conditional"
        # Homocedasticidade condicional: constante dado outras variáveis
        z = rand(n) .> 0.5  # Variável categórica
        σ² = fill(1.0, n)  # Mesma variância para ambos grupos
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        y = y .+ 0.8 .* z  # Efeito na média, não na variância
        formula = "σ²|Z = 1.0"
        
    elseif variance_pattern == "homo_zero_variance"
        # Caso limite: variância zero (determinístico)
        σ² = fill(0.001, n)  # Quase zero para visualização
        ε = zeros(n)
        formula = "σ² = 0 (determinístico)"
        
    elseif variance_pattern == "homo_discrete"
        # Homocedasticidade com erro discreto
        σ² = fill(1.0, n)
        ε = rand([-1.2, 0, 1.2], n)  # Erro discreto
        formula = "ε ∈ {-1.2, 0, 1.2}"
        
    elseif variance_pattern == "homo_non_normal"
        # Homocedasticidade com distribuição não-normal
        σ² = fill(1.0, n)
        ε = rand(Uniform(-1.73, 1.73), n)  # Uniforme com var≈1
        formula = "ε ~ Uniforme, σ² = 1.0"
        
    elseif variance_pattern == "quasi_homo"
        # Quase-homocedasticidade: variação mínima
        σ² = 1.0 .+ 0.02 .* sin.(x)  # Variação muito pequena
        ε = [rand(Normal(0, sqrt(σ²[i])), 1)[1] for i in 1:n]
        formula = "σ² = 1.0 + 0.02sin(X)"
    end
    
    y_observed = y .+ ε
    return y_observed, σ², formula
end

# Padrões de homocedasticidade
homo_patterns = [
    "homo_perfect", "homo_low_variance", "homo_high_variance", 
    "homo_approximate", "homo_clustered", "homo_conditional",
    "homo_zero_variance", "homo_discrete", "homo_non_normal", "quasi_homo"
]

homo_titles = [
    "Homocedasticidade Perfeita",
    "Baixa Variância",
    "Alta Variância", 
    "Aproximada",
    "Por Clusters",
    "Condicional",
    "Caso Limite (σ²≈0)",
    "Erro Discreto",
    "Não-Normal",
    "Quase-Homocedástica"
]

# Criar plots para homocedasticidade
homo_plots = []

for (i, pattern) in enumerate(homo_patterns)
    y, σ², formula = generate_homoscedastic_data(x, pattern)
    
    p = scatter(x, y, 
               alpha=0.7, 
               color=:darkgreen, 
               markersize=4,
               label="Dados",
               title=homo_titles[i],
               xlabel="X",
               ylabel="Y",
               titlefontsize=10,
               labelfontsize=8)
    
    # Linha de regressão
    y_reg = 2 .+ 0.5 .* x
    if pattern == "homo_conditional"
        z = rand(n) .> 0.5
        y_reg = 2 .+ 0.5 .* x .+ 0.8 .* z
    end
    
    plot!(p, x, y_reg, 
          color=:blue, 
          linewidth=2, 
          linestyle=:dash,
          label="E[Y|X]")
    
    # Banda de confiança (azul para homocedasticidade)
    if pattern != "homo_zero_variance"
        σ_const = sqrt(mean(σ²))
        upper_band = y_reg .+ 2 * σ_const
        lower_band = y_reg .- 2 * σ_const
        plot!(p, x, upper_band, 
              fillrange=lower_band, 
              alpha=0.25, 
              color=:lightblue, 
              label="±2σ",
              linealpha=0)
    end
    
    # Adicionar fórmula no plot
    annotate!(p, 2.5, maximum(y) - 0.5, text(formula, 9, :left, :red))
    
    push!(homo_plots, p)
end

# Plot final da homocedasticidade
homo_final = plot(homo_plots...,
                  layout=(2,5), 
                  size=(1200, 600),
                  plot_title="TIPOS DE HOMOCEDASTICIDADE",
                  titlefontsize=16)

display(homo_final)

# Função para medir grau de homocedasticidade
function homoscedasticity_measure(σ²)
    cv = std(σ²) / mean(σ²)  # Coeficiente de variação das variâncias
    return 1 / (1 + cv)  # Índice: 1 = perfeitamente homocedástico
end

# Análise quantitativa dos tipos de homocedasticidade
println("\n" * "="^80)
println("ANÁLISE QUANTITATIVA DOS TIPOS DE HOMOCEDASTICIDADE")
println("="^80)

for (i, pattern) in enumerate(homo_patterns)
    y, σ², formula = generate_homoscedastic_data(x, pattern)
    
    mean_var = mean(σ²)
    std_var = std(σ²)
    homo_index = homoscedasticity_measure(σ²)
    
    # Classificação
    if homo_index > 0.98
        classification = "🟢 PERFEITAMENTE HOMOCEDÁSTICO"
    elseif homo_index > 0.90
        classification = "🔵 APROXIMADAMENTE HOMOCEDÁSTICO"  
    elseif homo_index > 0.80
        classification = "🟡 QUASE-HOMOCEDÁSTICO"
    else
        classification = "🟠 LEVEMENTE HETEROCEDÁSTICO"
    end
    
    println("$(i+1). $(homo_titles[i]):")
    println("    Fórmula: $formula")
    println("    Variância média: $(round(mean_var, digits=3))")
    println("    Desvio padrão das variâncias: $(round(std_var, digits=4))")
    println("    Índice de homocedasticidade: $(round(homo_index, digits=4))")
    println("    Classificação: $classification")
    println()
end

println("="^80)
println("CARACTERÍSTICAS DA HOMOCEDASTICIDADE")
println("="^80)
println("🎯 DEFINIÇÃO: Var(εᵢ|Xᵢ) = σ² = constante para todo i")
println("📊 VANTAGEM: OLS é BLUE (Best Linear Unbiased Estimator)")
println("🔍 TESTE: Breusch-Pagan, White, Goldfeld-Quandt")
println("⚡ ROBUSTEZ: Pequenos desvios não afetam muito a eficiência")
println("📈 TIPOS: Perfeita, aproximada, condicional, por grupos")
println("🎨 COR DA BANDA: AZUL indica homocedasticidade")
println("="^80)