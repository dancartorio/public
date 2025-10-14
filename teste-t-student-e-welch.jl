using Plots, Distributions, Statistics, Printf

# Configuração do tema de plots
default(fontfamily="Computer Modern", 
        framestyle=:box, 
        grid=true, 
        gridstyle=:dot, 
        gridalpha=0.3,
        size=(1200, 900))

# ============================================================================
# DADOS DO PROBLEMA
# ============================================================================
n1, x̄1, s1 = 10, 85.0, 4.5
n2, x̄2, s2 = 12, 80.0, 6.2
α = 0.05
Δx̄ = x̄1 - x̄2

println("="^70)
println("TESTE DE HIPÓTESES: COMPARAÇÃO DE DUAS MÉDIAS")
println("="^70)
println("\nGrupo A: n₁ = $n1, x̄₁ = $x̄1, s₁ = $s1")
println("Grupo B: n₂ = $n2, x̄₂ = $x̄2, s₂ = $s2")
println("\nH₀: μ₁ = μ₂")
println("Hₐ: μ₁ ≠ μ₂")
println("α = $α (teste bicaudal)")
println("\nDiferença observada: Δx̄ = $(Δx̄)")

# ============================================================================
# 1. TESTE t DE STUDENT (Variâncias Pooled)
# ============================================================================
println("\n" * "="^70)
println("1. TESTE t DE STUDENT (VARIÂNCIAS IGUAIS - POOLED)")
println("="^70)

# Variância pooled
s1² = s1^2
s2² = s2^2
sp² = ((n1 - 1) * s1² + (n2 - 1) * s2²) / (n1 + n2 - 2)
sp = sqrt(sp²)

println("\nCálculo da variância pooled:")
println("  s₁² = $(s1²)")
println("  s₂² = $(s2²)")
println("  sp² = $(@sprintf("%.4f", sp²))")
println("  sp = $(@sprintf("%.4f", sp))")

# Erro padrão pooled
SE_pooled = sp * sqrt(1/n1 + 1/n2)
println("\nErro padrão pooled:")
println("  SE = $(@sprintf("%.4f", SE_pooled))")

# Estatística t pooled
t_pooled = Δx̄ / SE_pooled
df_pooled = n1 + n2 - 2

println("\nEstatística t:")
println("  t = $(@sprintf("%.4f", t_pooled))")
println("  df = $df_pooled")

# P-valor
dist_pooled = TDist(df_pooled)
p_pooled = 2 * ccdf(dist_pooled, abs(t_pooled))
println("  p-valor (bicaudal) = $(@sprintf("%.4f", p_pooled))")

# Valor crítico
t_crit_pooled = quantile(dist_pooled, 1 - α/2)
println("  t crítico (α=$α) = ±$(@sprintf("%.4f", t_crit_pooled))")

if p_pooled < α
    println("\n  ✓ DECISÃO: Rejeitar H₀ (p < α)")
else
    println("\n  ✗ DECISÃO: Não rejeitar H₀ (p ≥ α)")
end

# ============================================================================
# 2. TESTE DE WELCH (Variâncias Desiguais)
# ============================================================================
println("\n" * "="^70)
println("2. TESTE DE WELCH (VARIÂNCIAS DESIGUAIS)")
println("="^70)

# Erro padrão Welch
SE_welch = sqrt(s1²/n1 + s2²/n2)
println("\nErro padrão Welch:")
println("  SE = $(@sprintf("%.4f", SE_welch))")

# Estatística t Welch
t_welch = Δx̄ / SE_welch

# Graus de liberdade Satterthwaite
numerador = (s1²/n1 + s2²/n2)^2
denominador = (s1²/n1)^2/(n1-1) + (s2²/n2)^2/(n2-1)
df_welch = numerador / denominador

println("\nEstatística t:")
println("  t = $(@sprintf("%.4f", t_welch))")
println("  df (Satterthwaite) = $(@sprintf("%.2f", df_welch))")

# P-valor
dist_welch = TDist(df_welch)
p_welch = 2 * ccdf(dist_welch, abs(t_welch))
println("  p-valor (bicaudal) = $(@sprintf("%.4f", p_welch))")

# Valor crítico
t_crit_welch = quantile(dist_welch, 1 - α/2)
println("  t crítico (α=$α) = ±$(@sprintf("%.4f", t_crit_welch))")

if p_welch < α
    println("\n  ✓ DECISÃO: Rejeitar H₀ (p < α)")
else
    println("\n  ✗ DECISÃO: Não rejeitar H₀ (p ≥ α)")
end

# ============================================================================
# 3. COMPARAÇÃO DOS RESULTADOS
# ============================================================================
println("\n" * "="^70)
println("RESUMO COMPARATIVO")
println("="^70)
println("\n┌─────────────────┬──────────┬─────────┬─────────┐")
println("│ Método          │ t        │ df      │ p-valor │")
println("├─────────────────┼──────────┼─────────┼─────────┤")
println(@sprintf("│ Student (pooled)│ %.4f   │ %-7.0f │ %.4f  │", 
        t_pooled, df_pooled, p_pooled))
println(@sprintf("│ Welch           │ %.4f   │ %-7.2f │ %.4f  │", 
        t_welch, df_welch, p_welch))
