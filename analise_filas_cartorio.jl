# =============================================================================
# Análise de Teoria de Filas — 2ª Serventia Registral de Petrolina/PE
# Modelo: M/G/c (aproximação Allen-Cunneen)
# Requer: XLSX.jl, DataFrames.jl, Distributions.jl, HypothesisTests.jl,
#         Statistics.jl, Dates.jl, Printf.jl
#
# Instalação dos pacotes (rodar uma vez):
#   using Pkg
#   Pkg.add(["XLSX", "DataFrames", "Distributions",
#            "HypothesisTests", "StatsBase"])
# =============================================================================

using XLSX, DataFrames, Distributions, Statistics
using Dates, Printf, HypothesisTests, StatsBase

# =============================================================================
# 1. LEITURA DOS DADOS
# =============================================================================

const ARQUIVO = "2ripetrolina-pe_repositorio_Consulta_de_senhas-2026-03-17-13-27-12__1_.xlsx"

function ler_dados(arquivo::String)::DataFrame
    xf  = XLSX.readxlsx(arquivo)
    sh  = xf[XLSX.sheetnames(xf)[1]]
    df  = DataFrame(XLSX.eachtablerow(sh))
    rename!(df, strip.(string.(names(df))))
    return df
end

# =============================================================================
# 2. PARSING DE TIMESTAMPS
# =============================================================================

function parse_hms(s)::Union{Time, Missing}
    try
        parts = split(string(s), ":")
        return Time(parse(Int, parts[1]), parse(Int, parts[2]), parse(Int, parts[3]))
    catch
        return missing
    end
end

function combinar_datetime(data, hora_str)::Union{DateTime, Missing}
    t = parse_hms(hora_str)
    ismissing(t) && return missing
    try
        d = data isa Date ? data : Date(string(data)[1:10])
        return DateTime(d, t)
    catch
        return missing
    end
end

function preparar_timestamps!(df::DataFrame)::DataFrame
    df[!, :DT_Gerada]     = combinar_datetime.(df[!, "Data Registro"], df[!, "H.Gerada"])
    df[!, :DT_Chamada]    = combinar_datetime.(df[!, "Data Registro"], df[!, "H.Chamada"])
    df[!, :DT_Finalizada] = combinar_datetime.(df[!, "Data Registro"], df[!, "H.Finalizada"])

    # Tempos em minutos (Float64)
    to_min(a, b) = ismissing(a) || ismissing(b) ?
        missing : Dates.value(b - a) / 60_000.0

    df[!, :espera_min]    = to_min.(df[!, :DT_Gerada],  df[!, :DT_Chamada])
    df[!, :atend_min]     = to_min.(df[!, :DT_Chamada], df[!, :DT_Finalizada])
    df[!, :total_min]     = to_min.(df[!, :DT_Gerada],  df[!, :DT_Finalizada])

    # Tempo de atendimento declarado pelo sistema (para comparação)
    df[!, :atend_sistema_min] = map(df[!, "T.Atendimento"]) do s
        t = parse_hms(s)
        ismissing(t) ? missing : hour(t)*60.0 + minute(t) + second(t)/60.0
    end

    df[!, :erro_atend_s] = abs.(
        coalesce.(df[!, :atend_min],     0.0) .*60 .-
        coalesce.(df[!, :atend_sistema_min], 0.0) .*60
    )

    df[!, :hora] = map(dt -> ismissing(dt) ? missing : hour(dt), df[!, :DT_Gerada])
    return df
end

# =============================================================================
# 3. LIMPEZA — PIPELINE HARD + REGRA DE NEGÓCIO
# =============================================================================

function limpar!(df::DataFrame;
                 lim_atend_max::Float64 = 120.0,
                 lim_erro_s::Float64    = 300.0)::Tuple{DataFrame, Dict}

    n0 = nrow(df)
    motivos = Dict{String, Int}()

    # Remove missing em campos essenciais
    df = dropmissing(df, [:DT_Gerada, :DT_Chamada, :DT_Finalizada,
                          :espera_min, :atend_min])

    # Ordem lógica: Gerada ≤ Chamada ≤ Finalizada
    violacao = (df.DT_Chamada .< df.DT_Gerada) .| (df.DT_Finalizada .< df.DT_Chamada)
    motivos["violação_ordem"]  = sum(violacao)
    df = df[.!violacao, :]

    # Tempos negativos
    neg = (df.espera_min .< 0) .| (df.atend_min .< 0)
    motivos["tempo_negativo"] = sum(neg)
    df = df[.!neg, :]

    # T.Atendimento = 0 (suspeito)
    zero_atend = df.atend_min .== 0
    motivos["atend_zero"] = sum(zero_atend)
    df = df[.!zero_atend, :]

    # Limite de negócio: atendimento > 120 min
    lim_biz = df.atend_min .> lim_atend_max
    motivos["limite_negocio_120min"] = sum(lim_biz)
    df = df[.!lim_biz, :]

    # Discrepância sistema vs calculado > 5 min
    disc = df.erro_atend_s .> lim_erro_s
    motivos["discrepancia_sistema"] = sum(disc)
    df = df[.!disc, :]

    motivos["total_removidos"] = n0 - nrow(df)
    motivos["n_original"]      = n0
    motivos["n_limpo"]         = nrow(df)

    return df, motivos
