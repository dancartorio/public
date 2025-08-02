# Calculadora de Propriedades do Exoplaneta K2-260 b com Visualizações
# Com base nos dados observados do seu notebook

using Printf
using Plots
using StatsPlots
theme(:bright)

println("🪐 CALCULADORA DE PROPRIEDADES DO EXOPLANETA K2-260 b")
println("="^60)

# Valores observados/calculados do seu notebook
periodo_orbital = 2.627  # dias
raio_planeta_jupiter = 1.74  # RJ (do seu cálculo)
massa_estrela = 1.39  # M☉
raio_estrela = 1.69  # R☉
temp_estrela = 6370  # K

# Constantes físicas
const G = 6.67430e-11  # m³/kg⋅s² - Constante gravitacional
const M_sol = 1.989e30  # kg - Massa do Sol
const R_jupiter = 71492000  # m - Raio de Júpiter
const M_jupiter = 1.898e27  # kg - Massa de Júpiter
const AU = 149597870700  # m - Unidade Astronômica
const sigma = 5.670374419e-8  # W⋅m⁻²⋅K⁻⁴ - Constante de Stefan-Boltzmann
const R_sol = 695700000  # m - Raio do Sol

println("\n📊 PARÂMETROS OBSERVADOS:")
println("Período orbital: $periodo_orbital dias")
println("Raio do planeta: $raio_planeta_jupiter RJ")
println("Massa da estrela: $massa_estrela M☉")
println("Raio da estrela: $raio_estrela R☉")
println("Temperatura da estrela: $temp_estrela K")

# CÁLCULOS DAS PROPRIEDADES
periodo_segundos = periodo_orbital * 24 * 3600
massa_estrela_kg = massa_estrela * M_sol
semieixo_maior = ((G * massa_estrela_kg * periodo_segundos^2) / (4 * π^2))^(1/3)
semieixo_maior_AU = semieixo_maior / AU
semieixo_maior_milhoes_km = semieixo_maior / 1e9

velocidade_orbital = (2 * π * semieixo_maior) / periodo_segundos
velocidade_orbital_km_s = velocidade_orbital / 1000

raio_planeta_km = raio_planeta_jupiter * R_jupiter / 1000

albedo = 0.2
raio_estrela_m = raio_estrela * R_sol
temp_equilibrio = temp_estrela * ((1 - albedo) / 4)^0.25 * sqrt(raio_estrela_m / (2 * semieixo_maior))

fluxo_estelar = (sigma * temp_estrela^4 * raio_estrela_m^2) / (4 * π * semieixo_maior^2)
fluxo_terra = 1361
fluxo_relativo_terra = fluxo_estelar / fluxo_terra

massa_estimada_jupiter = raio_planeta_jupiter^2.06
massa_planeta_kg = massa_estimada_jupiter * M_jupiter
raio_planeta_m = raio_planeta_jupiter * R_jupiter
gravidade_superficie = (G * massa_planeta_kg) / raio_planeta_m^2
gravidade_relativa = gravidade_superficie / 9.81

volume_planeta_m3 = (4/3) * π * raio_planeta_m^3
densidade_planeta = massa_planeta_kg / volume_planeta_m3
densidade_jupiter = 1326
densidade_relativa = densidade_planeta / densidade_jupiter

velocidade_escape = sqrt(2 * G * massa_planeta_kg / raio_planeta_m) / 1000

println("\n🔬 PROPRIEDADES CALCULADAS:")
println("-"^40)
@printf("🛰️  Distância orbital: %.4f UA (%.2f milhões de km)\n", semieixo_maior_AU, semieixo_maior_milhoes_km)
@printf("🚀 Velocidade orbital: %.1f km/s\n", velocidade_orbital_km_s)
@printf("📏 Raio do planeta: %.0f km (%.2f × Júpiter)\n", raio_planeta_km, raio_planeta_jupiter)
@printf("🌡️  Temperatura de equilíbrio: %.0f K (%.0f °C)\n", temp_equilibrio, temp_equilibrio - 273.15)
@printf("☀️  Fluxo estelar recebido: %.0f × o fluxo da Terra\n", fluxo_relativo_terra)
@printf("⚖️  Massa estimada: %.2f MJ\n", massa_estimada_jupiter)
@printf("🏋️  Gravidade superficial: %.1f × Terra\n", gravidade_relativa)
@printf("🧱 Densidade: %.2f × Júpiter (%.0f kg/m³)\n", densidade_relativa, densidade_planeta)
@printf("🚀 Velocidade de escape: %.1f km/s\n", velocidade_escape)

