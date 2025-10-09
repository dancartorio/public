using DataFrames
using Statistics
using Printf
using Plots, StatsPlots
using Distributions
using Optim

# Dados de sobrevivência (em meses) dos 424 pacientes
dados_brutos = [
    1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
    10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11,
    11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 12,
    12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
    12, 12, 12, 12, 12, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13,
    13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 14, 14, 14, 14,
    14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14,
    14, 14, 14, 14, 14, 14, 14, 14, 15, 15, 15, 15, 15, 15, 15, 15,
    15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,
    15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16,
    16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17,
    17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17,
    17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18,
    18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 19, 19,
    19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19,
    20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
    20, 20, 20, 20, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 21, 21,
    21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
    21, 21, 21, 21, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 22,
    22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,
    22, 22, 22, 22, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 24,
    24, 24, 24, 24, 24, 24, 25, 25, 25
]

# Censurados (representados por "-" na tabela original)
n_censurados = 3
n_total = length(dados_brutos) + n_censurados

println("=" ^ 70)
println("ANÁLISE DE SOBREVIVÊNCIA - ESTIMADOR DE KAPLAN-MEIER")
println("=" ^ 70)
println("\nTotal de pacientes: $n_total")
println("Eventos observados (mortes): $(length(dados_brutos))")
println("Censurados: $n_censurados")
println()

# Função para calcular o estimador de Kaplan-Meier
function kaplan_meier(tempos::Vector{Int}, censurado_tempo::Union{Int, Nothing}=nothing)
    # Obter tempos únicos e ordenados
    tempos_unicos = sort(unique(tempos))
    n_inicial = length(tempos) + (censurado_tempo !== nothing ? 1 : 0)
    
    resultados = DataFrame(
        tempo = Int[],
        n_risco = Int[],
        mortes = Int[],
        sobreviventes = Float64[],
        S_t = Float64[],
        variancia = Float64[],
        ep = Float64[],
        IC_inferior = Float64[],
        IC_superior = Float64[]
    )
    
    S_t = 1.0
    variancia_acumulada = 0.0
    n_risco = n_inicial
    
    for t in tempos_unicos
        # Número de mortes no tempo t
        d_t = count(x -> x == t, tempos)
        
        # Probabilidade de sobrevivência no tempo t
        p_sobrevivencia = (n_risco - d_t) / n_risco
        S_t *= p_sobrevivencia
        
        # Variância de Greenwood
        variancia_acumulada += d_t / (n_risco * (n_risco - d_t))
        var_S = S_t^2 * variancia_acumulada
        ep = sqrt(var_S)
        
        # Intervalo de confiança 95% (aproximação normal)
        z = 1.96
        IC_inf = max(0.0, S_t - z * ep)
        IC_sup = min(1.0, S_t + z * ep)
        
        push!(resultados, (
            t,
            n_risco,
            d_t,
            n_risco - d_t,
            S_t,
            var_S,
            ep,
            IC_inf,
            IC_sup
        ))
        
        # Atualizar número em risco
        n_risco -= d_t
    end
    
    return resultados
end

# Calcular Kaplan-Meier
resultado_km = kaplan_meier(dados_brutos, 25)

# Exibir tabela de resultados
println("TABELA II: ESTIMADOR DE KAPLAN-MEIER")
println("=" ^ 100)
println(@sprintf("%-8s %-10s %-10s %-12s %-10s %-10s %-12s %-12s", 
    "Tempo", "n_risco", "Mortes", "Sobreviv.", "S(t)", "EP", "IC_inf", "IC_sup"))
println("-" ^ 100)

for row in eachrow(resultado_km)
    println(@sprintf("%-8d %-10d %-10d %-12d %-10.4f %-10.4f %-12.4f %-12.4f",
        row.tempo, row.n_risco, row.mortes, row.sobreviventes,
        row.S_t, row.ep, row.IC_inferior, row.IC_superior))
end

println("=" ^ 100)

# Estatísticas resumidas
println("\nESTATÍSTICAS RESUMIDAS:")
println("-" ^ 50)
println(@sprintf("Tempo médio de sobrevivência: %.2f meses", mean(dados_brutos)))
println(@sprintf("Mediana de sobrevivência: %.1f meses", median(dados_brutos)))
println(@sprintf("Desvio padrão: %.2f meses", std(dados_brutos)))
println(@sprintf("Mínimo: %d meses", minimum(dados_brutos)))
println(@sprintf("Máximo: %d meses", maximum(dados_brutos)))