println("└─────────────────┴──────────┴─────────┴─────────┘")

# ============================================================================
# VISUALIZAÇÕES
# ============================================================================

# Plot 1: Distribuições dos grupos com médias
p1 = plot(title="Distribuição dos Grupos A e B", 
          xlabel="Pontuação", ylabel="Densidade",
          legend=:topright)

x_range = 65:0.1:100
plot!(p1, x_range, pdf.(Normal(x̄1, s1), x_range), 
      label="Grupo A (μ=$x̄1, σ=$s1)", lw=2.5, color=:blue, alpha=0.7)
plot!(p1, x_range, pdf.(Normal(x̄2, s2), x_range), 
      label="Grupo B (μ=$x̄2, σ=$s2)", lw=2.5, color=:red, alpha=0.7)
vline!(p1, [x̄1], label="", lw=2, ls=:dash, color=:blue)
vline!(p1, [x̄2], label="", lw=2, ls=:dash, color=:red)

# Plot 2: Distribuição t de Student (pooled)
p2 = plot(title="Teste t de Student (df=$df_pooled)", 
          xlabel="Estatística t", ylabel="Densidade",
          legend=:topright)

t_range = -4:0.01:4
plot!(p2, t_range, pdf.(dist_pooled, t_range), 
      fill=(0, 0.2, :lightblue), label="Distribuição t",
      lw=2, color=:blue)
vline!(p2, [-t_crit_pooled, t_crit_pooled], 
       label="Região crítica (α=$α)", lw=2, ls=:dash, color=:orange)
vline!(p2, [t_pooled], label="t observado = $(@sprintf("%.3f", t_pooled))", 
       lw=3, color=:red)
annotate!(p2, t_pooled, 0.35, text("p=$(@sprintf("%.4f", p_pooled))", 10, :red))

# Plot 3: Distribuição t de Welch
p3 = plot(title="Teste de Welch (df=$(@sprintf("%.2f", df_welch)))", 
          xlabel="Estatística t", ylabel="Densidade",
          legend=:topright)

plot!(p3, t_range, pdf.(dist_welch, t_range), 
      fill=(0, 0.2, :lightgreen), label="Distribuição t",
      lw=2, color=:green)
vline!(p3, [-t_crit_welch, t_crit_welch], 
       label="Região crítica (α=$α)", lw=2, ls=:dash, color=:orange)
vline!(p3, [t_welch], label="t observado = $(@sprintf("%.3f", t_welch))", 
       lw=3, color=:red)
annotate!(p3, t_welch, 0.35, text("p=$(@sprintf("%.4f", p_welch))", 10, :red))

# Plot 4: Comparação dos p-valores
p4 = bar(["Student\n(pooled)", "Welch"], 
         [p_pooled, p_welch],
         title="Comparação dos P-valores",
         ylabel="P-valor",
         legend=false,
         color=[:steelblue, :seagreen],
         ylims=(0, 0.06))
hline!(p4, [α], label="α = $α", lw=2, ls=:dash, color=:red)
annotate!(p4, 1, p_pooled + 0.003, 
          text(@sprintf("%.4f", p_pooled), 10, :black, :center))
annotate!(p4, 2, p_welch + 0.003, 
          text(@sprintf("%.4f", p_welch), 10, :black, :center))

# Plot 5: Comparação das estatísticas t
p5 = bar(["Student\n(pooled)", "Welch"], 
         [t_pooled, t_welch],
         title="Comparação das Estatísticas t",
         ylabel="Valor t",
         legend=false,
         color=[:steelblue, :seagreen],
         ylims=(0, 2.5))
hline!(p5, [t_crit_pooled], label="t crítico", lw=2, ls=:dash, color=:red)
annotate!(p5, 1, t_pooled + 0.1, 
          text(@sprintf("%.4f", t_pooled), 10, :black, :center))
annotate!(p5, 2, t_welch + 0.1, 
          text(@sprintf("%.4f", t_welch), 10, :black, :center))

# Plot 6: Intervalos de confiança
ic_pooled = Δx̄ .+ [-1, 1] .* t_crit_pooled * SE_pooled
ic_welch = Δx̄ .+ [-1, 1] .* t_crit_welch * SE_welch

p6 = plot(title="Intervalos de Confiança 95% para Δμ",
          xlabel="Diferença de Médias (μ₁ - μ₂)",
          ylabel="Método",
          yticks=(1:2, ["Student", "Welch"]),
          ylims=(0.5, 2.5),
          legend=:bottomright)
plot!(p6, ic_pooled, [1, 1], lw=4, color=:steelblue, label="Student IC 95%")
scatter!(p6, [Δx̄], [1], color=:steelblue, ms=8, label="")
plot!(p6, ic_welch, [2, 2], lw=4, color=:seagreen, label="Welch IC 95%")
scatter!(p6, [Δx̄], [2], color=:seagreen, ms=8, label="")
vline!(p6, [0], lw=2, ls=:dash, color=:red, label="H₀: Δμ = 0")

# Combinar todos os plots
plot(p1, p2, p3, p4, p5, p6, 
     layout=(3, 2), 
     size=(1400, 1200),
     margin=5Plots.mm)