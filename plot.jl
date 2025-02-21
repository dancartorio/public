using Dates
using TimeSeries
using Statistics
using Plots
theme(:bright)

# Função para gerar dados de exemplo
function generate_sample_timeseries(start_date, periods)
    dates = collect(start_date:Dates.Day(1):start_date + Dates.Day(periods-1))
    
    # Componentes
    trend = 0.1 .* (1:periods)  # Tendência linear
    seasonal = 3 .* sin.(2π/30 .* (1:periods))  # Sazonalidade mensal (período de 30 dias)
    noise = randn(periods) * 0.5  # Ruído
    
    # Série temporal combinada (modelo aditivo)
    data = trend + seasonal + noise
    
    return TimeArray(dates, data)
end

# Função de média móvel para estimativa de tendência
function estimate_trend(data::Vector{T}, window_size::Int) where T
    n = length(data)
    trend = similar(data)
    half_window = window_size ÷ 2
    
    for i in 1:n
        start_idx = max(1, i - half_window)
        end_idx = min(n, i + half_window)
        trend[i] = mean(data[start_idx:end_idx])
    end
    return trend
end

# Função para estimar sazonalidade
function estimate_seasonality(detrended::Vector{T}, season_length::Int) where T
    n = length(detrended)
    seasons = zeros(T, season_length)
    counts = zeros(Int, season_length)
    
    for i in 1:n
        idx = mod1(i, season_length)
        seasons[idx] += detrended[i]
        counts[idx] += 1
    end
    
    seasonal_component = seasons ./ counts
    repeat(seasonal_component, outer=ceil(Int, n/season_length))[1:n]
end

# Função principal de decomposição
function decompose_timeseries(ts::TimeArray; window_size=7, season_length=30)
    data = values(ts)
    dates = timestamp(ts)
    
    # 1. Estimativa de Tendência
    trend = estimate_trend(data, window_size)
    
    # 2. Remover tendência
    detrended = data .- trend
    
    # 3. Estimativa de Sazonalidade
    seasonal = estimate_seasonality(detrended, season_length)
    
    # 4. Calcular resíduos
    residual = detrended .- seasonal
    
    # Criar TimeArrays para cada componente
    trend_ta = TimeArray(dates, trend)
    seasonal_ta = TimeArray(dates, seasonal)
    residual_ta = TimeArray(dates, residual)
    
    return trend_ta, seasonal_ta, residual_ta
end

# Gerar dados de exemplo
start_date = Date(2023, 1, 1)
ts = generate_sample_timeseries(start_date, 90)

# Realizar decomposição
trend, seasonal, residual = decompose_timeseries(ts, window_size=7, season_length=30)

# Plotar resultados com estilo modificado para resíduos
p1 = plot(ts, title="Série Original", legend=false, color=:navy)
p2 = plot(trend, title="Tendência", legend=false, color=:darkgreen)
p3 = plot(seasonal, title="Sazonalidade", legend=false, color=:purple)

# Novo plot para resíduos com estilo apropriado
p4 = plot(
    timestamp(residual), 
    values(residual), 
    title="Resíduos",
    seriestype=:scatter,
    legend=false,
    color=:red,
    markershape=:circle,
    markersize=3,
    markerstrokewidth=0
)
hline!([0], color=:black, linestyle=:dash, linewidth=1, label="")  # Linha de referência zero

plot(p1, p2, p3, p4, layout=(4,1), size=(800, 800), plot_title="Decomposição de Séries Temporais")