# Encontrar tempo mediano de sobrevivência (S(t) ≈ 0.5)
idx_mediana = findfirst(x -> x <= 0.5, resultado_km.S_t)
if idx_mediana !== nothing
    println(@sprintf("\nTempo mediano de sobrevivência (S(t)=0.5): %d meses", 
        resultado_km.tempo[idx_mediana]))
end

# Probabilidades de sobrevivência em tempos específicos
println("\nPROBABILIDADES DE SOBREVIVÊNCIA:")
println("-" ^ 50)
tempos_interesse = [6, 12, 18, 24]
for t in tempos_interesse
    idx = findfirst(x -> x >= t, resultado_km.tempo)
    if idx !== nothing
        S_t = resultado_km.S_t[idx]
        println(@sprintf("S(%2d meses) = %.4f (%.2f%%)", t, S_t, S_t * 100))
    end
end

println("\n" * "=" ^ 70)
println("Análise concluída com sucesso!")
println("=" ^ 70)

# ==================== MODELOS PARAMÉTRICOS ====================

println("\n" * "=" ^ 70)
println("AJUSTE DE MODELOS PARAMÉTRICOS DE SOBREVIVÊNCIA")
println("=" ^ 70)

# Função de log-verossimilhança negativa para Exponencial
function negloglik_exponencial(lambda, dados)
    n = length(dados)
    return -(n * log(lambda) - lambda * sum(dados))
end

# Função de log-verossimilhança negativa para Weibull
function negloglik_weibull(params, dados)
    alpha, gamma = params
    if alpha <= 0 || gamma <= 0
        return Inf
    end
    n = length(dados)
    return -(n * log(gamma) + n * gamma * log(alpha) + 
             (gamma - 1) * sum(log.(dados)) - 
             alpha^gamma * sum(dados.^gamma))
end

# Função de log-verossimilhança negativa para Log-Normal
function negloglik_lognormal(params, dados)
    mu, sigma = params
    if sigma <= 0
        return Inf
    end
    n = length(dados)
    log_dados = log.(dados)
    return -(- n * log(sigma) - 0.5 * n * log(2π) - 
             sum(log_dados) - 
             sum((log_dados .- mu).^2) / (2 * sigma^2))
end

# Estimação dos parâmetros
println("\n1. MODELO EXPONENCIAL: S(t) = exp(-λt)")
println("-" ^ 50)

# MLE para exponencial (λ = 1/média)
lambda_hat = 1 / mean(dados_brutos)
println(@sprintf("   λ̂ (taxa) = %.6f", lambda_hat))
println(@sprintf("   Tempo médio = %.2f meses", 1/lambda_hat))

# Função de sobrevivência exponencial
S_exponencial(t, lambda) = exp(-lambda * t)

println("\n2. MODELO DE WEIBULL: S(t) = exp(-(αt)^γ)")
println("-" ^ 50)

# MLE para Weibull
result_weibull = optimize(p -> negloglik_weibull(p, dados_brutos), 
                          [0.1, 1.0], NelderMead())
alpha_hat, gamma_hat = Optim.minimizer(result_weibull)

println(@sprintf("   α̂ (escala) = %.6f", alpha_hat))
println(@sprintf("   γ̂ (forma) = %.6f", gamma_hat))

# Função de sobrevivência Weibull
S_weibull(t, alpha, gamma) = exp(-(alpha * t)^gamma)

println("\n3. MODELO LOG-NORMAL: S(t) = 1 - Φ((log(t) - μ)/σ)")
println("-" ^ 50)

# MLE para Log-Normal
log_dados = log.(dados_brutos)
mu_hat = mean(log_dados)
sigma_hat = std(log_dados, corrected=true)

println(@sprintf("   μ̂ = %.6f", mu_hat))
println(@sprintf("   σ̂ = %.6f", sigma_hat))

# Função de sobrevivência Log-Normal
S_lognormal(t, mu, sigma) = 1 - cdf(Normal(mu, sigma), log(t))

# ==================== TABELA III ====================

