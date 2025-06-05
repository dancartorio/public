### Pacotes
using Distributions
using Plots
using HypothesisTests
using Optim

theme(:dracula)

### Dados
data = [45.0, 55.0, 50.5, 62.0, 70.0, 40.0, 60.0, 75.0, 58.0, 65.0, 55.0, 48.0]

### Estimativa dos Parâmetros

# Weibull
fit_weibull = fit(Weibull, data)

# Gamma
fit_gamma = fit(Gamma, data)

# LogNormal
fit_lognormal = fit(LogNormal, data)

# Rayleigh
fit_rayleigh = fit(Rayleigh, data)

# Burr - já implementado
function log_likelihood_burr(params, data)
    α, k, c = params
    if α <= 0 || k <= 0 || c <= 0
        return Inf
    end
    sum(logpdf_burr.(data, α, k, c)) * -1
end

function pdf_burr(x, α, k, c)
    num = α * k * (x / c)^(k - 1)
    den = c * (1 + (x / c)^k)^(α + 1)
    return num / den
end

function logpdf_burr(x, α, k, c)
    log(α) + log(k) + (k - 1) * log(x / c) - log(c) - (α + 1) * log(1 + (x / c)^k)
end

initial_params = [1.0, 1.0, mean(data)]
result = optimize(p -> log_likelihood_burr(p, data), initial_params, BFGS())
params_burr = Optim.minimizer(result)

pdf_burr_adj(x) = pdf_burr(x, params_burr...)

### Frechet (implementação via Distributions.jl)

module MyFrechet

using Distributions: ContinuousUnivariateDistribution

export Frechet, pdf, cdf

struct Frechet <: ContinuousUnivariateDistribution
    α::Float64
    β::Float64
    γ::Float64
end

function pdf(d::Frechet, x)
    α, β, γ = d.α, d.β, d.γ
    z = (x - γ) / β
    return z <= 0 ? 0.0 : (α / β) * z^(-1 - α) * exp(-z^(-α))
end

function cdf(d::Frechet, x)
    α, β, γ = d.α, d.β, d.γ
    z = (x - γ) / β
    return z <= 0 ? 0.0 : exp(-z^(-α))
end

end # module

# Estimativa Frechet simplificada (não via ML):
α_frechet, β_frechet, γ_frechet = 1.5, std(data), minimum(data) - 1.0
fit_frechet = MyFrechet.Frechet(α_frechet, β_frechet, γ_frechet)

### Comparação gráfica: PDF

x = minimum(data):0.1:maximum(data)

plot(x, [pdf(fit_weibull, xi) for xi in x], label="Weibull", lw=2)
plot!(x, pdf.(fit_gamma, x), label="Gamma", lw=2)
plot!(x, pdf.(fit_lognormal, x), label="LogNormal", lw=2)
plot!(x, pdf.(fit_rayleigh, x), label="Rayleigh", lw=2)
plot!(x, pdf_burr_adj.(x), label="Burr", lw=2)
plot!(x, [MyFrechet.pdf(fit_frechet, xi) for xi in x], label="Frechet", lw=2)
histogram!(data, normalize=true, alpha=0.3, label="Dados")

### GOF: Kolmogorov-Smirnov

ks_weibull = ExactOneSampleKSTest(data, fit_weibull)
ks_gamma = ExactOneSampleKSTest(data, fit_gamma)
ks_lognormal = ExactOneSampleKSTest(data, fit_lognormal)
ks_rayleigh = ExactOneSampleKSTest(data, fit_rayleigh)

# Burr e Frechet não suportados diretamente, usar PP plot.

### Anderson-Darling

ad_weibull = OneSampleADTest(data, fit_weibull)
ad_gamma = OneSampleADTest(data, fit_gamma)
ad_lognormal = OneSampleADTest(data, fit_lognormal)
ad_rayleigh = OneSampleADTest(data, fit_rayleigh)

### Resultados

println("GOF Kolmogorov-Smirnov:")
println("Weibull: ", ks_weibull)
println("Gamma: ", ks_gamma)
println("LogNormal: ", ks_lognormal)
println("Rayleigh: ", ks_rayleigh)

println("\nGOF Anderson-Darling:")
println("Weibull: ", ad_weibull)
println("Gamma: ", ad_gamma)
println("LogNormal: ", ad_lognormal)
println("Rayleigh: ", ad_rayleigh)

### PP-Plots

function pp_plot(data, dist, title_str)
    n = length(data)
    data_sorted = sort(data)
    prob_emp = (1:n) ./ n
    prob_theor = cdf.(dist, data_sorted)
    p = plot(prob_theor, prob_emp, seriestype = :scatter, label = "PP", title = title_str,
         xlabel="Teórica", ylabel="Empírica")
    plot!(p, [0,1], [0,1], linestyle = :dash, label="45°")
    return p
end

display(pp_plot(data, fit_weibull, "PP Weibull"))
display(pp_plot(data, fit_gamma, "PP Gamma"))
display(pp_plot(data, fit_lognormal, "PP LogNormal"))
display(pp_plot(data, fit_rayleigh, "PP Rayleigh"))

# Burr
p_burr = plot(prob_burr, prob_emp, seriestype=:scatter, title="PP Burr", xlabel="Teórica", ylabel="Empírica")
plot!(p_burr, [0,1], [0,1], linestyle=:dash, label="45°")
display(p_burr)

# Frechet
p_frechet = plot(prob_frechet, prob_emp, seriestype=:scatter, title="PP Frechet", xlabel="Teórica", ylabel="Empírica")
plot!(p_frechet, [0,1], [0,1], linestyle=:dash, label="45°")
display(p_frechet)
