using DataFrames, Plots, Statistics

# Dados de exemplo
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

# Calcular e inverter a matriz de correlação
cor_matrix = cor(Matrix(data))
cor_matrix = reverse(cor_matrix, dims=1)  # Inverte as linhas da matriz

# Nomes das variáveis invertidas no eixo Y
vars = names(data)
n = length(vars)

# Criar heatmap
heatmap(cor_matrix,
    color = :coolwarm,
    clim = (-1, 1),
    xticks = (1:n, vars),          # Eixo X original
    yticks = (1:n, reverse(vars)), # Eixo Y invertido
    xlabel = "Variáveis",
    ylabel = "Variáveis",
    title = "Correlação de Pearson",
    size = (600, 500),
    xrotation = 45,
    yflip = false
)

# Adicionar valores com contraste dinâmico
annotations = vec([(j, i, text("$(round(cor_matrix[i,j], digits=2))", 8, 
    (abs(cor_matrix[i,j]) > 0.5 ? :white : :black), :center)) 
    for i in 1:n, j in 1:n])

annotate!(annotations)

current()