end

# =============================================================================
# 4. ESTATÍSTICAS DESCRITIVAS DO TEMPO DE SERVIÇO
# =============================================================================

function descrever_servico(s::Vector{Float64}, nome::String)
    μ  = mean(s)
    σ  = std(s)
    cv = σ / μ
    println("\n" * "="^60)
    println("SERVIÇO: $nome  (n=$(length(s)))")
    println("="^60)
    @printf "  E[S]       = %8.4f min\n"   μ
    @printf "  σ          = %8.4f min\n"   σ
    @printf "  CV         = %8.4f\n"       cv
    @printf "  CV²        = %8.4f\n"       cv^2
    @printf "  Mediana    = %8.4f min\n"   median(s)
    @printf "  Assimetria = %8.4f\n"       skewness(s)
    @printf "  Curtose    = %8.4f\n"       kurtosis(s)
    @printf "  P5 / P95   = %6.2f / %6.2f min\n" percentile(s, 5) percentile(s, 95)
    return (μ=μ, σ=σ, cv=cv, cv2=cv^2)
end

# =============================================================================
# 5. TESTES DE ADERÊNCIA (KS)
# =============================================================================

function testar_distribuicoes(s::Vector{Float64})
    println("\n--- Testes de aderência (Kolmogorov-Smirnov) ---")

    # Exponencial
    fit_exp = fit(Exponential, s)
    ks_exp  = ExactOneSampleKSTest(s, fit_exp)
    @printf "  Exponencial  KS=%.4f  p=%.2e  [β=%.4f]\n" ks_exp.δ pvalue(ks_exp) fit_exp.θ

    # Lognormal
    fit_ln  = fit(LogNormal, s)
    ks_ln   = ExactOneSampleKSTest(s, fit_ln)
    @printf "  Lognormal    KS=%.4f  p=%.2e  [μ=%.4f σ=%.4f]\n" ks_ln.δ pvalue(ks_ln) fit_ln.μ fit_ln.σ

    # Gamma
    fit_g   = fit(Gamma, s)
    ks_g    = ExactOneSampleKSTest(s, fit_g)
    @printf "  Gamma        KS=%.4f  p=%.2e  [α=%.4f θ=%.4f]\n" ks_g.δ pvalue(ks_g) fit_g.α fit_g.θ

    # Weibull
    fit_w   = fit(Weibull, s)
    ks_w    = ExactOneSampleKSTest(s, fit_w)
    @printf "  Weibull      KS=%.4f  p=%.2e  [α=%.4f θ=%.4f]\n" ks_w.δ pvalue(ks_w) fit_w.α fit_w.θ

    println("\n  ⚠  Com n grande, KS rejeita qualquer distribuição teórica.")
    println("     Critério correto: menor estatística KS = melhor ajuste relativo.")

    melhor = argmin([ks_exp.δ, ks_ln.δ, ks_g.δ, ks_w.δ])
    nomes  = ["Exponencial", "Lognormal", "Gamma", "Weibull"]
    println("  → Melhor ajuste: $(nomes[melhor])")

    return fit_ln  # retorna lognormal (melhor ajuste empírico)
end

# =============================================================================
# 6. INTERARRIVAL — TESTE DE POISSON
# =============================================================================

function calcular_interarrival(df_fila::DataFrame)::Vector{Float64}
    arr = Float64[]
    for (_, grp) in pairs(groupby(df_fila, :data_reg))
        sub = sort(grp, :DT_Gerada)
        diffs = diff(Dates.value.(sub.DT_Gerada)) ./ 60_000.0
        append!(arr, filter(x -> x > 0, diffs))
    end
    return arr
end

function testar_poisson(arr::Vector{Float64})
    cv2 = (std(arr) / mean(arr))^2
    fit_exp = fit(Exponential, arr)
    ks      = ExactOneSampleKSTest(arr, fit_exp)
    println("\n--- Interarrival (processo de chegadas) ---")
    @printf "  n           = %d\n"    length(arr)
    @printf "  Média       = %.4f min\n" mean(arr)
    @printf "  CV²         = %.4f\n"  cv2
    @printf "  KS exp      = %.4f  p=%.2e\n" ks.δ pvalue(ks)
    @printf "  Índice disp.= %.4f  (1.0 = Poisson puro)\n" cv2
    cv2 ≈ 1.0 && println("  → Chegadas consistentes com processo de Poisson")
