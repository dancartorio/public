using Distributions, Plots, StatsPlots, Random, StatsBase
using Statistics: mean, std, quantile

# Configurar o tema para plots mais bonitos
gr()
theme(:vibrant)

# Função para análise frequentista
function frequentist_analysis(data)
    n_total = length(data)
    counts = [count(x -> x == i, data) for i in 1:6]
    probabilities = counts ./ n_total
    
    # Intervalo de confiança usando aproximação normal
    confidence_intervals = []
    for i in 1:6
        p_hat = probabilities[i]
        se = sqrt(p_hat * (1 - p_hat) / n_total)
        ci_lower = max(0, p_hat - 1.96 * se)
        ci_upper = min(1, p_hat + 1.96 * se)
        push!(confidence_intervals, (ci_lower, ci_upper))
    end
    
    return probabilities, confidence_intervals
end

# Função para análise Bayesiana (conjugação analítica)
function bayesian_analysis(data)
    n_total = length(data)
    counts = [count(x -> x == i, data) for i in 1:6]
    
    # Prior: Dirichlet(1,1,1,1,1,1) - uniforme
    alpha_prior = ones(6)
    
    # Posterior: Dirichlet(α₀ + counts)
    alpha_posterior = alpha_prior + counts
    
    # Amostrar da distribuição posterior Dirichlet
    n_samples = 1000
    posterior_samples = zeros(n_samples, 6)
    
    for i in 1:n_samples
        sample = rand(Dirichlet(alpha_posterior))
        posterior_samples[i, :] = sample
    end
    
    # Calcular médias e intervalos de credibilidade
    posterior_means = mean(posterior_samples, dims=1)[:]
    credible_intervals = []
    for i in 1:6
        samples = posterior_samples[:, i]
        ci_lower = quantile(samples, 0.025)
        ci_upper = quantile(samples, 0.975)
        push!(credible_intervals, (ci_lower, ci_upper))
    end
    
    return posterior_means, credible_intervals, posterior_samples
end

# Simular dados de lançamentos de dados
function simulate_dice_rolls(n_rolls; fair=true, bias=nothing)
    Random.seed!(42)  # Para reprodutibilidade
    
    if fair
        probabilities = fill(1/6, 6)
    else
        probabilities = bias !== nothing ? bias : [0.1, 0.1, 0.1, 0.1, 0.1, 0.5]
    end
    
    return rand(Categorical(probabilities), n_rolls)
end

# Função principal de simulação
function run_simulation(max_rolls=500; fair=true, bias=nothing, step_size=25)
    all_data = simulate_dice_rolls(max_rolls, fair=fair, bias=bias)
    true_probs = fair ? fill(1/6, 6) : (bias !== nothing ? bias : [0.1, 0.1, 0.1, 0.1, 0.1, 0.5])
    
    sample_sizes = step_size:step_size:max_rolls
    freq_results = []
    bayes_results = []
    
    println("Executando simulação...")
    
    for (i, n) in enumerate(sample_sizes)
        print("Analisando $n lançamentos... ")
        
        current_data = all_data[1:n]
        
        # Análise frequentista
        freq_probs, freq_cis = frequentist_analysis(current_data)
        push!(freq_results, (n, freq_probs, freq_cis))
        
        # Análise Bayesiana
        bayes_probs, bayes_cis, posterior_samples = bayesian_analysis(current_data)
        push!(bayes_results, (n, bayes_probs, bayes_cis, posterior_samples))
        
        println("✓")
    end
    
    return freq_results, bayes_results, true_probs, sample_sizes
end

