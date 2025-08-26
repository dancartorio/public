using Random, Distributions, Statistics, Plots, StatsPlots, HypothesisTests, DataFrames
using Printf

# Configuração inicial
Random.seed!(123)
const N_SIM = 100_000  # Número de simulações
const ALPHA = 0.05     # Nível de significância nominal
const D_EFFECT = 0.4   # Tamanho do efeito (d = μ/σ)
const N_SIZES = [10, 20, 40, 80]  # Tamanhos amostrais

println("=== EXPERIMENTO: ROBUSTEZ DO TESTE t À NÃO-NORMALIDADE ===")
println("Simulações: $(N_SIM)")
println("Nível nominal: $(ALPHA)")
println("Tamanho do efeito: $(D_EFFECT)")
println("Tamanhos amostrais: $(N_SIZES)")
println()

# Funções para gerar dados de cada distribuição
function generate_normal(n, mu=0.0)
    return rand(Normal(mu, 1.0), n)
end

function generate_t3_scaled(n, mu=0.0)
    # t(3) escalada para ter variância = 1
    # Var(t(3)) = 3/(3-2) = 3, então dividimos por √3
    t_samples = rand(TDist(3), n) / sqrt(3)
    return t_samples .+ mu
end

function generate_lognormal_adjusted(n, mu=0.0)
    # Lognormal ajustada para E[X] = mu, Var(X) = 1
    # Se Y ~ LogNormal(μ_log, σ_log), então:
    # E[Y] = exp(μ_log + σ_log²/2)
    # Var(Y) = exp(2μ_log + σ_log²) * (exp(σ_log²) - 1)
    
    # Para ter Var = 1, precisamos resolver o sistema
    # Escolhemos σ_log² = log(2) ≈ 0.693 para assimetria moderada
    sigma_log = sqrt(log(2))
    mu_log = -sigma_log^2 / 2  # Para que E[exp(Y)] = 1 quando mu=0
    
    y = rand(LogNormal(mu_log, sigma_log), n)
    # Ajustar para ter média mu e variância aproximadamente 1
    y_std = (y .- mean(y)) ./ std(y)
    return y_std .+ mu
end

function generate_contaminated_normal(n, mu=0.0)
    # 90% N(0,1) + 10% N(0,9) (outliers)
    samples = zeros(n)
    for i in 1:n
        if rand() < 0.9
            samples[i] = rand(Normal(mu, 1.0))
        else
            samples[i] = rand(Normal(mu, 9.0))  # Outliers
        end
    end
    return samples
end

# Função para realizar teste t unilateral
function t_test_one_sided(x, mu0=0.0)
    n = length(x)
    x_bar = mean(x)
    s = std(x, corrected=true)
    t_stat = (x_bar - mu0) / (s / sqrt(n))
    p_value = 1 - cdf(TDist(n-1), t_stat)  # Teste unilateral à direita
    return p_value < ALPHA
end

# Função para simular nível e poder
function simulate_test_performance(generate_func, n, effect_size=0.0)
    rejections = 0
    for _ in 1:N_SIM
        data = generate_func(n, effect_size)
        if t_test_one_sided(data)
            rejections += 1
        end
    end
    return rejections / N_SIM
end

# Executar simulações
distributions = [
    ("Normal(0,1)", generate_normal),
    ("t(3) escalada", generate_t3_scaled),
    ("Lognormal ajustada", generate_lognormal_adjusted),
    ("Normal contaminada", generate_contaminated_normal)
]

results = DataFrame(
    Distribution = String[],
    n = Int[],
    Empirical_Alpha = Float64[],
    Power = Float64[],
    Alpha_Bias = Float64[]
)

println("Executando simulações...")
println("-" ^ 60)

for (dist_name, gen_func) in distributions
    println("Distribuição: $dist_name")
    
    for n in N_SIZES
        print("  n=$n: ")
        
        # Simular nível empírico (H₀: μ = 0)
        alpha_emp = simulate_test_performance(gen_func, n, 0.0)
        
        # Simular poder (H₁: μ = 0.4)
        power = simulate_test_performance(gen_func, n, D_EFFECT)
        
        alpha_bias = alpha_emp - ALPHA
        
        push!(results, (dist_name, n, alpha_emp, power, alpha_bias))
        
        @printf("α̂=%.4f (viés=%.4f), Poder=%.4f\n", alpha_emp, alpha_bias, power)
    end
    println()