end

# =============================================================================
# 7. ERLANG-C (M/M/c)
# =============================================================================

function erlang_c(c::Int, λ::Float64, μ::Float64)
    ρ = λ / (c * μ)
    ρ >= 1.0 && return (C=NaN, ρ=ρ, Wq=NaN, W=NaN, Lq=NaN, L=NaN, P0=NaN)

    a = λ / μ
    soma = sum(a^n / factorial(n) for n in 0:(c-1))
    ultimo = a^c / (factorial(c) * (1 - ρ))
    P0 = 1.0 / (soma + ultimo)
    C  = ultimo * P0

    Wq = C / (c * μ - λ)
    W  = Wq + 1/μ
    Lq = λ * Wq
    L  = λ * W

    return (C=C, ρ=ρ, Wq=Wq, W=W, Lq=Lq, L=L, P0=P0)
end

# =============================================================================
# 8. M/G/c — APROXIMAÇÃO DE ALLEN-CUNNEEN
# =============================================================================

"""
    allen_cunneen(c, λ, μ, cv2_s)

Aproximação de Allen-Cunneen para M/G/c:
    Wq(M/G/c) ≈ Wq(M/M/c) × (1 + CV²_S) / 2

Referência: Allen, A.O. (1978). Probability, Statistics, and Queueing Theory.
            Academic Press. Cap. 8.
"""
function allen_cunneen(c::Int, λ::Float64, μ::Float64, cv2_s::Float64)
    mm = erlang_c(c, λ, μ)
    isnan(mm.Wq) && return mm

    fator = (1 + cv2_s) / 2
    Wq_mg = mm.Wq * fator
    W_mg  = Wq_mg + 1/μ
    Lq_mg = λ * Wq_mg
    L_mg  = λ * W_mg

    return (C=mm.C, ρ=mm.ρ, Wq=Wq_mg, W=W_mg, Lq=Lq_mg, L=L_mg,
            Wq_mmc=mm.Wq, fator=fator)
end

function imprimir_mg(c::Int, λ::Float64, μ::Float64, cv2_s::Float64, label::String="")
    r = allen_cunneen(c, λ, μ, cv2_s)
    println("\n  c=$c  $(label)")
    if isnan(r.ρ) || r.ρ >= 1
        @printf "    INSTÁVEL  ρ=%.4f ≥ 1\n" r.ρ
        return r
    end
    @printf "    ρ              = %.4f (%.1f%%)\n"   r.ρ  r.ρ*100
    @printf "    Erlang C       = %.4f (%.2f%%)\n"   r.C  r.C*100
    @printf "    Wq M/M/%d     = %.4f s\n"           c    r.Wq_mmc*60
    @printf "    Fator (1+CV²)/2= %.4f  [CV²=%.4f]\n" r.fator cv2_s
    @printf "    Wq M/G/%d     = %.4f s  = %.4f min\n" c r.Wq*60 r.Wq
    @printf "    W  M/G/%d     = %.4f min\n"          c r.W
    @printf "    Lq M/G/%d     = %.6f clientes\n"     c r.Lq
    return r
end

# =============================================================================
# 9. ANÁLISE POR HORA (não-estacionariedade)
# =============================================================================

function analise_por_hora(df_fila::DataFrame, c::Int, cv2_s::Float64)
    println("\n" * "="^60)
    println("ANÁLISE POR HORA — c=$c")
    println("="^60)
    @printf "  %-4s  %-6s  %-7s  %-7s  %-9s  %-9s  %s\n" "hora" "n" "λ/h" "ρ(%)" "C(%)" "Wq(s)" "flag"

    n_dias = length(unique(Date.(df_fila.DT_Gerada)))

    for h in 8:17
        sub = df_fila[df_fila.hora .== h, :]
        nrow(sub) < 10 && continue

        λ_h = nrow(sub) / (n_dias * 60.0)  # por minuto nessa hora
        μ_h = 1.0 / mean(sub.atend_min)
        r   = allen_cunneen(c, λ_h, μ_h, cv2_s)

        flag = isnan(r.ρ) ? "INSTÁVEL" : r.ρ > 0.70 ? "⚠ CRÍTICO" : r.ρ > 0.40 ? "⚠ alto" : ""
        @printf "  %2dh   %-6d  %-7.3f  %-7.1f  %-9.2f  %-9.3f  %s\n" \
            h nrow(sub) λ_h*60 r.ρ*100 r.C*100 r.Wq*60 flag
    end
end

# =============================================================================
# 10. SENSIBILIDADE AO CV²
# =============================================================================