println("\n" * "=" ^ 70)
println("TABELA III: ESTIMATIVAS DA SOBREVIVÊNCIA")
println("Kaplan-Meier vs Modelos Exponencial, Weibull e Log-Normal")
println("=" ^ 70)

# Criar DataFrame com comparações
tabela_comparacao = DataFrame(
    Tempo = Int[],
    S_KM = Float64[],
    S_Exponencial = Float64[],
    S_Weibull = Float64[],
    S_LogNormal = Float64[],
    Diff_Exp = Float64[],
    Diff_Weibull = Float64[],
    Diff_LogNormal = Float64[]
)

for row in eachrow(resultado_km)
    t = row.tempo
    s_km = row.S_t
    s_exp = S_exponencial(t, lambda_hat)
    s_weib = S_weibull(t, alpha_hat, gamma_hat)
    s_logn = S_lognormal(t, mu_hat, sigma_hat)
    
    push!(tabela_comparacao, (
        t,
        s_km,
        s_exp,
        s_weib,
        s_logn,
        abs(s_km - s_exp),
        abs(s_km - s_weib),
        abs(s_km - s_logn)
    ))
end

println(@sprintf("%-8s %-10s %-12s %-12s %-12s", 
    "Tempo", "KM", "Exponencial", "Weibull", "Log-Normal"))
println("-" ^ 70)

for row in eachrow(tabela_comparacao)
    println(@sprintf("%-8d %-10.4f %-12.4f %-12.4f %-12.4f",
        row.Tempo, row.S_KM, row.S_Exponencial, row.S_Weibull, row.S_LogNormal))
end

println("=" ^ 70)

# ==================== CRITÉRIOS DE AJUSTE ====================

println("\n" * "=" ^ 70)
println("CRITÉRIOS DE ADEQUAÇÃO DOS MODELOS")
println("=" ^ 70)

# Calcular métricas de ajuste
function calcular_metricas(s_modelo, s_km)
    # Erro Quadrático Médio (MSE)
    mse = mean((s_modelo .- s_km).^2)
    
    # Raiz do Erro Quadrático Médio (RMSE)
    rmse = sqrt(mse)
    
    # Erro Absoluto Médio (MAE)
    mae = mean(abs.(s_modelo .- s_km))
    
    # Erro Absoluto Percentual Médio (MAPE)
    mape = mean(abs.((s_km .- s_modelo) ./ s_km)) * 100
    
    # R² (coeficiente de determinação)
    ss_res = sum((s_km .- s_modelo).^2)
    ss_tot = sum((s_km .- mean(s_km)).^2)
    r2 = 1 - ss_res / ss_tot
    
    return (mse=mse, rmse=rmse, mae=mae, mape=mape, r2=r2)
end

# Calcular AIC e BIC
function calcular_aic_bic(loglik, k, n)
    aic = 2 * k - 2 * loglik
    bic = k * log(n) - 2 * loglik
    return (aic=aic, bic=bic)
end

n = length(dados_brutos)

# Log-verossimilhanças
loglik_exp = -negloglik_exponencial(lambda_hat, dados_brutos)
loglik_weib = -negloglik_weibull([alpha_hat, gamma_hat], dados_brutos)
loglik_logn = -negloglik_lognormal([mu_hat, sigma_hat], dados_brutos)

# AIC e BIC
aic_bic_exp = calcular_aic_bic(loglik_exp, 1, n)
aic_bic_weib = calcular_aic_bic(loglik_weib, 2, n)
aic_bic_logn = calcular_aic_bic(loglik_logn, 2, n)

# Métricas de ajuste
metricas_exp = calcular_metricas(tabela_comparacao.S_Exponencial, tabela_comparacao.S_KM)
metricas_weib = calcular_metricas(tabela_comparacao.S_Weibull, tabela_comparacao.S_KM)
metricas_logn = calcular_metricas(tabela_comparacao.S_LogNormal, tabela_comparacao.S_KM)

println("\n1. CRITÉRIOS DE INFORMAÇÃO:")
println("-" ^ 50)
println(@sprintf("%-15s %-12s %-12s %-12s", "Modelo", "Log-Lik", "AIC", "BIC"))
println("-" ^ 50)
println(@sprintf("%-15s %-12.2f %-12.2f %-12.2f", 
    "Exponencial", loglik_exp, aic_bic_exp.aic, aic_bic_exp.bic))