# VISUALIZAÇÕES
println("\n📈 GERANDO VISUALIZAÇÕES...")

# 1. COMPARAÇÃO DE TAMANHOS
planetas_nomes = ["Terra", "Júpiter", "K2-260 b"]
planetas_raios = [6371, 71492, raio_planeta_km]  # km
planetas_cores = [:blue, :orange, :red]

# Gráfico de comparação de raios
p1 = bar(planetas_nomes, planetas_raios, 
         color=planetas_cores,
         title="Comparação de Raios Planetários",
         ylabel="Raio (km)",
         legend=false,
         size=(600, 400))

# 2. COMPARAÇÃO DE MASSAS
massas_jupiter = [0.00315, 1.0, massa_estimada_jupiter]  # em massas de Júpiter
p2 = bar(planetas_nomes, massas_jupiter,
         color=planetas_cores,
         title="Comparação de Massas Planetárias", 
         ylabel="Massa (MJ)",
         legend=false,
         size=(600, 400))

# 3. TEMPERATURA vs DISTÂNCIA ORBITAL
# Dados de comparação com outros planetas
distancias_AU = [0.387, 0.723, 1.0, 1.524, semieixo_maior_AU]  # Mercúrio, Vênus, Terra, Marte, K2-260b
temperaturas = [440, 737, 288, 210, temp_equilibrio]
nomes_planetas = ["Mercúrio", "Vênus", "Terra", "Marte", "K2-260 b"]
cores_temp = [:gray, :yellow, :blue, :red, :darkred]

p3 = scatter(distancias_AU, temperaturas,
            color=cores_temp,
            markersize=8,
            title="Temperatura vs Distância da Estrela",
            xlabel="Distância (UA)",
            ylabel="Temperatura (K)",
            legend=false,
            size=(600, 400),
            xscale=:log10)

# Adicionar rótulos
for i in 1:length(nomes_planetas)
    annotate!(p3, distancias_AU[i], temperaturas[i] + 50, 
              text(nomes_planetas[i], 8, :center))
end

# 4. ÓRBITA COMPARATIVA
# Simular órbitas (circulares simplificadas)
theta = 0:0.1:2π

# Terra
x_terra = cos.(theta) * 1.0
y_terra = sin.(theta) * 1.0

# K2-260 b
x_k2260b = cos.(theta) * semieixo_maior_AU
y_k2260b = sin.(theta) * semieixo_maior_AU

p4 = plot(x_terra, y_terra, 
          color=:blue, 
          linewidth=2, 
          label="Órbita da Terra",
          title="Comparação de Órbitas", 
          xlabel="Distância (UA)", 
          ylabel="Distância (UA)",
          aspect_ratio=:equal,
          size=(600, 600))

plot!(p4, x_k2260b, y_k2260b, 
      color=:red, 
      linewidth=2, 
      label="Órbita K2-260 b")

# Adicionar estrelas no centro
scatter!(p4, [0], [0], 
         color=:yellow, 
         markersize=10, 
         label="Estrela")

# 5. PROPRIEDADES FÍSICAS - GRÁFICO RADAR/POLAR
propriedades = ["Raio\n(vs Júpiter)", "Massa\n(vs Júpiter)", "Gravidade\n(vs Terra)", 
                "Temperatura\n(vs 1000K)", "Velocidade\n(vs 100 km/s)", "Densidade\n(vs Júpiter)"]
valores_normalizados = [raio_planeta_jupiter, massa_estimada_jupiter, gravidade_relativa, 
                       temp_equilibrio/1000, velocidade_orbital_km_s/100, densidade_relativa]

