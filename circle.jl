# Dicionário PIB por estado (corrigido para reais)
pib_dict = Dict{String, Float64}()
for row in eachrow(df_2020)
    pib_dict[row.uf] = row.valor * 1_000  # Convertendo de mil R$ para R$
end

println("\nTop 10 maiores PIBs estaduais em 2020:")

for (i, row) in enumerate(eachrow(df_top[1:10, :]))
    valor_real = row.valor * 1_000  # Convertendo de mil R$ para R$
    if valor_real >= 1e12
        println("$i. $(row.uf): R\$ $(round(valor_real / 1e12, digits=2)) trilhões")
    else
        println("$i. $(row.uf): R\$ $(round(valor_real / 1e9, digits=2)) bilhões")
    end
end