println(@sprintf("%-15s %-12.2f %-12.2f %-12.2f", 
    "Weibull", loglik_weib, aic_bic_weib.aic, aic_bic_weib.bic))
println(@sprintf("%-15s %-12.2f %-12.2f %-12.2f", 
    "Log-Normal", loglik_logn, aic_bic_logn.aic, aic_bic_logn.bic))

println("\n2. MÉTRICAS DE AJUSTE (vs Kaplan-Meier):")
println("-" ^ 50)
println(@sprintf("%-15s %-10s %-10s %-10s %-10s %-10s", 
    "Modelo", "RMSE", "MAE", "MAPE(%)", "R²", "Ranking"))
println("-" ^ 50)
println(@sprintf("%-15s %-10.4f %-10.4f %-10.2f %-10.4f", 
    "Exponencial", metricas_exp.rmse, metricas_exp.mae, metricas_exp.mape, metricas_exp.r2))
println(@sprintf("%-15s %-10.4f %-10.4f %-10.2f %-10.4f", 
    "Weibull", metricas_weib.rmse, metricas_weib.mae, metricas_weib.mape, metricas_weib.r2))
println(@sprintf("%-15s %-10.4f %-10.4f %-10.2f %-10.4f", 
    "Log-Normal", metricas_logn.rmse, metricas_logn.mae, metricas_logn.mape, metricas_logn.r2))

# Determinar melhor modelo
modelos = ["Exponencial", "Weibull", "Log-Normal"]
aics = [aic_bic_exp.aic, aic_bic_weib.aic, aic_bic_logn.aic]
bics = [aic_bic_exp.bic, aic_bic_weib.bic, aic_bic_logn.bic]
rmses = [metricas_exp.rmse, metricas_weib.rmse, metricas_logn.rmse]
r2s = [metricas_exp.r2, metricas_weib.r2, metricas_logn.r2]

idx_melhor_aic = argmin(aics)
idx_melhor_bic = argmin(bics)
idx_melhor_rmse = argmin(rmses)
idx_melhor_r2 = argmax(r2s)

println("\n3. MELHOR MODELO POR CRITÉRIO:")
println("-" ^ 50)
println(@sprintf("   Por AIC:  %s (AIC = %.2f)", modelos[idx_melhor_aic], aics[idx_melhor_aic]))
println(@sprintf("   Por BIC:  %s (BIC = %.2f)", modelos[idx_melhor_bic], bics[idx_melhor_bic]))
println(@sprintf("   Por RMSE: %s (RMSE = %.4f)", modelos[idx_melhor_rmse], rmses[idx_melhor_rmse]))
println(@sprintf("   Por R²:   %s (R² = %.4f)", modelos[idx_melhor_r2], r2s[idx_melhor_r2]))

# Conclusão
println("\n" * "=" ^ 70)
println("CONCLUSÃO:")
println("-" ^ 50)

# Contagem de "vitórias" de cada modelo
vitorias = zeros(Int, 3)
vitorias[idx_melhor_aic] += 1
vitorias[idx_melhor_bic] += 1
vitorias[idx_melhor_rmse] += 1
vitorias[idx_melhor_r2] += 1

idx_melhor_geral = argmax(vitorias)
println(@sprintf("O modelo %s é o MAIS ADEQUADO aos dados.", modelos[idx_melhor_geral]))
println(@sprintf("Ele apresentou melhor desempenho em %d de 4 critérios avaliados.", 
    vitorias[idx_melhor_geral]))
println("=" ^ 70)

# ==================== GRÁFICOS ====================

println("\nGerando gráficos...")

# 1. Curva de Sobrevivência de Kaplan-Meier
p1 = plot(
    resultado_km.tempo, resultado_km.S_t,
    line=:steppost,
    linewidth=2.5,
    color=:blue,
    label="S(t) - Kaplan-Meier",
    xlabel="Tempo (meses)",
    ylabel="Probabilidade de Sobrevivência S(t)",
    title="Curva de Sobrevivência de Kaplan-Meier\nPacientes com Infecção Hospitalar (n=424)",
    legend=:topright,
    grid=true,
    gridstyle=:dot,
    gridalpha=0.3,
    ylim=(0, 1.05),
    xlim=(0, 26),
    size=(800, 600),
    dpi=300,
    titlefontsize=12,
    labelfontsize=10
)

