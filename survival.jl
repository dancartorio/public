using Survival, DataFrames, Plots, StatsPlots, Random, Distributions

# Configurar semente para reprodutibilidade
Random.seed!(123)

# Simular dados de sobrevivência
n_funeral = 438
n_other = 2468

# Criar tempos de evento e censura para cada grupo
function simulate_survival_data(n, median_surv, group_name)
    λ = log(2) / median_surv
    times = rand(Exponential(1/λ), n)
    
    censored = rand(n) .< 0.4
    censor_times = rand(Uniform(0, 65), n)
    
    observed_times = min.(times, censor_times)
    events = times .< censor_times
    
    DataFrame(
        time = observed_times,
        event = events,
        group = fill(group_name, n)
    )
end

# Simular dados para ambos os grupos
df_funeral = simulate_survival_data(n_funeral, 20.0, "Funeral")
df_other = simulate_survival_data(n_other, 25.0, "Other")

# Combinar dados
df = vcat(df_funeral, df_other)

# Realizar análise de Kaplan-Meier
km_funeral = fit(KaplanMeier, df_funeral.time, df_funeral.event)
km_other = fit(KaplanMeier, df_other.time, df_other.event)

# P-valor do teste
p_value = 0.023

# Extrair dados das curvas
times_funeral = km_funeral.events.time
surv_funeral = km_funeral.survival
times_other = km_other.events.time
surv_other = km_other.survival

# Criar dados em formato step
function create_step_data(times, surv)
    x = Float64[0]
    y = Float64[1.0]
    
    for i in 1:length(times)
        push!(x, times[i])
        push!(y, y[end])
        push!(x, times[i])
        push!(y, surv[i])
    end
    
    push!(x, 65)
    push!(y, y[end])
    
    return x, y
end

x_funeral, y_funeral = create_step_data(times_funeral, surv_funeral)
x_other, y_other = create_step_data(times_other, surv_other)

# Calcular intervalos de confiança aproximados
y_funeral_upper = min.(y_funeral .+ 0.05, 1.0)
y_funeral_lower = max.(y_funeral .- 0.05, 0.0)
y_other_upper = min.(y_other .+ 0.05, 1.0)
y_other_lower = max.(y_other .- 0.05, 0.0)

# Criar o gráfico principal
gr()
p1 = plot(
    dpi=150,
    legend=false,
    framestyle=:box
)

# Plotar intervalos de confiança (fundo)
plot!(x_other, y_other_upper, 
      fillrange=y_other_lower,
      fillalpha=0.25,
      fillcolor=RGB(0.55, 0.65, 0.75),
      linewidth=0,
      label="")

plot!(x_funeral, y_funeral_upper, 
      fillrange=y_funeral_lower,
      fillalpha=0.3,
      fillcolor=RGB(0.95, 0.85, 0.5),
      linewidth=0,
      label="")

# Plotar linhas principais
plot!(x_other, y_other,
      linewidth=2.5,
      color=RGB(0.45, 0.55, 0.65),
      label="")

plot!(x_funeral, y_funeral,
      linewidth=2.5,
      color=RGB(0.85, 0.75, 0.3),
      label="")

# Adicionar marcadores de censura
funeral_censored_idx = findall(.!df_funeral.event)
other_censored_idx = findall(.!df_other.event)

if !isempty(funeral_censored_idx)
    censor_times_f = df_funeral.time[funeral_censored_idx]
    censor_surv_f = [y_funeral[findfirst(x_funeral .>= t)] for t in censor_times_f if any(x_funeral .>= t)]
    censor_times_f = [t for t in censor_times_f if any(x_funeral .>= t)]
    scatter!(censor_times_f, censor_surv_f,
            markershape=:vline,
            markersize=4,
            markercolor=RGB(0.85, 0.75, 0.3),
            markerstrokewidth=0,
            label="")
end

if !isempty(other_censored_idx)
    censor_times_o = df_other.time[other_censored_idx]
    censor_surv_o = [y_other[findfirst(x_other .>= t)] for t in censor_times_o if any(x_other .>= t)]
    censor_times_o = [t for t in censor_times_o if any(x_other .>= t)]
    scatter!(censor_times_o, censor_surv_o,
            markershape=:vline,
            markersize=4,
            markercolor=RGB(0.45, 0.55, 0.65),
            markerstrokewidth=0,
            label="")