p5 = bar(propriedades, valores_normalizados,
         color=:purple,
         title="Propriedades Físicas do K2-260 b",
         ylabel="Valor Relativo",
         legend=false,
         size=(800, 500),
         xrotation=45)

# 6. FLUXO ESTELAR AO LONGO DA ÓRBITA
# Como o planeta provavelmente tem acoplamento de maré, o fluxo varia pouco
# Mas vamos mostrar como seria se a órbita fosse elíptica
dias_orbita = 0:0.1:periodo_orbital
fluxo_normalizado = ones(length(dias_orbita)) * fluxo_relativo_terra

p6 = plot(dias_orbita, fluxo_normalizado,
          color=:orange,
          linewidth=3,
          title="Fluxo Estelar Durante a Órbita",
          xlabel="Tempo (dias)",
          ylabel="Fluxo (× Terra)",
          legend=false,
          size=(600, 350))

# Combinar gráficos em um layout
layout_plots = plot(p1, p2, p3, p4, p5, p6, 
                    layout=(3, 2), 
                    size=(1200, 900),
                    plot_title="Análise Completa do Exoplaneta K2-260 b")

display(layout_plots)

# 7. GRÁFICO ESPECIAL: ZONA HABITÁVEL
println("\n🌍 ANÁLISE DA ZONA HABITÁVEL:")

# Limites da zona habitável para uma estrela tipo F6V
# Baseado na luminosidade da estrela
luminosidade_estrela = (raio_estrela^2) * (temp_estrela/5778)^4  # L☉
zona_hab_interna = sqrt(luminosidade_estrela / 1.1)  # UA
zona_hab_externa = sqrt(luminosidade_estrela / 0.53)  # UA

@printf("Zona habitável: %.3f - %.3f UA\n", zona_hab_interna, zona_hab_externa)
@printf("K2-260 b está %.1f × mais próximo que o limite interno!\n", zona_hab_interna / semieixo_maior_AU)

# Gráfico da zona habitável
p_zh = plot(xlims=(-0.5, 2.0), ylims=(-2.0, 2.0), aspect_ratio=:equal)

# Zona habitável (anel verde)
theta_zh = 0:0.01:2π
x_zh_int = cos.(theta_zh) * zona_hab_interna
y_zh_int = sin.(theta_zh) * zona_hab_interna
x_zh_ext = cos.(theta_zh) * zona_hab_externa
y_zh_ext = sin.(theta_zh) * zona_hab_externa

plot!(p_zh, x_zh_ext, y_zh_ext, color=:green, alpha=0.3, fillrange=0, label="Zona Habitável")
plot!(p_zh, x_zh_int, y_zh_int, color=:white, fillrange=0, label="")

# Órbita do planeta
plot!(p_zh, x_k2260b, y_k2260b, color=:red, linewidth=3, label="K2-260 b")

# Posição da estrela
scatter!(p_zh, [0], [0], color=:yellow, markersize=15, label="Estrela K2-260")

# Referências
plot!(p_zh, x_terra, y_terra, color=:blue, linestyle=:dash, alpha=0.5, label="Órbita da Terra")

title!(p_zh, "Posição do K2-260 b em Relação à Zona Habitável")
xlabel!(p_zh, "Distância (UA)")
ylabel!(p_zh, "Distância (UA)")

display(p_zh)

println("\n" * "="^60)
println("🎉 Análise visual concluída!")
println("O K2-260 b é um Hot Jupiter extremo, orbitando muito próximo de sua estrela,")
println("com temperatura superficial de ~$(Int(temp_equilibrio)) K - mais quente que muitas estrelas!")


# 🌍 Características do Exoplaneta — Estimativas Derivadas

## ✅ Informações já estimadas:

- **Período orbital**: ~2,627 dias  
- **Raio do planeta**: ~1,74 R<sub>Júpiter</sub>  
- **Número de trânsitos observados**: 30  
- **Profundidade média do trânsito**: 0,0112  
- **Raio da estrela**: 1,69 R<sub>☉</sub>  
- **Temperatura da estrela**: 6370 K  
- **Massa da estrela**: 1,39 M<sub>☉</sub>  
- **Massa do planeta**: 1,42 M<sub>Júpiter</sub>  

