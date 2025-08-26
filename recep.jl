using Printf
using Plots
using Distributions
using LaTeXStrings

function mm_s_queue_analysis(λ, μ, s; plot_results=true)
    # Cálculos iniciais
    a = λ / μ
    ρ = a / s
    
    println("═"^50)
    @printf "Sistema de Filas M/M/%d\n" s
    println("═"^50)
    @printf "Parâmetros:\n"
    @printf "  Taxa de chegada (λ) = %.1f clientes/hora\n" λ
    @printf "  Taxa de atendimento (μ) = %.1f clientes/hora\n" μ
    @printf "  Número de servidores (s) = %d\n" s
    @printf "  Intensidade de tráfego (a = λ/μ) = %.4f\n" a
    @printf "  Utilização (ρ = a/s) = %.4f (%.1f%%)\n" ρ ρ*100
    
    # Verificação de estabilidade
    if ρ >= 1.0
        println("❌ Sistema instável (ρ ≥ 1)")
        return
    else
        println("✅ Sistema estável (ρ < 1)")
    end
    
    # Cálculo de P0 (probabilidade de sistema vazio)
    sum1 = 0.0
    for k in 0:(s-1)
        sum1 += a^k / factorial(k)
    end
    
    term2 = (a^s / factorial(s)) * (1 / (1 - ρ))
    P0 = 1 / (sum1 + term2)
    
    # Cálculo das probabilidades P_n
    function P_n(n)
        if n == 0
            return P0
        elseif n <= s
            return (a^n / factorial(n)) * P0
        else
            return (a^n / (factorial(s) * s^(n-s))) * P0
        end
    end
    
    # Cálculo de outras métricas
    Lq = P0 * (a^s * ρ) / (factorial(s) * (1 - ρ)^2)
    L = Lq + a
    Wq = Lq / λ
    W = L / λ
    Pwait = (a^s / (factorial(s) * (1 - ρ))) * P0
    
    # Exibição dos resultados
    println("\n" * "─"^30)
    println("📊 RESULTADOS:")
    println("─"^30)
    @printf "  P₀ (sistema vazio) = %.4f (%.2f%%)\n" P0 P0*100
    @printf "  Lq (nº médio na fila) = %.3f clientes\n" Lq
    @printf "  L (nº médio no sistema) = %.3f clientes\n" L
    @printf "  Wq (tempo médio na fila) = %.3f horas (%.1f min)\n" Wq Wq*60
    @printf "  W (tempo médio no sistema) = %.3f horas (%.1f min)\n" W W*60
    @printf "  Pwait (prob. de esperar) = %.3f (%.1f%%)\n" Pwait Pwait*100
    
    if plot_results
        # Gráfico 1: Distribuição de probabilidade do número de clientes
        n_max = min(20, Int(round(2*L; digits=0)) + 5)  # Limite para o gráfico
        n_values = 0:n_max
        prob_values = [P_n(n) for n in n_values]
        
        p1 = bar(n_values, prob_values, 
                title="Distribuição do Número de Clientes no Sistema",
                xlabel="Número de clientes (n)",
                ylabel="Probabilidade P(n)",
                legend=false,
                color=:blue,
                alpha=0.7,
                ylim=(0, maximum(prob_values)*1.1))
        
        # Destacar valores importantes
        vline!([L], linestyle=:dash, color=:red, linewidth=2, label="Média (L = $(round(L; digits=2)))")
        annotate!(L, maximum(prob_values)*0.9, text("Média = $(round(L; digits=2))", 8, :red))
        
        # Gráfico 2: Probabilidade acumulada
        cum_prob = cumsum(prob_values)
        p2 = plot(n_values, cum_prob,
                 title="Probabilidade Acumulada",
                 xlabel="Número máximo de clientes",
                 ylabel="Probabilidade P(N ≤ n)",
                 legend=false,
                 color=:green,
                 linewidth=2,
                 marker=:circle)
        
        hline!([0.95], linestyle=:dash, color=:red, label="95%")
        
        # Gráfico 3: Comparação de métricas
        metrics_names = ["Lq - Fila", "L - Sistema", "Wq (min)", "W (min)"]
        metrics_values = [Lq, L, Wq*60, W*60]
        
        p3 = bar(metrics_names, metrics_values,
                title="Métricas do Sistema",
                ylabel="Valor",
                color=[:orange :blue :red :green],
                legend=false,
                rotation=45)
        
        # Gráfico 4: Utilização e probabilidades especiais
        special_probs = [ρ, P0, Pwait]
        special_names = ["Utilização (ρ)", "P₀ (vazio)", "Pwait (espera)"]
        
        p4 = bar(special_names, special_probs,
                title="Probabilidades Especiais",
                ylabel="Probabilidade",
                color=[:purple :lightblue :pink],
                legend=false,
                ylim=(0, 1))
        
        # Layout dos gráficos
        plot(p1, p2, p3, p4, layout=(2,2), size=(1200, 800))
        
        # Gráfico adicional: Tempos de espera
        # Distribuição aproximada do tempo de espera
        if ρ < 1
            # Para Wq (tempo na fila)
            x_wq = range(0, 4*Wq, length=100)
            # Aproximação (para grandes sistemas)
            if Lq > 0
                μ_q = λ / Lq  # Taxa efetiva de saída da fila
                pdf_wq = μ_q .* exp.(-μ_q .* x_wq)
            else
                pdf_wq = zeros(length(x_wq))
            end
            
            p5 = plot(x_wq, pdf_wq,
                     title="Distribuição do Tempo na Fila (Aproximada)",
                     xlabel="Tempo na fila (horas)",
                     ylabel="Densidade de probabilidade",
                     legend=false,
                     color=:red,
                     linewidth=2)
            
            vline!([Wq], linestyle=:dash, color=:blue, label="Média Wq")
            annotate!(Wq, maximum(pdf_wq)*0.8, text("Média = $(round(Wq; digits=3))h", 8, :blue))
            
            display(plot(p1, p2, p3, p4, p5, layout=(3,2), size=(1200, 1000)))
        else
            display(plot(p1, p2, p3, p4, layout=(2,2), size=(1200, 800)))
        end
    end
    
    return (P0=P0, Lq=Lq, L=L, Wq=Wq, W=W, Pwait=Pwait)