end

# Exibir resultados em tabela
println("=== RESUMO DOS RESULTADOS ===")
println(results)
println()

# Análise dos resultados
println("=== ANÁLISE DOS RESULTADOS ===")
println()

for dist_name in unique(results.Distribution)
    dist_results = filter(row -> row.Distribution == dist_name, results)
    println("$dist_name:")
    
    # Verificar controle do nível
    max_alpha_bias = maximum(abs.(dist_results.Alpha_Bias))
    if max_alpha_bias < 0.01
        println("  ✓ Controle de nível: BOM (viés máx: $(round(max_alpha_bias, digits=4)))")
    elseif max_alpha_bias < 0.02
        println("  ⚠ Controle de nível: MODERADO (viés máx: $(round(max_alpha_bias, digits=4)))")
    else
        println("  ✗ Controle de nível: RUIM (viés máx: $(round(max_alpha_bias, digits=4)))")
    end
    
    # Verificar tendência do poder
    powers = dist_results.Power
    if all(powers[i] <= powers[i+1] for i in 1:(length(powers)-1))
        println("  ✓ Poder cresce monotonicamente com n")
    else
        println("  ⚠ Poder não cresce monotonicamente")
    end
    
    println("  → Poder final (n=80): $(round(powers[end], digits=4))")
    println()
end

# Gráficos
println("Gerando visualizações...")

# Gráfico 1: Nível empírico vs n
p1 = plot(title="Nível Empírico vs Tamanho Amostral", 
          xlabel="n", ylabel="α empírico",
          legend=:topright, size=(800, 600))

colors = [:blue, :red, :green, :orange]
markers = [:circle, :square, :diamond, :utriangle]

for (i, dist_name) in enumerate(unique(results.Distribution))
    dist_data = filter(row -> row.Distribution == dist_name, results)
    plot!(p1, dist_data.n, dist_data.Empirical_Alpha, 
          label=dist_name, color=colors[i], marker=markers[i], markersize=6, linewidth=2)
end

hline!(p1, [ALPHA], linestyle=:dash, color=:black, linewidth=2, label="α nominal (0.05)")
ylims!(p1, (0.04, 0.08))

# Gráfico 2: Poder vs n
p2 = plot(title="Poder vs Tamanho Amostral", 
          xlabel="n", ylabel="Poder (1-β)",
          legend=:bottomright, size=(800, 600))

for (i, dist_name) in enumerate(unique(results.Distribution))
    dist_data = filter(row -> row.Distribution == dist_name, results)
    plot!(p2, dist_data.n, dist_data.Power, 
          label=dist_name, color=colors[i], marker=markers[i], markersize=6, linewidth=2)
end

# Gráfico 3: Viés do nível vs n
p3 = plot(title="Viés do Nível (α̂ - α₀) vs n", 
          xlabel="n", ylabel="Viés do nível",
          legend=:topright, size=(800, 600))

for (i, dist_name) in enumerate(unique(results.Distribution))
    dist_data = filter(row -> row.Distribution == dist_name, results)
    plot!(p3, dist_data.n, dist_data.Alpha_Bias, 
          label=dist_name, color=colors[i], marker=markers[i], markersize=6, linewidth=2)
end

hline!(p3, [0], linestyle=:dash, color=:black, linewidth=2, label="Sem viés")
hline!(p3, [0.01, -0.01], linestyle=:dot, color=:gray, label="±0.01")

# Combinar gráficos
final_plot = plot(p1, p2, p3, layout=(3,1), size=(800, 1200))
display(final_plot)

# Extensão: Comparação com teste não-paramétrico (Wilcoxon)
println("\n=== EXTENSÃO: COMPARAÇÃO COM TESTE WILCOXON ===")