# Adicionar intervalo de confiança
plot!(p1, resultado_km.tempo, resultado_km.IC_inferior,
    line=:steppost, linewidth=1, color=:red, linestyle=:dash,
    label="IC 95% Inferior", alpha=0.7)
plot!(p1, resultado_km.tempo, resultado_km.IC_superior,
    line=:steppost, linewidth=1, color=:red, linestyle=:dash,
    label="IC 95% Superior", alpha=0.7)

# Adicionar linha de referência em S(t) = 0.5
hline!(p1, [0.5], color=:gray, linestyle=:dashdot, linewidth=1.5,
    label="Mediana (S=0.5)", alpha=0.6)

savefig(p1, "kaplan_meier_curva.png")
println("✓ Gráfico 1 salvo: kaplan_meier_curva.png")

# 2. Histograma dos Tempos de Sobrevivência
p2 = histogram(
    dados_brutos,
    bins=25,
    color=:steelblue,
    alpha=0.7,
    xlabel="Tempo de Sobrevivência (meses)",
    ylabel="Frequência",
    title="Distribuição dos Tempos de Sobrevivência\n(n=421 eventos observados)",
    legend=false,
    grid=true,
    gridstyle=:dot,
    gridalpha=0.3,
    size=(800, 500),
    dpi=300,
    titlefontsize=12
)

# Adicionar linha vertical para média e mediana
vline!(p2, [mean(dados_brutos)], color=:red, linewidth=2.5,
    linestyle=:dash, label="Média")
vline!(p2, [median(dados_brutos)], color=:green, linewidth=2.5,
    linestyle=:dot, label="Mediana")
plot!(p2, legend=:topright)

savefig(p2, "histograma_sobrevivencia.png")
println("✓ Gráfico 2 salvo: histograma_sobrevivencia.png")

# 3. Número em Risco ao Longo do Tempo
p3 = plot(
    resultado_km.tempo, resultado_km.n_risco,
    line=:steppost,
    linewidth=2.5,
    color=:darkgreen,
    marker=:circle,
    markersize=3,
    label="Pacientes em Risco",
    xlabel="Tempo (meses)",
    ylabel="Número de Pacientes em Risco",
    title="Número de Pacientes em Risco ao Longo do Tempo",
    legend=:topright,
    grid=true,
    gridstyle=:dot,
    gridalpha=0.3,
    size=(800, 500),
    dpi=300,
    titlefontsize=12
)

savefig(p3, "numero_em_risco.png")
println("✓ Gráfico 3 salvo: numero_em_risco.png")

# 4. Taxa de Mortalidade ao Longo do Tempo
p4 = bar(
    resultado_km.tempo, resultado_km.mortes,
    color=:coral,
    alpha=0.7,
    xlabel="Tempo (meses)",
    ylabel="Número de Mortes",
    title="Distribuição de Mortes por Tempo",
    legend=false,
    grid=true,
    gridstyle=:dot,
    gridalpha=0.3,
    size=(800, 500),
    dpi=300,
    titlefontsize=12
)

savefig(p4, "mortes_por_tempo.png")
println("✓ Gráfico 4 salvo: mortes_por_tempo.png")

# 5. Boxplot dos Tempos de Sobrevivência
p5 = boxplot(
    ["Sobrevivência"], dados_brutos,
    color=:lightblue,
    fillalpha=0.6,
    ylabel="Tempo (meses)",
    title="Boxplot dos Tempos de Sobrevivência",
    legend=false,
    grid=true,
    gridstyle=:dot,
    gridalpha=0.3,
    size=(600, 600),
    dpi=300,
    titlefontsize=12
)

# Adicionar estatísticas no gráfico
annotate!(p5, 1.3, mean(dados_brutos), 
    text(@sprintf("Média: %.1f", mean(dados_brutos)), 10, :left))
annotate!(p5, 1.3, median(dados_brutos), 
    text(@sprintf("Mediana: %.1f", median(dados_brutos)), 10, :left))

savefig(p5, "boxplot_sobrevivencia.png")
println("✓ Gráfico 5 salvo: boxplot_sobrevivencia.png")