---

## 🔍 Estimativas adicionais:

### 1. 🪐 Distância estrela-planeta (semi-eixo maior)

Usando a 3ª Lei de Kepler simplificada para massas solares e período em anos:

\[
a = \left( P_{\text{anos}}^2 \cdot M_\star \right)^{1/3}
\]

- \( P = 2{,}627 \) dias = 0,00719 anos  
- \( M_\star = 1{,}39\ M_\odot \)

\[
a \approx (0{,}00719^2 \cdot 1{,}39)^{1/3} \approx 0{,}0385\ \text{UA}
\]

📌 **Distância aproximada: 0,0385 UA**

---

### 2. 🚀 Velocidade orbital do planeta

\[
v = \frac{2\pi a}{P}
\]

- \( a = 0{,}0385\ \text{UA} = 5{,}76 \times 10^9\ \text{m} \)  
- \( P = 2{,}627 \times 86400 = 226972\ \text{s} \)

\[
v \approx \frac{2\pi \cdot 5{,}76 \times 10^9}{226972} \approx 159{,}4\ \text{km/s}
\]

📌 **Velocidade orbital: ~159 km/s**

---

### 3. 🌡️ Temperatura de equilíbrio do planeta

\[
T_{\text{eq}} = T_\star \cdot \sqrt{\frac{R_\star}{2a}} \cdot (1 - A)^{1/4}
\]

- \( T_\star = 6370\ K \)  
- \( R_\star = 1{,}69\ R_\odot = 1{,}17 \times 10^9\ m \)  
- \( a = 5{,}76 \times 10^9\ m \)  
- Albedo \( A = 0{,}2 \)

\[
T_{\text{eq}} \approx 6370 \cdot \sqrt{0{,}1016} \cdot 0{,}945 \approx 1910\ K
\]

📌 **Temperatura de equilíbrio: ~1910 K**

---

### 4. ⚖️ Densidade do planeta

\[
\rho = \frac{M}{\frac{4}{3}\pi R^3}
\]

- \( M = 1{,}42\ M_J = 2{,}70 \times 10^{27}\ \text{kg} \)  
- \( R = 1{,}74\ R_J = 1{,}244 \times 10^8\ \text{m} \)

\[
\rho \approx \frac{2{,}70 \times 10^{27}}{\frac{4}{3}\pi (1{,}244 \times 10^8)^3} \approx 1{,}33\ \text{g/cm}^3
\]

📌 **Densidade estimada: ~1,33 g/cm³**

---

### 5. ⏱️ Duração estimada do trânsito

Aproximação para órbita circular e trânsito central:

\[
T_{\text{dur}} \approx \frac{R_\star}{\pi a} \cdot P
\]

Com:
- \( R_\star = 1{,}17 \times 10^9\ m \)  
- \( a = 5{,}76 \times 10^9\ m \)  
- \( P = 226972\ s \)

\[
T_{\text{dur}} \approx \frac{1{,}17}{\pi \cdot 5{,}76} \cdot 226972 \approx 14{,}7\ \text{mil s} \approx 4{,}1\ h
\]

📌 **Duração estimada do trânsito: ~4,1 horas**

---

## 📋 Resumo Final

| Propriedade                     | Estimativa                              |
|--------------------------------|------------------------------------------|
| Período Orbital                | 2,627 dias                               |
| Raio do Planeta                | 1,74 R<sub>Júpiter</sub>                |
| Distância à Estrela (a)        | 0,0385 UA                                |
| Velocidade Orbital             | ~159 km/s                                |
| Temperatura de Equilíbrio      | ~1910 K                                  |
| Densidade                      | ~1,33 g/cm³                              |
| Duração do Trânsito            | ~4,1 horas                               |
| Tipo do Planeta                | Hot Jupiter                              |
| Número de Trânsitos Observados | 30                                       |


