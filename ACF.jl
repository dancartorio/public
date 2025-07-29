module MissingPatterns

export plotmissing

"""
    plotmissing(df; orientation=:vertical, missing_char='█', present_char='░', 
                max_width=80, max_height=30, show_legend=true, show_column_names=true)

Plota um padrão de valores ausentes usando caracteres ASCII no terminal.

# Argumentos
- `df`: O DataFrame de entrada.
- `orientation`: Orientação do plot (`:vertical` ou `:horizontal`).
- `missing_char`: Caractere para representar valores ausentes (padrão: '█').
- `present_char`: Caractere para representar valores presentes (padrão: '░').
- `max_width`: Largura máxima do plot em caracteres (padrão: 80).
- `max_height`: Altura máxima do plot em caracteres (padrão: 30).
- `show_legend`: Se deve mostrar a legenda (padrão: true).
- `show_column_names`: Se deve mostrar os nomes das colunas (padrão: true).

# Retorna
- Imprime o plot no terminal e retorna nothing.
"""
function plotmissing(df; 
                    orientation::Symbol=:vertical, 
                    missing_char::Char='█', 
                    present_char::Char='░',
                    max_width::Int=80, 
                    max_height::Int=30,
                    show_legend::Bool=true,
                    show_column_names::Bool=true)
    
    # Converte DataFrame para matriz booleana de missing values
    missing_matrix = Matrix{Bool}(ismissing.(df))
    nrows, ncols = size(missing_matrix)
    col_names = names(df)
    
    if orientation == :horizontal
        missing_matrix = permutedims(missing_matrix)
        nrows, ncols = ncols, nrows
        col_names = string.(1:ncols)  # Para orientação horizontal, usa números
    end
    
    # Calcula fatores de redimensionamento se necessário
    row_step = max(1, ceil(Int, nrows / max_height))
    col_step = max(1, ceil(Int, ncols / max_width))
    
    # Redimensiona a matriz se necessário (sampling)
    display_rows = 1:row_step:nrows
    display_cols = 1:col_step:ncols
    
    display_matrix = missing_matrix[display_rows, display_cols]
    display_col_names = col_names[display_cols]
    
    # Cabeçalho estilo BenchmarkTools
    total_cells = nrows * ncols
    missing_count = sum(missing_matrix)
    missing_percentage = round(missing_count / total_cells * 100, digits=1)
    present_count = total_cells - missing_count
    present_percentage = round(present_count / total_cells * 100, digits=1)
    
    println()
    println("MissingPatterns.Analysis: $(nrows) rows × $(ncols) columns with $(missing_count) missing values")
    print("  Missing data: $(missing_count)/$(total_cells) ($(missing_percentage)%)")
    print("  Present data: $(present_count)/$(total_cells) ($(present_percentage)%)")
    
    if row_step > 1 || col_step > 1
        print("  Display: $(size(display_matrix, 1))×$(size(display_matrix, 2)) sample")
    end
    println("\n")
    
    # Cabeçalho com nomes das colunas (se solicitado e orientação vertical)
    if show_column_names && orientation == :vertical
        print("    ")  # Espaço para numeração das linhas
        for (i, name) in enumerate(display_col_names)
            # Trunca nomes muito longos se necessário
            short_name = length(name) > 1 ? string(name[1]) : name
            print(short_name)
        end
        println()
    end
    
    # Plot principal
    display_nrows, display_ncols = size(display_matrix)
    
    for i in 1:display_nrows
        # Numeração das linhas
        if orientation == :vertical
            row_num = display_rows[i]
            print(lpad(string(row_num), 3) * " ")
        else
            col_name = length(display_col_names[i]) > 8 ? 
                      display_col_names[i][1:5] * "..." : 
                      display_col_names[i]
            print(rpad(col_name, 8))
        end
        
        # Linha do padrão
        for j in 1:display_ncols
            char = display_matrix[i, j] ? missing_char : present_char
            print(char)
        end
        
        # Estatísticas da linha (para orientação horizontal)
        if orientation == :horizontal
            missing_in_row = sum(missing_matrix[i, :])
            percentage = round(missing_in_row / ncols * 100, digits=1)
            print("  ($(missing_in_row)/$(ncols) - $(percentage)%)")
        end
        
        println()
    end
    
    # Tabela de estatísticas por coluna
    println("  Column statistics:")
    
    # Calcula largura máxima do nome das colunas para alinhamento
    max_name_length = maximum(length.(col_names))
    name_width = max(6, min(max_name_length, 20))  # Entre 6 e 20 caracteres
    
    for (i, col_name) in enumerate(col_names)
        if orientation == :vertical
            col_idx = i
        else
            col_idx = i
        end
        
        missing_count_col = sum(missing_matrix[:, col_idx] if orientation == :vertical else missing_matrix[col_idx, :])
        total_count = orientation == :vertical ? nrows : ncols
        present_count_col = total_count - missing_count_col
        percentage = round(missing_count_col / total_count * 100, digits=1)
        
        # Trunca nome se muito longo
        display_name = length(col_name) > name_width ? col_name[1:name_width-3] * "..." : col_name
        
        println("    $(rpad(display_name, name_width)): $(lpad(missing_count_col, 3))/$(lpad(total_count, 3)) missing ($(lpad(percentage, 5))%)")
    end
    
    # Legenda minimalista
    if show_legend
        println("  $(missing_char) = missing    $(present_char) = present")
    end
    
    println()
    
    return nothing
end

"""
    summary_missing(df)

Exibe um resumo estatístico dos valores ausentes por coluna no estilo BenchmarkTools.
"""
function summary_missing(df)
    nrows = nrow(df)
    col_names = names(df)
    total_cells = nrows * length(col_names)
    total_missing = sum(sum(ismissing.(df[!, col])) for col in col_names)
    overall_percentage = round(total_missing / total_cells * 100, digits=1)
    
    println()
    println("MissingPatterns.Summary: $(nrows) rows × $(length(col_names)) columns with $(total_missing) missing values")
    println("  Overall missing rate: $(total_missing)/$(total_cells) ($(overall_percentage)%)")
    println()
    
    # Calcula largura máxima do nome das colunas
    max_name_length = maximum(length.(col_names))
    name_width = max(6, min(max_name_length, 20))
    
    println("  Column breakdown:")
    for col in col_names
        missing_count = sum(ismissing.(df[!, col]))
        percentage = round(missing_count / nrows * 100, digits=1)
        
        # Trunca nome se muito longo
        display_name = length(col) > name_width ? col[1:name_width-3] * "..." : col
        
        println("    $(rpad(display_name, name_width)): $(lpad(missing_count, 3))/$(lpad(nrows, 3)) missing ($(lpad(percentage, 5))%)")
    end
    
    println()
end

end # module
