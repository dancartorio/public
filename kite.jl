# Experimento: Velocidade Mínima do Vento para Sustentar uma Pipa
# Baseado na análise de forças aerodinâmicas

using Printf
using Plots
using LaTeXStrings
using Measures

println("🪁 EXPERIMENTO: VELOCIDADE MÍNIMA DO VENTO PARA PIPA")
println("=" ^ 60)

# Parâmetros da pipa
println("\n📏 PARÂMETROS DA PIPA:")
massa_pipa = 0.123  # kg
area_pipa_cm2 = 6272  # cm²
area_pipa_m2 = area_pipa_cm2 / 10000  # Conversão para m²

@printf("• Massa da pipa: %.3f kg\n", massa_pipa)
@printf("• Área da pipa: %d cm² = %.4f m²\n", area_pipa_cm2, area_pipa_m2)

# Constantes físicas
println("\n🌍 CONSTANTES FÍSICAS:")
g = 9.81  # m/s² - aceleração da gravidade
rho_ar = 1.13  # kg/m³ - densidade do ar ao nível do mar densidade padrão de 1.225 kg/m
CL = 0.8  # coeficiente de sustentação (adimensional)

@printf("• Aceleração da gravidade: %.2f m/s²\n", g)
@printf("• Densidade do ar: %.3f kg/m³\n", rho_ar)
@printf("• Coeficiente de sustentação: %.1f\n", CL)

# Cálculo da força peso
println("\n⚖️  CÁLCULO DA FORÇA PESO:")
peso = massa_pipa * g
@printf("• Peso (W) = m × g = %.3f × %.2f = %.4f N\n", massa_pipa, g, peso)

# Fórmula da força de sustentação
println("\n🌪️  FORÇA DE SUSTENTAÇÃO:")
println("• Fórmula: L = ½ × ρ × V² × CL × A")
println("• Para equilíbrio: L = W (sustentação = peso)")
println("• Isolando V²: V² = 2W / (ρ × A × CL)")

# Cálculo da velocidade
println("\n🧮 CÁLCULOS:")
denominador = rho_ar * area_pipa_m2 * CL
numerador = 2 * peso
V_quadrado = numerador / denominador
V_ms = sqrt(V_quadrado)

@printf("• Denominador: ρ × A × CL = %.3f × %.4f × %.1f = %.6f\n", 
        rho_ar, area_pipa_m2, CL, denominador)
@printf("• Numerador: 2W = 2 × %.4f = %.4f\n", peso, numerador)
@printf("• V² = %.4f / %.6f = %.2f\n", numerador, denominador, V_quadrado)
@printf("• V = √%.2f = %.2f m/s\n", V_quadrado, V_ms)

# Conversão para km/h
V_kmh = V_ms * 3.6
@printf("• V = %.2f m/s × 3.6 = %.2f km/h\n", V_ms, V_kmh)

# Resultados finais
println("\n🎯 RESULTADOS FINAIS:")
println("=" ^ 40)
@printf("• Velocidade mínima do vento: %.2f m/s\n", V_ms)
@printf("• Velocidade mínima do vento: %.2f km/h\n", V_kmh)

# Análise adicional: variação com diferentes parâmetros
println("\n📊 ANÁLISE DE SENSIBILIDADE:")
println("Como a velocidade varia com diferentes parâmetros:\n")

# Função para calcular velocidade
function calcular_velocidade_vento(massa, area_m2, coef_sust, densidade_ar=1.225)
    peso = massa * 9.81
    V2 = (2 * peso) / (densidade_ar * area_m2 * coef_sust)
    return sqrt(V2)
end

# Variação da massa
println("1️⃣ Variação da MASSA (mantendo área e CL constantes):")
massas = [0.100, 0.125, 0.150, 0.175, 0.200]  # kg
for m in massas
    v = calcular_velocidade_vento(m, area_pipa_m2, CL)
    @printf("   Massa: %.3f kg → Vento: %.2f m/s (%.1f km/h)\n", m, v, v*3.6)
end

# Variação da área
println("\n2️⃣ Variação da ÁREA (mantendo massa e CL constantes):")
areas_cm2 = [1200, 1400, 1568, 1800, 2000]  # cm²
for a_cm2 in areas_cm2
    a_m2 = a_cm2 / 10000
    v = calcular_velocidade_vento(massa_pipa, a_m2, CL)
    @printf("   Área: %d cm² → Vento: %.2f m/s (%.1f km/h)\n", a_cm2, v, v*3.6)
end