function sensibilidade_cv2(λ::Float64, μ::Float64, c::Int)
    println("\n" * "="^60)
    println("SENSIBILIDADE DE Wq AO CV²  (c=$c)")
    println("="^60)
    @printf "  %-8s  %-20s  %-15s  %s\n" "CV²" "Fator (1+CV²)/2" "Wq M/G/$c (s)" "vs M/M/$c"
    mm_base = erlang_c(c, λ, μ)
    for cv2 in [0.5, 0.86, 1.0, 1.5, 2.0, 3.0]
        fator = (1 + cv2) / 2
        wq    = mm_base.Wq * fator * 60
        @printf "  %-8.2f  %-20.3f  %-15.3f  %.2f×\n" cv2 fator wq fator
    end
end

# =============================================================================
# 11. MAIN
# =============================================================================

function main()
    println("="^60)
    println("PIPELINE DE ANÁLISE DE FILAS — CARTÓRIO PETROLINA/PE")
    println("="^60)

    # --- Leitura ---
    df = ler_dados(ARQUIVO)
    println("\n→ $(nrow(df)) registros lidos, $(ncol(df)) colunas")

    # --- Timestamps ---
    preparar_timestamps!(df)
    df[!, :data_reg] = Date.(df[!, "Data Registro"])

    # --- Limpeza ---
    df_clean, motivos = limpar!(df)
    println("\n--- Resumo da limpeza ---")
    for (k, v) in sort(collect(motivos))
        @printf "  %-30s = %d\n" k v
    end

    # --- Foco: Registro de Imóveis ---
    ri = df_clean[df_clean[!, "Fila"] .== "Registro de Imóveis", :]
    S  = Float64.(ri.atend_min)
    println("\n→ Fila 'Registro de Imóveis': $(length(S)) registros após limpeza")

    # --- Descritivas ---
    stats = descrever_servico(S, "Registro de Imóveis")

    # --- Aderência ---
    fit_ln = testar_distribuicoes(S)

    # --- Interarrival ---
    arr = calcular_interarrival(ri)
    testar_poisson(arr)

    # --- Parâmetros globais ---
    n_dias = length(unique(ri.data_reg))
    λ = mean(combine(groupby(ri, :data_reg), nrow => :n)[!, :n]) / (8 * 60.0)
    μ = 1.0 / mean(S)
    cv2_s = stats.cv2

    println("\n" * "="^60)
    println("PARÂMETROS GLOBAIS")
    println("="^60)
    @printf "  λ = %.4f/min = %.3f/hora\n" λ λ*60
    @printf "  μ = %.4f/min = %.3f/hora\n" μ μ*60
    @printf "  1/μ (E[S]) = %.4f min\n"    1/μ
    @printf "  CV²_S      = %.4f\n"        cv2_s
    @printf "  n_dias     = %d\n"          n_dias

    # --- M/G/c cenários ---
    println("\n" * "="^60)
    println("M/G/c — APROXIMAÇÃO DE ALLEN-CUNNEEN")
    println("="^60)
    for c in [5, 6, 7]
        label = c == 6 ? "(nominal)" : c == 5 ? "(desfalcado)" : ""
        imprimir_mg(c, λ, μ, cv2_s, label)
    end

    # --- Pico 14–16h ---
    pico = ri[ri.hora .∈ Ref([14, 15]), :]
    λ_p  = nrow(pico) / (n_dias * 2 * 60.0)
    μ_p  = 1.0 / mean(pico.atend_min)
    cv2_p = (std(pico.atend_min) / mean(pico.atend_min))^2

    println("\n" * "="^60)
    println("PICO 14–16h")
    println("="^60)
    @printf "  λ_pico = %.3f/hora | μ_pico = %.3f/hora | CV²_S = %.4f\n" λ_p*60 μ_p*60 cv2_p
    for c in [5, 6]
        imprimir_mg(c, λ_p, μ_p, cv2_p, "pico")
    end

    # --- Por hora ---
    analise_por_hora(ri, 6, cv2_s)

    # --- CV² por fila ---
    println("\n" * "="^60)
    println("CV² POR FILA")
    println("="^60)
    for (fila, grp) in pairs(groupby(df_clean, "Fila"))
        s    = Float64.(grp.atend_min)
        cv2  = (std(s) / mean(s))^2
        tipo = abs(cv2 - 1) < 0.15 ? "~M/M (exp)" :
               cv2 < 1               ? "G sub-exp" : "G super-exp (heavy tail)"
        @printf "  %-55s  CV²=%.3f  → %s\n" first(fila)[1][1:min(55,end)] cv2 tipo
    end

    # --- Sensibilidade ---
    sensibilidade_cv2(λ, μ, 6)

    println("\n✓ Pipeline concluído.")
end

main()