# 6. Gráfico Combinado (2x2)
p_combined = plot(p1, p2, p3, p4,
    layout=(2, 2),
    size=(1400, 1000),
    dpi=300,
    margin=5Plots.mm
)

savefig(p_combined, "analise_completa.png")
println("✓ Gráfico combinado salvo: analise_completa.png")

# 7. Curva de Sobrevivência com Área de Confiança
p7 = plot(
    resultado_km.tempo, resultado_km.S_t,
    line=:steppost,
    linewidth=3,
    color=:blue,
    label="S(t) - Kaplan-Meier",
    xlabel="Tempo (meses)",
    ylabel="Probabilidade de Sobrevivência S(t)",
    title="Curva de Sobrevivência com Intervalo de Confiança 95%",
    legend=:topright,
    grid=true,
    gridstyle=:dot,
    gridalpha=0.3,
    ylim=(0, 1.05),
    xlim=(0, 26),
    size=(900, 600),
    dpi=300,
    titlefontsize=12
)

# Adicionar área sombreada para IC
plot!(p7, resultado_km.tempo, resultado_km.IC_inferior,
    fillrange=resultado_km.IC_superior,
    fillalpha=0.2,
    fillcolor=:blue,
    line=:steppost,
    linewidth=1.5,
    color=:blue,
    linestyle=:dash,
    label="IC 95%")

# Adicionar marcadores para tempos específicos
tempos_mark = [6, 12, 18, 24]
for t in tempos_mark
    idx = findfirst(x -> x >= t, resultado_km.tempo)
    if idx !== nothing
        scatter!(p7, [resultado_km.tempo[idx]], [resultado_km.S_t[idx]],
            markersize=6, color=:red, markerstrokewidth=2,
            label=idx==findfirst(x -> x >= tempos_mark[1], resultado_km.tempo) ? 
                "Marcos temporais" : "")
    end
end

hline!(p7, [0.5], color=:gray, linestyle=:dashdot, linewidth=1.5,
    label="", alpha=0.5)

savefig(p7, "curva_sobrevivencia_ic.png")
println("✓ Gráfico 7 salvo: curva_sobrevivencia_ic.png")

println("\n" * "=" ^ 70)
println("Todos os gráficos foram gerados com sucesso!")
println("=" ^ 70)
display(p1)

# ==================== GRÁFICOS DE COMPARAÇÃO DE MODELOS ====================

println("\n" * "=" ^ 70)
println("GERANDO GRÁFICOS DE COMPARAÇÃO DE MODELOS...")
println("=" ^ 70)

# 8. Comparação das Curvas de Sobrevivência
tempos_plot = 0:0.1:25

p8 = plot(
    resultado_km.tempo, resultado_km.S_t,
    line=:steppost,
    linewidth=3,
    color=:black,
    label="Kaplan-Meier (Observado)",
    xlabel="Tempo (meses)",
    ylabel="Probabilidade de Sobrevivência S(t)",
    title="Comparação: Kaplan-Meier vs Modelos Paramétricos",
    legend=:topright,
    grid=true,
    gridstyle=:dot,
    gridalpha=0.3,
    ylim=(0, 1.05),
    xlim=(0, 26),
    size=(1000, 700),
    dpi=300,
    titlefontsize=13,
    labelfontsize=11,
    legendfontsize=9
)

# Adicionar curvas dos modelos paramétricos
plot!(p8, tempos_plot, S_exponencial.(tempos_plot, lambda_hat),
    linewidth=2.5, color=:red, linestyle=:dash,
    label="Exponencial")

plot!(p8, tempos_plot, S_weibull.(tempos_plot, alpha_hat, gamma_hat),
    linewidth=2.5, color=:blue, linestyle=:dashdot,
    label="Weibull")

plot!(p8, tempos_plot, S_lognormal.(tempos_plot, mu_hat, sigma_hat),
    linewidth=2.5, color=:green, linestyle=:dot,
    label="Log-Normal")

# Adicionar marcadores nos pontos observados
scatter!(p8, resultado_km.tempo, resultado_km.S_t,
    markersize=4, color=:black, alpha=0.5,
    label="")

savefig(p8, "comparacao_modelos.png")
println("✓ Gráfico 8 salvo: comparacao_modelos.png")