end

# Executar a análise
println("Iniciando análise do sistema M/M/5...")
results = mm_s_queue_analysis(36.0, 9.0, 5)

# Análise adicional: Sensibilidade à taxa de chegada
println("\n" * "═"^50)
println("📈 ANÁLISE DE SENSIBILIDADE")
println("═"^50)

λ_values = range(30, 42, length=20)  # Varia a taxa de chegada
utilization = Float64[]
wait_times = Float64[]
queue_lengths = Float64[]

for λ_test in λ_values
    a_test = λ_test / 9.0
    ρ_test = a_test / 5
    push!(utilization, ρ_test)
    
    if ρ_test < 1
        # Cálculo simplificado de Lq
        P0_test = 1 / (sum([a_test^k/factorial(k) for k in 0:4]) + (a_test^5/factorial(5))/(1-ρ_test))
        Lq_test = P0_test * (a_test^5 * ρ_test) / (factorial(5) * (1-ρ_test)^2)
        Wq_test = Lq_test / λ_test
        
        push!(wait_times, Wq_test*60)  # em minutos
        push!(queue_lengths, Lq_test)
    else
        push!(wait_times, Inf)
        push!(queue_lengths, Inf)
    end
end

# Gráfico de sensibilidade
p_sens1 = plot(λ_values, utilization.*100,
              title="Sensibilidade: Utilização vs Taxa de Chegada",
              xlabel="Taxa de chegada λ (clientes/hora)",
              ylabel="Utilização (%)",
              legend=false,
              color=:blue,
              linewidth=2,
              marker=:circle)

p_sens2 = plot(λ_values, wait_times,
              title="Sensibilidade: Tempo de Espera vs Taxa de Chegada",
              xlabel="Taxa de chegada λ (clientes/hora)",
              ylabel="Tempo médio na fila (minutos)",
              legend=false,
              color=:red,
              linewidth=2,
              marker=:circle)

p_sens3 = plot(λ_values, queue_lengths,
              title="Sensibilidade: Tamanho da Fila vs Taxa de Chegada",
              xlabel="Taxa de chegada λ (clientes/hora)",
              ylabel="Nº médio na fila Lq",
              legend=false,
              color=:green,
              linewidth=2,
              marker=:circle)

# Ponto de operação atual
vline!([36], linestyle=:dash, color=:black, label="Operação atual")
annotate!(36, maximum(wait_times[isfinite.(wait_times)])*0.8, 
          text("λ = 36", 8, :black))

display(plot(p_sens1, p_sens2, p_sens3, layout=(3,1), size=(1000, 800)))