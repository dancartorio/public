using CSV, DataFrames, ShiftedArrays, GLM
using StatsBase
using Plots

# Carregar o arquivo
df = CSV.read("dados_mortalidade_clima_exemplo.csv", DataFrame)

# Criar defasagens (lag de 1 mês)
df.temp_lag1 = lag(df.temperatura, 1)
df.chuva_lag1 = lag(df.chuvas, 1)
df.umid_lag1 = lag(df.umidade, 1)

# Remover linhas com missing após os lags
df = dropmissing(df)

# Ajustar modelo de regressão linear
modelo = lm(@formula(mortes ~ temp_lag1 + chuva_lag1 + umid_lag1), df)

# Ver resultados
println(coeftable(modelo))

# ------------------------------
# Gerar gráfico de autocorrelação (ACF)
# ------------------------------

# Função para calcular autocorrelações para vários lags
function autocor_vec(x::Vector{<:Real}, maxlag::Int)
    μ = mean(x)
    σ² = var(x)
    n = length(x)
    acf = Float64[]
    for lag in 0:maxlag
        numerador = sum((x[1:n-lag] .- μ) .* (x[1+lag:n] .- μ))
        push!(acf, numerador / ((n - lag) * σ²))
    end
    return acf
end

# Calcular e plotar ACF
max_lag = 20
acf_vals = autocor_vec(df.mortes, max_lag)

bar(0:max_lag, acf_vals,
    title="Autocorrelação da série de mortes",
    xlabel="Defasagem (Lag)",
    ylabel="ACF",
    legend=false)


    https://chatgpt.com/share/6892652c-7368-8001-a720-419ac0378087