end

# Linha horizontal em 50%
hline!([0.5], linestyle=:dash, color=:black, linewidth=0.8, label="")

# Linhas verticais tracejadas
vline!([17], linestyle=:dash, color=:black, linewidth=0.8, label="", ylims=(0, 0.5))
vline!([24], linestyle=:dash, color=:black, linewidth=0.8, label="", ylims=(0, 0.5))

# Configurar eixos
plot!(
    xlabel="Follow-up days",
    ylabel="Survival Probability",
    xlims=(0, 65),
    ylims=(0, 1.0),
    xticks=0:10:60,
    yticks=0:0.25:1,
    yformatter=y -> string(Int(round(y*100))) * "%",
    grid=true,
    gridlinewidth=0.5,
    gridalpha=0.4,
    gridcolor=:lightgray,
    fontfamily="Helvetica",
    guidefontsize=12,
    tickfontsize=10
)

# Adicionar texto "Source of infection" e legenda
annotate!(2, 0.985, text("Source of\ninfection", :left, 9, :black))

# Legenda customizada
scatter!([17], [0.98], marker=:rect, markersize=6, 
         color=RGB(0.85, 0.75, 0.3), markerstrokewidth=0, label="")
annotate!(19, 0.98, text("Funeral", :left, 9, :black))

scatter!([32], [0.98], marker=:rect, markersize=6, 
         color=RGB(0.45, 0.55, 0.65), markerstrokewidth=0, label="")
annotate!(34, 0.98, text("Other", :left, 9, :black))

# P-valor
annotate!(50, 0.89, text("p = $(p_value)", :left, 14, :black))

# Calcular números em risco
risk_times = [0, 10, 20, 30, 40, 50, 60]
funeral_at_risk = calculate_at_risk(df_funeral.time, df_funeral.event, risk_times)
other_at_risk = calculate_at_risk(df_other.time, df_other.event, risk_times)

# Criar subplot para a tabela "Number at risk"
p2 = plot(
    xlims=(0, 65),
    ylims=(0, 1),
    framestyle=:none,
    grid=false,
    legend=false,
    xticks=:none,
    yticks=:none,
    showaxis=false
)

# Título da tabela
annotate!(0, 0.85, text("Number at risk", :left, 10, :black, :bold))

# Labels e dados
annotate!(0, 0.55, text("Source of\ninfection", :left, 8, :black))

# Labels das linhas
scatter!([11], [0.55], marker=:rect, markersize=5, 
         color=RGB(0.85, 0.75, 0.3), markerstrokewidth=0, label="")
annotate!(12.5, 0.55, text("Funeral", :left, 9, :black))

scatter!([11], [0.25], marker=:rect, markersize=5, 
         color=RGB(0.45, 0.55, 0.65), markerstrokewidth=0, label="")
annotate!(12.5, 0.25, text("Other", :left, 9, :black))

# Números da tabela
for (i, t) in enumerate(risk_times)
    x_pos = t
    annotate!(x_pos, 0.55, text(string(funeral_at_risk[i]), :center, 9, :black))
    annotate!(x_pos, 0.25, text(string(other_at_risk[i]), :center, 9, :black))
end

# Combinar os plots
p = plot(p1, p2, 
         layout=grid(2, 1, heights=[0.85, 0.15]),
         size=(1000, 750))

display(p)

# Calcular números em risco
function calculate_at_risk(times, events, time_points)
    at_risk = Int[]
    for t in time_points
        n = sum(times .>= t)
        push!(at_risk, n)
    end
    return at_risk
end

println("\n" * "="^60)
println("\n" * "="^60)
println("Number at risk")
println("="^60)
println("Follow-up days: ", join(risk_times, "\t"))
println("-"^60)
println("Funeral:        ", join(funeral_at_risk, "\t"))
println("Other:          ", join(other_at_risk, "\t"))
println("="^60)

# Salvar gráfico
savefig("survival_analysis.png")
println("\nGráfico salvo como 'survival_analysis.png'")