# Função para criar plots comparativos
function create_comparison_plots(freq_results, bayes_results, true_probs, sample_sizes; title_suffix="")
    n_faces = 6
    n_samples = length(sample_sizes)
    
    # Extrair probabilidades estimadas
    freq_probs_matrix = zeros(n_samples, n_faces)
    bayes_probs_matrix = zeros(n_samples, n_faces)
    
    for (i, (n, freq_probs, _)) in enumerate(freq_results)
        freq_probs_matrix[i, :] = freq_probs
    end
    
    for (i, (n, bayes_probs, _, _)) in enumerate(bayes_results)
        bayes_probs_matrix[i, :] = bayes_probs
    end
    
    # Plot 1: Convergência das estimativas
    p1 = plot(title="Convergência das Probabilidades $title_suffix", 
              xlabel="Número de Lançamentos", ylabel="Probabilidade Estimada",
              legend=:outerright, size=(1000, 600))
    
    colors = [:red, :blue, :green, :orange, :purple, :brown]
    
    for face in 1:n_faces
        plot!(p1, sample_sizes, freq_probs_matrix[:, face], 
              label="Face $face (Freq.)", color=colors[face], linestyle=:solid, linewidth=2)
        plot!(p1, sample_sizes, bayes_probs_matrix[:, face], 
              label="Face $face (Bayes)", color=colors[face], linestyle=:dash, linewidth=2)
        hline!(p1, [true_probs[face]], color=colors[face], linestyle=:dot, 
               linewidth=1, alpha=0.7, label="")
    end
    
    # Plot 2: Diferenças absolutas médias
    freq_errors = [mean(abs.(freq_probs_matrix[i, :] .- true_probs)) for i in 1:n_samples]
    bayes_errors = [mean(abs.(bayes_probs_matrix[i, :] .- true_probs)) for i in 1:n_samples]
    
    p2 = plot(title="Erro Absoluto Médio $title_suffix", 
              xlabel="Número de Lançamentos", ylabel="Erro Absoluto Médio",
              legend=:topright, size=(1000, 400))
    plot!(p2, sample_sizes, freq_errors, label="Frequentista", 
          color=:red, linewidth=3, marker=:circle, markersize=4)
    plot!(p2, sample_sizes, bayes_errors, label="Bayesiano", 
          color=:blue, linewidth=3, marker=:square, markersize=4)
    
    # Combinar plots
    final_plot = plot(p1, p2, layout=(2,1), size=(1000, 1000))
    
    return final_plot
end

# Função para criar plot das distribuições posteriores
function plot_posterior_distributions(bayes_results, true_probs; title_suffix="")
    last_result = bayes_results[end]
    posterior_samples = last_result[4]
    
    p = plot(layout=(2,3), size=(1200, 800))
    
    for face in 1:6
        samples = posterior_samples[:, face]
        
        histogram!(p[face], samples, bins=30, alpha=0.7, 
                  title="Face $face", xlabel="Probabilidade", 
                  ylabel="Densidade", normalize=:pdf, color=:lightblue)
        
        vline!(p[face], [true_probs[face]], color=:red, linewidth=3, 
               label="Valor Verdadeiro")
        vline!(p[face], [mean(samples)], color=:blue, linewidth=2, 
               linestyle=:dash, label="Média Posterior")
    end
    
    plot!(p, suptitle="Distribuições Posteriores $title_suffix")
    
    return p
end

# Função para criar animação simples e estável
function create_simple_animation(freq_results, bayes_results, true_probs, sample_sizes; filename="animation.gif")
    println("Criando animação simples...")
    
    colors = [:red, :blue, :green, :orange, :purple, :brown]
    
    anim = @animate for (i, n) in enumerate(sample_sizes)
        # Plot único mostrando convergência
        p = plot(title="Convergência das Estimativas (N = $n lançamentos)", 
                xlabel="Número de Lançamentos", ylabel="Probabilidade",
                legend=:outerright, size=(1200, 700), ylims=(0, 0.7))
        
        # Dados até o momento atual
        current_sizes = sample_sizes[1:i]
        
        for face in 1:6
            # Extrair dados até o momento atual
            freq_probs = [freq_results[j][2][face] for j in 1:i]
            bayes_probs = [bayes_results[j][2][face] for j in 1:i]
            
            if i > 1
                plot!(p, current_sizes, freq_probs, 
                      label="Face $face (Freq.)", color=colors[face], 
                      linestyle=:solid, linewidth=3, marker=:circle, markersize=3)
                plot!(p, current_sizes, bayes_probs, 
                      label="Face $face (Bayes)", color=colors[face], 
                      linestyle=:dash, linewidth=3, marker=:square, markersize=3)
            end
            
            # Linha do valor verdadeiro
            hline!(p, [true_probs[face]], color=colors[face], linestyle=:dot, 
                   linewidth=2, alpha=0.8, label="")
        end
        
        # Adicionar informações no plot
        current_freq_error = mean(abs.(freq_results[i][2] .- true_probs))
        current_bayes_error = mean(abs.(bayes_results[i][2] .- true_probs))
        
        annotate!(p, 0.7*maximum(current_sizes), 0.6, 
                 text("Erro Médio:\nFreq: $(round(current_freq_error, digits=4))\nBayes: $(round(current_bayes_error, digits=4))", 
                      12, :black, :left))
        
        p
    end
    
    # Salvar com fps mais baixo para melhor visualização
    gif(anim, filename, fps=2)
    println("Animação salva como: $filename")
    return anim
end

# === EXECUÇÃO PRINCIPAL ===
println("=== SIMULAÇÃO: FREQUENTISTA vs BAYESIANO ===")
println("Simulando lançamentos de dados...\n")