# 9. Resíduos dos Modelos
p9_1 = scatter(
    tabela_comparacao.Tempo, 
    tabela_comparacao.S_KM .- tabela_comparacao.S_Exponencial,
    color=:red, alpha=0.6, markersize=5,
    xlabel="Tempo (meses)",
    ylabel="Resíduo (KM - Modelo)",
    title="Resíduos: Exponencial",
    legend=false,
    grid=true
)
hline!(p9_1, [0], color=:black, linestyle=:dash, linewidth=1.5)

p9_2 = scatter(
    tabela_comparacao.Tempo, 
    tabela_comparacao.S_KM .- tabela_comparacao.S_Weibull,
    color=:blue, alpha=0.6, markersize=5,
    xlabel="Tempo (meses)",
    ylabel="Resíduo (KM - Modelo)",
    title="Resíduos: Weibull",
    legend=false,
    grid=true
)
hline!(p9_2, [0], color=:black, linestyle=:dash, linewidth=1.5)

p9_3 = scatter(
    tabela_comparacao.Tempo, 
    tabela_comparacao.S_KM .- tabela_comparacao.S_LogNormal,
    color=:green, alpha=0.6, markersize=5,
    xlabel="Tempo (meses)",
    ylabel="Resíduo (KM - Modelo)",
    title="Resíduos: Log-Normal",
    legend=false,
    grid=true
)
hline!(p9_3, [0], color=:black, linestyle=:dash, linewidth=1.5)

p9 = plot(p9_1, p9_2, p9_3,
    layout=(1, 3),
    size=(1400, 400),
    dpi=300,
    margin=5Plots.mm
)

savefig(p9, "residuos_modelos.png")
println("✓ Gráfico 9 salvo: residuos_modelos.png")

# 10. Q-Q plots para cada modelo
p10_1 = scatter(
    tabela_comparacao.S_Exponencial,
    tabela_comparacao.S_KM,
    color=:red, alpha=0.6, markersize=5,
    xlabel="S(t) Exponencial",
    ylabel="S(t) Kaplan-Meier",
    title="Q-Q Plot: Exponencial",
    legend=false,
    grid=true,
    aspect_ratio=:equal
)
plot!(p10_1, [0, 1], [0, 1], color=:black, linestyle=:dash, linewidth=2)

p10_2 = scatter(
    tabela_comparacao.S_Weibull,
    tabela_comparacao.S_KM,
    color=:blue, alpha=0.6, markersize=5,
    xlabel="S(t) Weibull",
    ylabel="S(t) Kaplan-Meier",
    title="Q-Q Plot: Weibull",
    legend=false,
    grid=true,
    aspect_ratio=:equal
)
plot!(p10_2, [0, 1], [0, 1], color=:black, linestyle=:dash, linewidth=2)

p10_3 = scatter(
    tabela_comparacao.S_LogNormal,
    tabela_comparacao.S_KM,
    color=:green, alpha=0.6, markersize=5,
    xlabel="S(t) Log-Normal",
    ylabel="S(t) Kaplan-Meier",
    title="Q-Q Plot: Log-Normal",
    legend=false,
    grid=true,
    aspect_ratio=:equal
)
plot!(p10_3, [0, 1], [0, 1], color=:black, linestyle=:dash, linewidth=2)

p10 = plot(p10_1, p10_2, p10_3,
    layout=(1, 3),
    size=(1400, 450),
    dpi=300,
    margin=5Plots.mm
)

savefig(p10, "qq_plots_modelos.png")
println("✓ Gráfico 10 salvo: qq_plots_modelos.png")

# 11. Gráfico de Barras Comparando Métricas
metricas_nomes = ["RMSE", "MAE", "R²"]
metricas_valores = [
    [metricas_exp.rmse, metricas_weib.rmse, metricas_logn.rmse],
    [metricas_exp.mae, metricas_weib.mae, metricas_logn.mae],
    [metricas_exp.r2, metricas_weib.r2, metricas_logn.r2]
]

