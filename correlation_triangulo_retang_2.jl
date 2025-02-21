using DataFrames, Statistics, Plots
theme(:dracula)

# Gerar dados de exemplo
data = DataFrame(
    Var1 = randn(100),
    Var2 = randn(100) .+ 0.5,
    Var3 = randn(100) .* 0.3,
    Var4 = randn(100) .- 0.2,
    Var5 = randn(100) .* 1.2,
    Var6 = randn(100) .+ 1.0,
    Var7 = randn(100) .* 0.7,
    Var8 = randn(100) .- 0.5,
    Var9 = randn(100) .* 1.5,
    Var10 = randn(100) .+ 2.0
)

# Calcular matriz de correlação
cor_matrix = cor(Matrix(data))
n_vars = size(cor_matrix, 1)
var_names = names(data)

# Criar máscara triangular inferior
mask = [i >= j for i in 1:n_vars, j in 1:n_vars]

# Aplicar máscara: valores fora do triângulo ficam como NaN
masked_cor = cor_matrix .* mask
masked_cor[.!mask] .= NaN

# Inverter as linhas da matriz para alinhar com os nomes invertidos no eixo Y
reversed_masked_cor = reverse(masked_cor, dims=1)
reversed_names = reverse(var_names)

# Criar heatmap
plt = heatmap(
    var_names, reversed_names,  # Eixos com nomes originais e invertidos
    reversed_masked_cor,        # Matriz invertida verticalmente
    color = :RdBu, clims = (-1, 1),
    xrot = 45, size = (600, 500),
    colorbar_title = "Correlação de Pearson",
    title = "Matriz de Correlação (Triangular Inferior)"
)

# Adicionar anotações nas posições corretas (considerando a inversão vertical)
for i in 1:n_vars
    for j in 1:i  # Apenas triângulo inferior
        value = round(cor_matrix[i, j], digits=2)
        text_color = abs(value) > 0.5 ? :white : :black
        # Posição X: coluna j, Posição Y: linha ajustada pela inversão
        annotate!(plt, j - 0.5, n_vars - i + 0.5, text("$value", 8, text_color, :center))
    end
end

display(plt)