# Variação do coeficiente de sustentação
println("\n3️⃣ Variação do COEFICIENTE DE SUSTENTAÇÃO (mantendo massa e área constantes):")
coeficientes = [0.6, 0.7, 0.8, 0.9, 1.0]
for cl in coeficientes
    v = calcular_velocidade_vento(massa_pipa, area_pipa_m2, cl)
    @printf("   CL: %.1f → Vento: %.2f m/s (%.1f km/h)\n", cl, v, v*3.6)
end

# Interpretação prática
println("\n💡 INTERPRETAÇÃO PRÁTICA:")
println("=" ^ 40)
if V_kmh < 10
    println("• Vento MUITO FRACO - Difícil de empinar")
elseif V_kmh < 15
    println("• Vento FRACO - Adequado para pipas leves")
elseif V_kmh < 25
    println("• Vento MODERADO - Ideal para a maioria das pipas")
elseif V_kmh < 35
    println("• Vento FORTE - Bom para pipas grandes")
else
    println("• Vento MUITO FORTE - Cuidado com a segurança!")
end

@printf("\nSua pipa precisa de %.1f km/h - um vento %s.\n", 
        V_kmh, V_kmh < 20 ? "bem suave" : "moderado")

println("\n🔬 EXPERIMENTO CONCLUÍDO!")
println("Agora você sabe exatamente que vento precisa para sua pipa voar! 🪁")

# GRÁFICOS PARA VISUALIZAÇÃO DOS RESULTADOS
println("\n📊 GERANDO GRÁFICOS...")

# Configuração do tema dos gráficos com margens personalizadas
theme(:bright)
default(fontfamily="Computer Modern", linewidth=2, framestyle=:box, 
        grid=true, gridwidth=1, gridcolor=:lightgray, gridalpha=0.3,
        margin=5mm, left_margin=10mm, bottom_margin=8mm, top_margin=5mm)

# Gráfico 1: Velocidade do vento vs Massa da pipa
massas_plot = 0.05:0.01:0.30  # kg
velocidades_massa = [calcular_velocidade_vento(m, area_pipa_m2, CL) * 3.6 for m in massas_plot]

p1 = plot(massas_plot, velocidades_massa, 
         title="Velocidade do Vento × Massa da Pipa",
         xlabel="Massa da Pipa (kg)", 
         ylabel="Velocidade Mínima do Vento (km/h)",
         label="V(massa)", color=:blue, linewidth=3,
         margin=8mm, left_margin=12mm)
scatter!([massa_pipa], [V_kmh], markersize=8, color=:red, 
         label="Sua pipa ($(massa_pipa) kg)", markerstrokewidth=2)
hline!([15], linestyle=:dash, color=:orange, alpha=0.7, 
       label="Vento moderado (15 km/h)")
annotate!(massa_pipa+0.02, V_kmh+2, 
          text("$(round(V_kmh,digits=1)) km/h", 10, :red))

# Gráfico 2: Velocidade do vento vs Área da pipa
areas_plot = 800:50:2500  # cm²
areas_m2_plot = areas_plot ./ 10000
velocidades_area = [calcular_velocidade_vento(massa_pipa, a, CL) * 3.6 for a in areas_m2_plot]

p2 = plot(areas_plot, velocidades_area,
         title="Velocidade do Vento × Área da Pipa",
         xlabel="Área da Pipa (cm²)",
         ylabel="Velocidade Mínima do Vento (km/h)",
         label="V(área)", color=:green, linewidth=3,
         margin=8mm, left_margin=12mm)
scatter!([area_pipa_cm2], [V_kmh], markersize=8, color=:red,
         label="Sua pipa ($(area_pipa_cm2) cm²)", markerstrokewidth=2)
hline!([15], linestyle=:dash, color=:orange, alpha=0.7,
       label="Vento moderado (15 km/h)")
annotate!(area_pipa_cm2+100, V_kmh+2,
          text("$(round(V_kmh,digits=1)) km/h", 10, :red))

# Gráfico 3: Forças vs Velocidade do vento
velocidades_vento = 0:0.5:25  # m/s
forcas_sustentacao = [0.5 * rho_ar * v^2 * CL * area_pipa_m2 for v in velocidades_vento]
peso_linha = fill(peso, length(velocidades_vento))

p3 = plot(velocidades_vento, forcas_sustentacao,
         title="Forças Atuantes na Pipa",
         xlabel="Velocidade do Vento (m/s)",
         ylabel="Força (N)",
         label="Força de Sustentação", color=:blue, linewidth=3,
         margin=8mm, left_margin=12mm)