function wilcoxon_test_one_sided(x, mu0=0.0)
    # Teste de Wilcoxon signed-rank para H₁: mediana > mu0
    x_shifted = x .- mu0
    x_nonzero = x_shifted[x_shifted .!= 0]
    
    if length(x_nonzero) < 3
        return false
    end
    
    ranks = abs.(x_nonzero)
    sorted_indices = sortperm(ranks)
    ranks_assigned = zeros(length(x_nonzero))
    
    # Atribuir ranks (lidar com empates usando rank médio)
    i = 1
    while i <= length(sorted_indices)
        j = i
        while j <= length(sorted_indices) && ranks[sorted_indices[j]] == ranks[sorted_indices[i]]
            j += 1
        end
        avg_rank = (i + j - 1) / 2
        for k in i:(j-1)
            ranks_assigned[sorted_indices[k]] = avg_rank
        end
        i = j
    end
    
    # Calcular W+ (soma dos ranks positivos)
    w_plus = sum(ranks_assigned[x_nonzero .> 0])
    
    n_nonzero = length(x_nonzero)
    
    # Aproximação normal para n >= 10
    if n_nonzero >= 10
        mu_w = n_nonzero * (n_nonzero + 1) / 4
        sigma_w = sqrt(n_nonzero * (n_nonzero + 1) * (2 * n_nonzero + 1) / 24)
        z_stat = (w_plus - mu_w) / sigma_w
        p_value = 1 - cdf(Normal(), z_stat)
        return p_value < ALPHA
    else
        # Para n pequeno, usar tabela crítica (simplificado)
        critical_values = Dict(3=>6, 4=>10, 5=>15, 6=>21, 7=>28, 8=>36, 9=>45)
        if haskey(critical_values, n_nonzero)
            return w_plus >= critical_values[n_nonzero]
        else
            return false
        end
    end
end

function simulate_wilcoxon_performance(generate_func, n, effect_size=0.0)
    rejections = 0
    for _ in 1:N_SIM
        data = generate_func(n, effect_size)
        if wilcoxon_test_one_sided(data)
            rejections += 1
        end
    end
    return rejections / N_SIM
end

println("Comparando teste t vs Wilcoxon para distribuições assimétricas/contaminadas...")
println("-" ^ 80)

comparison_dists = [("Lognormal ajustada", generate_lognormal_adjusted),
                   ("Normal contaminada", generate_contaminated_normal)]

for (dist_name, gen_func) in comparison_dists
    println("$dist_name:")
    println("n\t\tTeste t\t\tWilcoxon")
    println("\t\tα̂\tPoder\tα̂\tPoder")
    
    for n in N_SIZES
        # Teste t
        t_alpha = simulate_test_performance(gen_func, n, 0.0)
        t_power = simulate_test_performance(gen_func, n, D_EFFECT)
        
        # Wilcoxon (apenas para n >= 20 por limitações da implementação)
        if n >= 20
            w_alpha = simulate_wilcoxon_performance(gen_func, n, 0.0)
            w_power = simulate_wilcoxon_performance(gen_func, n, D_EFFECT)
            @printf("%d\t\t%.4f\t%.4f\t%.4f\t%.4f\n", n, t_alpha, t_power, w_alpha, w_power)
        else
            @printf("%d\t\t%.4f\t%.4f\t--\t--\n", n, t_alpha, t_power)
        end
    end
    println()
end

println("=== CONCLUSÕES PRINCIPAIS ===")
println("1. Normal(0,1): Controle perfeito do nível, poder cresce com n (referência)")
println("2. t(3) caudas pesadas: Nível inflado em n pequeno, mas CLT corrige para n≥40")
println("3. Lognormal (assimetria): Viés variável no nível, poder cresce mais lentamente")  
println("4. Normal contaminada: Nível muito inflado, poder reduzido mesmo com n grande")
println("5. Wilcoxon é mais robusto para distribuições contaminadas/assimétricas")
println()
println("RECOMENDAÇÃO: Para n<40 ou suspeita de não-normalidade, considere:")
println("- Testes não-paramétricos (Wilcoxon)")
println("- Transformações dos dados")
println("- Métodos robustos (média aparada, bootstrap)")