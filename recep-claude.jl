using Printf

# Modelo M/M/5 - Teoria de Filas para Cartório de Imóveis
# M/M/5: Chegadas Poisson, Tempos de Serviço Exponenciais, 5 Guichês

struct ModeloMM5
    s::Int              # Número de guichês (servidores)
    lambda::Float64     # Taxa de chegadas (clientes/hora)
    mu::Float64         # Taxa de atendimento por guichê (atendimentos/hora)
    a::Float64          # Carga oferecida (λ/μ)
    rho::Float64        # Utilização por guichê (a/s)
end

function criar_modelo_cartorio()
    println("=== MODELO M/M/5 - CARTÓRIO DE IMÓVEIS ===\n")
    println("HIPÓTESES:")
    println("• Número de guichês: s = 5")
    println("• Taxa de chegadas: λ = 36 clientes/hora")
    println("• Taxa de atendimento por guichê: μ = 9 atendimentos/hora")
    println("• Tempo médio por atendimento: 1/μ = 1/9 h ≈ 6,67 min (6 min 40s)\n")
    
    s = 5
    lambda = 36.0
    mu = 9.0
    a = lambda / mu
    rho = a / s
    
    println("1) PARÂMETROS INICIAIS")
    println("• Carga oferecida: a = λ/μ = 36/9 = $(a)")
    println("• Utilização por guichê: ρ = a/s = $(a)/$(s) = $(rho) ($(rho*100)% de ocupação)")
    println("• Sistema estável? $(rho < 1 ? "SIM" : "NÃO") (ρ < 1 = $(rho < 1))\n")
    
    return ModeloMM5(s, lambda, mu, a, rho)
end

function calcular_p0(modelo::ModeloMM5)
    println("2) PROBABILIDADE DE SISTEMA VAZIO (P₀)")
    println("Fórmula: P₀ = 1 / [∑ₖ₌₀ˢ⁻¹ (aᵏ/k!) + (aˢ/s!) × (1/(1-ρ))]")
    
    # Calcular o somatório ∑k=0 a s-1 de (a^k / k!)
    println("\nCálculo do somatório ∑ₖ₌₀⁴ (aᵏ/k!):")
    somatorio = 0.0
    for k in 0:(modelo.s-1)
        termo = (modelo.a^k) / factorial(k)
        println("k=$k: a^$k/$(k)! = $(modelo.a)^$k/$(factorial(k)) = $(round(termo, digits=6))")
        somatorio += termo
    end
    println("Somatório = $(round(somatorio, digits=6))")
    
    # Calcular o termo (a^s / s!) × (1/(1-ρ))
    termo_final = (modelo.a^modelo.s / factorial(modelo.s)) * (1 / (1 - modelo.rho))
    println("\nTermo final: (a^s/s!) × (1/(1-ρ))")
    println("= ($(modelo.a)^$(modelo.s)/$(factorial(modelo.s))) × (1/(1-$(modelo.rho)))")
    println("= $(round(modelo.a^modelo.s / factorial(modelo.s), digits=6)) × $(round(1/(1-modelo.rho), digits=6))")
    println("= $(round(termo_final, digits=6))")
    
    # Calcular P₀
    denominador = somatorio + termo_final
    p0 = 1 / denominador
    
    println("\nP₀ = 1 / ($(round(somatorio, digits=6)) + $(round(termo_final, digits=6)))")
    println("P₀ = 1 / $(round(denominador, digits=6))")
    println("P₀ = $(round(p0, digits=6)) = $(round(p0*100, digits=2))%\n")
    
    return p0
end

function calcular_probabilidades_sistema(modelo::ModeloMM5, p0::Float64)
    println("3) PROBABILIDADES DO SISTEMA")
    
    println("P(n clientes no sistema):")
    
    # Para n = 0 a s-1 (menos de s clientes)
    for n in 0:(modelo.s-1)
        pn = (modelo.a^n / factorial(n)) * p0
        println("P($n) = (a^$n/$(n)!) × P₀ = $(round(pn, digits=6)) = $(round(pn*100, digits=2))%")
    end
    
    # Para n ≥ s (fila presente)
    println("\nPara n ≥ s (com fila):")
    println("P(n) = (a^n / (s! × s^(n-s))) × P₀")
    
    # Exemplos para n = 5, 6, 7, 8, 9, 10
    for n in modelo.s:(modelo.s+5)
        pn = (modelo.a^n / (factorial(modelo.s) * modelo.s^(n - modelo.s))) * p0
        println("P($n) = $(round(pn, digits=6)) = $(round(pn*100, digits=2))%")
    end
    
    println()