plot!(velocidades_vento, peso_linha,
      label="Peso da Pipa", color=:red, linewidth=3, linestyle=:dash)
vline!([V_ms], color=:green, linewidth=2, alpha=0.8,
       label="Velocidade crítica")
scatter!([V_ms], [peso], markersize=8, color=:purple,
         label="Ponto de equilíbrio", markerstrokewidth=2)
annotate!(V_ms+1, peso+0.2,
          text("$(round(V_ms,digits=1)) m/s", 10, :green))

# Gráfico 4: Mapa de vento (velocidade em diferentes condições)
coefs_plot = 0.4:0.1:1.2
massas_grid = 0.08:0.02:0.25
vento_grid = zeros(length(massas_grid), length(coefs_plot))

for (i, m) in enumerate(massas_grid)
    for (j, cl) in enumerate(coefs_plot)
        vento_grid[i,j] = calcular_velocidade_vento(m, area_pipa_m2, cl) * 3.6
    end
end

p4 = heatmap(coefs_plot, massas_grid, vento_grid,
            title="Mapa de Velocidade do Vento Necessário",
            xlabel="Coeficiente de Sustentação (CL)",
            ylabel="Massa da Pipa (kg)",
            color=:viridis,
            colorbar_title="Velocidade (km/h)",
            margin=8mm, left_margin=12mm, right_margin=15mm)
scatter!([CL], [massa_pipa], markersize=10, color=:red, markerstroke=:white,
         markerstrokewidth=3, label="Sua pipa")

# Gráfico 5: Classificação de ventos com escala Beaufort
beaufort_velocidades = [0, 2, 6, 12, 20, 29, 39, 50, 62, 75, 89, 103, 118]  # km/h
beaufort_nomes = ["Calmaria", "Brisa leve", "Brisa fraca", "Brisa moderada", 
                 "Brisa forte", "Vento fresco", "Vento forte", "Vento muito forte",
                 "Ventania", "Ventania forte", "Tempestade", "Tempestade violenta", "Furacão"]
cores_beaufort = [:lightblue, :lightgreen, :yellow, :orange, :red, :purple, :brown, 
                 :black, :gray, :darkgray, :maroon, :darkred, :black]

p5 = bar(1:length(beaufort_velocidades)-1, 
         diff(beaufort_velocidades),
         bottom=beaufort_velocidades[1:end-1],
         title="Escala de Beaufort - Classificação de Ventos",
         xlabel="Força na Escala Beaufort",
         ylabel="Velocidade do Vento (km/h)",
         color=cores_beaufort[1:end-1],
         alpha=0.7,
         legend=false,
         xticks=(1:12, string.(0:11)),
         margin=10mm, left_margin=12mm, bottom_margin=12mm)

hline!([V_kmh], color=:red, linewidth=4, alpha=0.8,
       label="Vento necessário para sua pipa")
annotate!(6, V_kmh+5, text("Sua pipa: $(round(V_kmh,digits=1)) km/h", 12, :red))

# Organizando os gráficos com layout otimizado
layout = @layout [a{0.5w} b{0.5w}; c{0.5w} d{0.5w}; e{1.0w,0.35h}]
p_final = plot(p1, p2, p3, p4, p5, layout=layout, 
               size=(1400, 1200),
               plot_title="🪁 ANÁLISE COMPLETA: PIPA E VELOCIDADE DO VENTO",
               plot_titlefontsize=16,
               margin=5mm)

display(p_final)

# Salvando o gráfico
savefig(p_final, "analise_pipa_vento.png")
println("📁 Gráfico salvo como 'analise_pipa_vento.png'")

# Gráfico bonus: Diagrama polar do vento
println("\n🌪️ Gráfico Bonus: Rosa dos Ventos")
angulos = 0:15:345  # graus
velocidades_polares = 10 .+ 5 .* sin.(deg2rad.(angulos .* 2)) .+ 
                     3 .* cos.(deg2rad.(angulos .* 3))  # Simulação de ventos

p_polar = plot(angulos, velocidades_polares, 
              projection=:polar,
              title="Rosa dos Ventos - Velocidades Simuladas",
              linewidth=3, color=:blue, fill=true, alpha=0.3,
              size=(600, 600), margin=10mm)
plot!(angulos, fill(V_kmh, length(angulos)), 
      projection=:polar, color=:red, linewidth=2, linestyle=:dash,
      label="Velocidade mínima necessária")

display(p_polar)
savefig(p_polar, "rosa_dos_ventos.png")
println("📁 Rosa dos ventos salva como 'rosa_dos_ventos.png'")