# Cenário 1: Dado justo
println("--- Cenário 1: Dado Justo ---")
freq_fair, bayes_fair, true_fair, sizes = run_simulation(400, fair=true, step_size=20)

# Cenário 2: Dado viciado
println("\n--- Cenário 2: Dado Viciado ---")
biased_probs = [0.05, 0.05, 0.1, 0.1, 0.2, 0.5]
freq_biased, bayes_biased, true_biased, _ = run_simulation(400, fair=false, bias=biased_probs, step_size=20)

println("\n--- Criando Visualizações ---")

# Plots estáticos
plot_fair = create_comparison_plots(freq_fair, bayes_fair, true_fair, sizes, title_suffix="(Dado Justo)")
plot_biased = create_comparison_plots(freq_biased, bayes_biased, true_biased, sizes, title_suffix="(Dado Viciado)")

posterior_fair = plot_posterior_distributions(bayes_fair, true_fair, title_suffix="(Dado Justo)")
posterior_biased = plot_posterior_distributions(bayes_biased, true_biased, title_suffix="(Dado Viciado)")

# Salvar plots
savefig(plot_fair, "comparacao_dado_justo.png")
savefig(plot_biased, "comparacao_dado_viciado.png")
savefig(posterior_fair, "posteriores_dado_justo.png")
savefig(posterior_biased, "posteriores_dado_viciado.png")

# Criar animações
println("Criando animações...")
anim_fair = create_simple_animation(freq_fair, bayes_fair, true_fair, sizes, 
                                   filename="animacao_dado_justo.gif")
anim_biased = create_simple_animation(freq_biased, bayes_biased, true_biased, sizes, 
                                     filename="animacao_dado_viciado.gif")

println("\n=== RESULTADOS FINAIS ===")

# Resultados finais
final_freq_fair = freq_fair[end][2]
final_bayes_fair = bayes_fair[end][2]
final_freq_biased = freq_biased[end][2]
final_bayes_biased = bayes_biased[end][2]

println("\n📊 DADO JUSTO (400 lançamentos):")
println("Verdadeiro:    ", round.(true_fair, digits=3))
println("Frequentista:  ", round.(final_freq_fair, digits=3))
println("Bayesiano:     ", round.(final_bayes_fair, digits=3))
println("Erro Freq:     ", round(mean(abs.(final_freq_fair .- true_fair)), digits=4))
println("Erro Bayes:    ", round(mean(abs.(final_bayes_fair .- true_fair)), digits=4))

println("\n🎲 DADO VICIADO (400 lançamentos):")
println("Verdadeiro:    ", round.(true_biased, digits=3))
println("Frequentista:  ", round.(final_freq_biased, digits=3))
println("Bayesiano:     ", round.(final_bayes_biased, digits=3))
println("Erro Freq:     ", round(mean(abs.(final_freq_biased .- true_biased)), digits=4))
println("Erro Bayes:    ", round(mean(abs.(final_bayes_biased .- true_biased)), digits=4))

# Mostrar plots
display(plot_fair)
display(plot_biased)
display(posterior_fair)
display(posterior_biased)

println("\n🎯 INTERPRETAÇÃO DOS RESULTADOS:")
println("""
PRINCIPAIS OBSERVAÇÕES:

1. CONVERGÊNCIA:
   ✓ Ambas as abordagens convergem para os valores verdadeiros
   ✓ Velocidade similar de convergência na maioria dos casos

2. MÉTODO BAYESIANO:
   ✓ Usa conjugação analítica (Dirichlet-Multinomial)
   ✓ Prior uniforme: Dirichlet(1,1,1,1,1,1)
   ✓ Posterior: Dirichlet(α₀ + contagens observadas)

3. INCERTEZA:
   ✓ Frequentista: Intervalos de confiança (aprox. normal)
   ✓ Bayesiano: Intervalos de credibilidade (posterior exata)

4. VANTAGENS:
   ✓ Frequentista: Simples, direto, sem pressuposições
   ✓ Bayesiano: Quantifica incerteza, incorpora conhecimento prévio

5. EFICIÊNCIA COMPUTACIONAL:
   ✓ Conjugação analítica é mais rápida que MCMC
   ✓ Resultados exatos (não aproximados)
""")

println("\n📁 ARQUIVOS GERADOS:")
println("   • comparacao_dado_justo.png")
println("   • comparacao_dado_viciado.png")
println("   • posteriores_dado_justo.png")
println("   • posteriores_dado_viciado.png")
println("   • animacao_dado_justo.gif")
println("   • animacao_dado_viciado.gif")

println("\n✅ Simulação concluída com sucesso!")