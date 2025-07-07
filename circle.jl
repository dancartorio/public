# ... (tudo igual até a seção 5: configuração do mapa)

# 6. Plotagem dos estados (sem coloração por PIB)
for (i, geom) in enumerate(geoms)
    coords = GeoInterface.coordinates(geom)
    for poly in coords
        exterior = poly[1]
        pontos = Point2f.(first.(exterior), last.(exterior))
        poly!(ax, pontos, color = RGBA(0.2, 0.2, 0.2, 1.0), strokecolor = (:gray, 0.4), strokewidth = 0.5)
    end
end

# 7. Plotar círculos proporcionais ao log10(PIB)
# Raio dos círculos proporcional: normalizando log_pib_values
log_pib_values = log10.(pib_values)
log_min, log_max = extrema(log_pib_values)

# Normalizar e aplicar fator de escala
circle_sizes = [(v - log_min) / (log_max - log_min) * 60 + 10 for v in log_pib_values]  # valores entre 10 e 70

# Calcular os centros
centros = [approximate_center(g) for g in geoms]

# Plotar círculos
for (i, centro) in enumerate(centros)
    scatter!(ax, [centro[1]], [centro[2]],
        color = RGBA(0.2, 0.7, 0.9, 0.6),
        strokecolor = :white,
        strokewidth = 1.5,
        markersize = circle_sizes[i])
    
    # Adicionar texto da sigla
    text!(ax, siglas_uf[i], 
        position = centro,
        color = :white,
        align = (:center, :center),
        fontsize = 10,
        font = "Arial Bold")
end

# 8. Legenda manual de tamanhos
tamanhos_legenda = [10, 100, 500, 1000]  # bilhões de R$
leg_fig = fig[1, 2] = Axis(fig, title = "PIB (R$ bi)", xticks = [], yticks = [], xvisible = false, yvisible = false)

for (i, val) in enumerate(tamanhos_legenda)
    radius = ((log10(val * 1e9) - log_min) / (log_max - log_min)) * 60 + 10
    scatter!(leg_fig, [0], [-i * 1.5], color = RGBA(0.2, 0.7, 0.9, 0.6), markersize = radius)
    text!(leg_fig, "$(val)", position = (0.8, -i * 1.5), color = :white, fontsize = 10)
end

# 9. Exibição dos top estados (mantém)
df_top = sort(df_2020, :valor, rev=true)
println("\nTop 10 maiores PIBs estaduais em 2020:")
for (i, row) in enumerate(eachrow(df_top[1:10, :]))
    println("$i. $(row.uf): R\$ $(round(row.valor / 1e9, digits=2)) bilhões")
end

fig