end

function calcular_metricas_fila(modelo::ModeloMM5, p0::Float64)
    println("4) MÉTRICAS DE DESEMPENHO DA FILA")
    
    # Probabilidade de espera (P_wait)
    p_wait = ((modelo.a^modelo.s) / factorial(modelo.s)) * (1 / (1 - modelo.rho)) * p0
    
    println("a) PROBABILIDADE DE ESPERAR (P_wait):")
    println("P_wait = (a^s/s!) × (1/(1-ρ)) × P₀")
    println("P_wait = ($(modelo.a)^$(modelo.s)/$(factorial(modelo.s))) × (1/(1-$(modelo.rho))) × $(round(p0, digits=6))")
    println("P_wait = $(round(p_wait, digits=6)) = $(round(p_wait*100, digits=2))%")
    println("→ $(round(p_wait*100, digits=1))% dos clientes precisam esperar em fila\n")
    
    # Número médio de clientes na fila (Lq)
    lq = (modelo.rho * modelo.a^modelo.s * p0) / (factorial(modelo.s) * (1 - modelo.rho)^2)
    
    println("b) NÚMERO MÉDIO DE CLIENTES NA FILA (Lq):")
    println("Lq = (ρ × a^s × P₀) / (s! × (1-ρ)²)")
    println("Lq = ($(modelo.rho) × $(modelo.a)^$(modelo.s) × $(round(p0, digits=6))) / ($(factorial(modelo.s)) × (1-$(modelo.rho))²)")
    println("Lq = $(round(lq, digits=4)) clientes")
    println("→ Em média, $(round(lq, digits=1)) clientes aguardando em fila\n")
    
    # Tempo médio de espera na fila (Wq)
    wq = lq / modelo.lambda
    
    println("c) TEMPO MÉDIO DE ESPERA NA FILA (Wq):")
    println("Wq = Lq / λ")
    println("Wq = $(round(lq, digits=4)) / $(modelo.lambda)")
    println("Wq = $(round(wq, digits=4)) horas = $(round(wq*60, digits=2)) minutos")
    println("→ Tempo médio de espera: $(round(wq*60, digits=1)) minutos\n")
    
    # Número médio de clientes no sistema (L)
    l = lq + modelo.a
    
    println("d) NÚMERO MÉDIO DE CLIENTES NO SISTEMA (L):")
    println("L = Lq + a")
    println("L = $(round(lq, digits=4)) + $(modelo.a)")
    println("L = $(round(l, digits=4)) clientes")
    println("→ Em média, $(round(l, digits=1)) clientes no cartório\n")
    
    # Tempo médio no sistema (W)
    w = l / modelo.lambda
    
    println("e) TEMPO MÉDIO NO SISTEMA (W):")
    println("W = L / λ")
    println("W = $(round(l, digits=4)) / $(modelo.lambda)")
    println("W = $(round(w, digits=4)) horas = $(round(w*60, digits=2)) minutos")
    println("→ Tempo total médio no cartório: $(round(w*60, digits=1)) minutos\n")
    
    return (p_wait, lq, wq, l, w)
end

