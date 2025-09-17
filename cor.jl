using Plots, Random, Statistics

# Configurar o plot
gr()
Random.seed!(42)

# Função para gerar dados com correlação específica
function generate_correlated_data(n, r)
    # Gerar dados aleatórios independentes
    x = randn(n)
    z = randn(n)
    
    # Criar y com correlação r com x
    y = r * x + sqrt(1 - r^2) * z
    
    return x, y
end

# Função para gerar dados com padrões especiais
function generate_special_data(pattern, n=100)
    if pattern == "no_correlation"
        x = randn(n)
        y = randn(n)
        return x, y, 0.0
    elseif pattern == "weak_positive"
        x, y = generate_correlated_data(n, 0.3)
        return x, y, 0.3
    elseif pattern == "moderate_positive"
        x, y = generate_correlated_data(n, 0.6)
        return x, y, 0.6
    elseif pattern == "strong_positive"
        x, y = generate_correlated_data(n, 0.9)
        return x, y, 0.9
    elseif pattern == "perfect_positive"
        x = randn(n)
        y = x + 0.1*randn(n)  # quase perfeita
        return x, y, 1.0
    elseif pattern == "perfect_negative"
        x = randn(n)
        y = -x + 0.1*randn(n)  # quase perfeita negativa
        return x, y, -1.0
    end
end

# Gerar os dados para diferentes correlações
correlations = [0.0, 0.3, 0.6, 0.9, 1.0, -1.0]
patterns = ["no_correlation", "weak_positive", "moderate_positive", 
           "strong_positive", "perfect_positive", "perfect_negative"]

# Criar subplots
plots_array = []

for (i, (pattern, r_target)) in enumerate(zip(patterns, correlations))
    x, y, _ = generate_special_data(pattern, 100)
    
    # Calcular correlação real
    r_actual = cor(x, y)
    
    # Criar scatter plot
    p = scatter(x, y, 
               alpha=0.6, 
               color=:black,
               markersize=3,
               title="r = $(round(r_actual, digits=2))",
               titlefontsize=12,
               xlabel="X",
               ylabel="Y",
               xlims=(-3, 3),
               ylims=(-3, 3),
               grid=true,
               gridwidth=1,
               gridcolor=:lightgray,
               background_color=:white,
               legend=false)
    
    push!(plots_array, p)
end

# Combinar todos os plots
final_plot = plot(plots_array..., 
                 layout=(2, 3), 
                 size=(900, 600),
                 plot_title="Demonstração do Coeficiente de Correlação de Pearson",
                 plot_titlefontsize=16)

# Mostrar o plot
display(final_plot)

# Demonstração adicional: calculando correlação manualmente
println("\n" * "="^60)
println("DEMONSTRAÇÃO DO CÁLCULO DO COEFICIENTE DE CORRELAÇÃO")
println("="^60)

# Exemplo com dados simples
x_exemplo = [1, 2, 3, 4, 5]
y_exemplo = [2, 4, 6, 8, 10]

println("Dados de exemplo:")
println("X: ", x_exemplo)
println("Y: ", y_exemplo)
println()

# Cálculo manual
n = length(x_exemplo)
mean_x = mean(x_exemplo)
mean_y = mean(y_exemplo)

println("Médias:")
println("X̄ = ", round(mean_x, digits=2))
println("Ȳ = ", round(mean_y, digits=2))
println()

# Desvios
dev_x = x_exemplo .- mean_x
dev_y = y_exemplo .- mean_y

println("Desvios da média:")
println("(x - x̄): ", round.(dev_x, digits=2))
println("(y - ȳ): ", round.(dev_y, digits=2))
println()

# Produtos e somas
prod_dev = dev_x .* dev_y
sum_prod_dev = sum(prod_dev)
sum_sq_dev_x = sum(dev_x.^2)
sum_sq_dev_y = sum(dev_y.^2)

println("Produtos dos desvios:")
println("(x - x̄)(y - ȳ): ", round.(prod_dev, digits=2))
println("Σ(x - x̄)(y - ȳ) = ", round(sum_prod_dev, digits=2))
println()

println("Somas dos quadrados:")
println("Σ(x - x̄)² = ", round(sum_sq_dev_x, digits=2))
println("Σ(y - ȳ)² = ", round(sum_sq_dev_y, digits=2))
println()

# Coeficiente de correlação
r_manual = sum_prod_dev / sqrt(sum_sq_dev_x * sum_sq_dev_y)
r_julia = cor(x_exemplo, y_exemplo)

println("Coeficiente de Correlação:")
println("r = Σ(x - x̄)(y - ȳ) / √[Σ(x - x̄)² × Σ(y - ȳ)²]")
println("r = ", round(sum_prod_dev, digits=2), " / √[", round(sum_sq_dev_x, digits=2), " × ", round(sum_sq_dev_y, digits=2), "]")
println("r = ", round(sum_prod_dev, digits=2), " / ", round(sqrt(sum_sq_dev_x * sum_sq_dev_y), digits=2))
println("r = ", round(r_manual, digits=4))
println()
println("Verificação com cor() do Julia: ", round(r_julia, digits=4))
println()

# Interpretação
println("INTERPRETAÇÃO DO COEFICIENTE DE CORRELAÇÃO:")
println("-1.0 ≤ r ≤ +1.0")
println()
println("r = +1.0: Correlação linear positiva perfeita")
println("r = +0.9: Correlação linear positiva muito forte") 
println("r = +0.7: Correlação linear positiva forte")
println("r = +0.5: Correlação linear positiva moderada")
println("r = +0.3: Correlação linear positiva fraca")
println("r = 0.0:  Não há correlação linear")
println("r = -0.3: Correlação linear negativa fraca")
println("r = -0.5: Correlação linear negativa moderada")
println("r = -0.7: Correlação linear negativa forte")
println("r = -0.9: Correlação linear negativa muito forte")
println("r = -1.0: Correlação linear negativa perfeita")

# Criar um segundo gráfico mostrando diferentes forças de correlação
println("\nGerando gráfico adicional com diferentes forças de correlação...")

correlations_detailed = [-0.9, -0.5, 0.0, 0.5, 0.7, 0.9]
plots_detailed = []

for r in correlations_detailed
    x, y = generate_correlated_data(100, r)
    r_actual = cor(x, y)
    
    p = scatter(x, y,
               alpha=0.6,
               color=:black,
               markersize=2,
               title="r = $(round(r_actual, digits=2))",
               titlefontsize=10,
               xlabel="X",
               ylabel="Y",
               xlims=(-3, 3),
               ylims=(-3, 3),
               legend=false)
    
    # Adicionar linha de tendência se houver correlação
    if abs(r_actual) > 0.1
        # Regressão linear simples
        β1 = sum((x .- mean(x)) .* (y .- mean(y))) / sum((x .- mean(x)).^2)
        β0 = mean(y) - β1 * mean(x)
        
        x_line = range(-3, 3, length=50)
        y_line = β0 .+ β1 .* x_line
        
        plot!(p, x_line, y_line, color=:red, linewidth=2, alpha=0.7)
    end
    
    push!(plots_detailed, p)
end

final_plot_detailed = plot(plots_detailed...,
                          layout=(2, 3),
                          size=(900, 600),
                          plot_title="Diferentes Forças de Correlação com Linhas de Tendência",
                          plot_titlefontsize=14)

display(final_plot_detailed)