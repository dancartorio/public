using Printf, Plots, LinearAlgebra
theme(:dracula)

function calcular_sac(valor_financiado, n_meses, taxa_mensal)
    parcelas = Float64[]
    amortizacao = valor_financiado / n_meses
    saldo = valor_financiado
    
    for _ in 1:n_meses
        juros = saldo * taxa_mensal
        parcela = amortizacao + juros
        push!(parcelas, parcela)
        saldo -= amortizacao
    end
    
    return parcelas
end

function calcular_price(valor_financiado, n_meses, taxa_mensal)
    pmt = (valor_financiado * taxa_mensal) / (1 - (1 + taxa_mensal)^-n_meses)
    return fill(pmt, n_meses)
end

function main()
    println("Digite a quantidade de meses:")
    n = parse(Int, readline())
    
    println("Digite a taxa de juros anual (decimal, ex.: 0.12 para 12%):")
    taxa_anual = parse(Float64, readline())
    
    println("Digite o valor de entrada:")
    entrada = parse(Float64, readline())
    
    println("Digite o valor total financiado:")
    total = parse(Float64, readline())

    if entrada >= total
        error("Valor de entrada deve ser menor que o valor total!")
    end
    
    valor_financiado = total - entrada
    taxa_mensal = (1 + taxa_anual)^(1/12) - 1  # Correção na conversão da taxa

    sac = calcular_sac(valor_financiado, n, taxa_mensal)
    price = calcular_price(valor_financiado, n, taxa_mensal)

    cruzamento = nothing
    for i in 1:n
        if sac[i] < price[i]
            cruzamento = i
            break
        end
    end

    println("\nParcelas SAC:")
    for (mes, parc) in enumerate(sac)
        @printf("Mês %3d: R\$%9.2f\n", mes, parc)
    end

    println("\nParcelas PRICE:")
    for (mes, parc) in enumerate(price)
        @printf("Mês %3d: R\$%9.2f\n", mes, parc)
    end

    total_sac = entrada + sum(sac)
    juros_sac = sum(sac) - valor_financiado
    
    total_price = entrada + sum(price)
    juros_price = sum(price) - valor_financiado

    println("\nResumo SAC:")
    @printf("Total pago: R\$%.2f\n", total_sac)
    @printf("Total juros: R\$%.2f\n", juros_sac)

    println("\nResumo PRICE:")
    @printf("Total pago: R\$%.2f\n", total_price)
    @printf("Total juros: R\$%.2f\n", juros_price)

    vantajoso = total_sac < total_price ? "SAC" : "PRICE"
    info_cruzamento = isnothing(cruzamento) ? "Não houve cruzamento" : @sprintf("Cruzamento no mês %d", cruzamento)

    println("\nAnálise Comparativa:")
    println("- Sistema mais econômico: ", vantajoso)
    @printf("- 1ª parcela SAC: R\$%.2f vs PRICE: R\$%.2f\n", sac[1], price[1])
    println("- ", info_cruzamento)

    # Animação das parcelas
    anim_parcelas = @animate for mes in 1:n
        p = plot(sac[1:mes], label="SAC", lw=2, 
                xlabel="Meses", ylabel="Valor", 
                title="Evolução das Parcelas (Mês $mes)",
                legend=:topright)
        plot!(p, price[1:mes], label="PRICE", lw=2)
        if !isnothing(cruzamento) && mes >= cruzamento
            vline!(p, [cruzamento], label="Cruzamento", ls=:dash)
        end
    end
    gif(anim_parcelas, "parcelas.gif", fps=2)

    # Animação do acumulado
    anim_acumulado = @animate for mes in 1:n
        p = plot(cumsum(sac[1:mes]), label="SAC", lw=2,
                xlabel="Meses", ylabel="Total Pago",
                title="Acumulado Total (Mês $mes)",
                legend=:topleft)
        plot!(p, cumsum(price[1:mes]), label="PRICE", lw=2)
    end
    gif(anim_acumulado, "acumulado.gif", fps=2)

    # Gráfico comparativo estático
    p = plot(sac, label="SAC", lw=2, 
            xlabel="Meses", ylabel="Valor",
            title="Comparação SAC vs PRICE")
    plot!(p, price, label="PRICE", lw=2)
    if !isnothing(cruzamento)
        vline!(p, [cruzamento], label="Cruzamento", ls=:dash)
    end
    display(p)
end

main()