function analisar_cenarios_alternativos(modelo_base::ModeloMM5)
    println("5) ANÁLISE DE CENÁRIOS ALTERNATIVOS")
    
    println("CENÁRIO 1: Redução para 4 guichês (s=4)")
    modelo_4 = ModeloMM5(4, modelo_base.lambda, modelo_base.mu, modelo_base.a, modelo_base.a/4)
    println("• ρ = $(modelo_4.rho) ($(round(modelo_4.rho*100, digits=1))% ocupação)")
    if modelo_4.rho >= 1
        println("• SISTEMA INSTÁVEL! (ρ ≥ 1)")
    else
        p0_4 = 1 / (sum((modelo_4.a^k)/factorial(k) for k in 0:3) + 
                   (modelo_4.a^4/factorial(4)) * (1/(1-modelo_4.rho)))
        p_wait_4 = ((modelo_4.a^4)/factorial(4)) * (1/(1-modelo_4.rho)) * p0_4
        println("• Probabilidade de espera: $(round(p_wait_4*100, digits=1))%")
    end
    
    println("\nCENÁRIO 2: Aumento para 6 guichês (s=6)")
    modelo_6 = ModeloMM5(6, modelo_base.lambda, modelo_base.mu, modelo_base.a, modelo_base.a/6)
    println("• ρ = $(round(modelo_6.rho, digits=3)) ($(round(modelo_6.rho*100, digits=1))% ocupação)")
    p0_6 = 1 / (sum((modelo_6.a^k)/factorial(k) for k in 0:5) + 
               (modelo_6.a^6/factorial(6)) * (1/(1-modelo_6.rho)))
    p_wait_6 = ((modelo_6.a^6)/factorial(6)) * (1/(1-modelo_6.rho)) * p0_6
    println("• Probabilidade de espera: $(round(p_wait_6*100, digits=2))%")
    
    println("\nCENÁRIO 3: Melhoria da eficiência (μ=12 atend/h)")
    modelo_efic = ModeloMM5(5, modelo_base.lambda, 12.0, modelo_base.lambda/12.0, (modelo_base.lambda/12.0)/5)
    println("• Nova carga: a = $(modelo_efic.a)")
    println("• ρ = $(modelo_efic.rho) ($(round(modelo_efic.rho*100, digits=1))% ocupação)")
    p0_efic = 1 / (sum((modelo_efic.a^k)/factorial(k) for k in 0:4) + 
                  (modelo_efic.a^5/factorial(5)) * (1/(1-modelo_efic.rho)))
    p_wait_efic = ((modelo_efic.a^5)/factorial(5)) * (1/(1-modelo_efic.rho)) * p0_efic
    println("• Probabilidade de espera: $(round(p_wait_efic*100, digits=2))%")
    println()
end

function interpretar_resultados_praticos()
    println("6) INTERPRETAÇÃO PRÁTICA PARA O CARTÓRIO")
    println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    println("SIGNIFICADO DOS RESULTADOS:")
    println("• Com 5 guichês operando a 80% da capacidade:")
    println("  - Sistema estável e eficiente")
    println("  - Baixa probabilidade de filas longas")
    println("  - Tempo de espera controlado")
    
    println("\nRECOMENDAÇÕES OPERACIONAIS:")
    println("1. MONITORAMENTO: Acompanhar se λ = 36 clientes/h se mantém")
    println("2. EFICIÊNCIA: Manter μ = 9 atendimentos/h por guichê")
    println("3. FLEXIBILIDADE: Ter 1 guichê extra para picos de demanda")
    println("4. TREINAMENTO: Focar na padronização do tempo de atendimento")
    
    println("\nINDICADORES DE ALERTA:")
    println("• Se ρ > 0.85: Risco de filas excessivas")
    println("• Se P_wait > 30%: Considerar otimizações")
    println("• Se Wq > 10 min: Revisar processos")
    
    println("\nBENEFÍCIOS DO MODELO M/M/5:")
    println("• Previsibilidade do atendimento")
    println("• Otimização de recursos humanos")
    println("• Melhoria na experiência do cliente")
    println("• Base para decisões de expansão")
    println()
end

function main()
    # Criar modelo base
    modelo = criar_modelo_cartorio()
    
    # Calcular P₀
    p0 = calcular_p0(modelo)
    
    # Calcular probabilidades do sistema
    calcular_probabilidades_sistema(modelo, p0)
    
    # Calcular métricas de desempenho
    metricas = calcular_metricas_fila(modelo, p0)
    
    # Analisar cenários alternativos
    analisar_cenarios_alternativos(modelo)
    
    # Interpretação prática
    interpretar_resultados_praticos()
    
    println("=== ANÁLISE M/M/5 CONCLUÍDA ===")
end

# Executar análise
main()