p11_plots = []
for (i, nome) in enumerate(metricas_nomes)
    p_temp = bar(
        ["Exp", "Weibull", "LogNorm"],
        metricas_valores[i],
        color=[:red :blue :green],
        alpha=0.7,
        ylabel=nome,
        title="Métrica: $nome",
        legend=false,
        grid=true,
        ylim=(0, maximum(metricas_valores[i]) * 1.2)
    )
    
    # Adicionar valores nas barras
    for (j, val) in enumerate(metricas_valores[i])
        annotate!(p_temp, j, val + maximum(metricas_valores[i]) * 0.05,
            text(@sprintf("%.4f", val), 8))
    end
    
    push!(p11_plots, p_temp)
end

p11 = plot(p11_plots...,
    layout=(1, 3),
    size=(1400, 400),
    dpi=300,
    margin=5Plots.mm
)

savefig(p11, "metricas_comparacao.png")
println("✓ Gráfico 11 salvo: metricas_comparacao.png")

# 12. Diferenças Absolutas ao Longo do Tempo
p12 = plot(
    tabela_comparacao.Tempo, tabela_comparacao.Diff_Exp,
    linewidth=2.5, color=:red, marker=:circle, markersize=3,
    label="Exponencial",
    xlabel="Tempo (meses)",
    ylabel="Diferença Absoluta |S_KM - S_Modelo|",
    title="Diferenças Absolutas entre Kaplan-Meier e Modelos Paramétricos",
    legend=:topleft,
    grid=true,
    gridstyle=:dot,
    gridalpha=0.3,
    size=(1000, 600),
    dpi=300,
    titlefontsize=12
)

plot!(p12, tabela_comparacao.Tempo, tabela_comparacao.Diff_Weibull,
    linewidth=2.5, color=:blue, marker=:square, markersize=3,
    label="Weibull")

plot!(p12, tabela_comparacao.Tempo, tabela_comparacao.Diff_LogNormal,
    linewidth=2.5, color=:green, marker=:diamond, markersize=3,
    label="Log-Normal")

savefig(p12, "diferencas_absolutas.png")
println("✓ Gráfico 12 salvo: diferencas_absolutas.png")

# 13. Painel Comparativo Completo (3x2)
p13 = plot(p8, p9_1, p9_2, p9_3, p10_1, p10_2,
    layout=(3, 2),
    size=(1400, 1400),
    dpi=300,
    margin=5Plots.mm
)

savefig(p13, "painel_comparativo_completo.png")
println("✓ Gráfico 13 salvo: painel_comparativo_completo.png")

# 14. Gráfico de Ranking de Modelos
criterios = ["AIC", "BIC", "RMSE", "R²"]
rankings = zeros(Int, 3, 4)

# AIC (menor é melhor)
rankings[:, 1] = sortperm(aics)
# BIC (menor é melhor)
rankings[:, 2] = sortperm(bics)
# RMSE (menor é melhor)
rankings[:, 3] = sortperm(rmses)
# R² (maior é melhor)
rankings[:, 4] = sortperm(r2s, rev=true)

pontuacao = [sum(rankings[i, :]) for i in 1:3]
modelo_melhor = argmin(pontuacao)

p14 = groupedbar(
    rankings',
    bar_position=:dodge,
    bar_width=0.7,
    color=[:red :blue :green],
    alpha=0.7,
    xlabel="Critério",
    ylabel="Ranking (1=melhor, 3=pior)",
    title="Ranking dos Modelos por Critério\n(Melhor Geral: $(modelos[modelo_melhor]))",
    xticks=(1:4, criterios),
    labels=["Exponencial" "Weibull" "Log-Normal"],
    legend=:topright,
    grid=true,
    size=(900, 600),
    dpi=300,
    ylim=(0, 4)
)

savefig(p14, "ranking_modelos.png")
println("✓ Gráfico 14 salvo: ranking_modelos.png")

println("\n" * "=" ^ 70)
println("TODOS OS GRÁFICOS DE COMPARAÇÃO FORAM GERADOS!")
println("=" ^ 70)
println("\nArquivos gerados:")
println("  1-7: Análise Kaplan-Meier")
println("  8: Comparação de todas as curvas de sobrevivência")
println("  9: Gráficos de resíduos")
println("  10: Q-Q plots")
println("  11: Comparação de métricas")
println("  12: Diferenças absolutas ao longo do tempo")
println("  13: Painel comparativo completo")
println("  14: Ranking dos modelos")
println("=" ^ 70)

display(p8)