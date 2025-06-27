### Simulador de Pizzas - Quantas Pedir? 🍕

# Pacotes necessários
begin
	using PlutoUI, Plots, Statistics, Distributions, Random
	using Printf, StatsBase
end

# Título e introdução
md"""
# 🍕 Simulador de Pizzas: Quantas Pedir?

Este simulador usa **estatística e probabilidade** para calcular quantas pizzas você deve pedir considerando:
- Variabilidade no apetite das pessoas
- Diferentes tipos de eventos
- Nível de confiança desejado
- Desperdício vs falta de comida
"""

# Controles da simulação
md"""
## 🎛️ Parâmetros do Evento

**Número de Pessoas:** $(@bind n_pessoas Slider(5:1:100, show_value=true, default=20))

**Tipo de Evento:** $(@bind tipo_evento Select([
	"casual" => "Casual (casa de amigos)", 
	"trabalho" => "Trabalho/Corporativo",
	"festa" => "Festa/Aniversário",
	"criancas" => "Festa Infantil",
	"esportivo" => "Assistindo Jogo"
], default="casual"))

**Horário:** $(@bind horario Select([
	"almoco" => "Almoço (12h-14h)",
	"lanche" => "Lanche (15h-17h)", 
	"jantar" => "Jantar (19h-21h)",
	"madrugada" => "Madrugada (22h+)"
], default="jantar"))

**Nível de Confiança:** $(@bind confianca Slider(0.80:0.05:0.99, show_value=true, default=0.90))

**Há outras comidas?** $(@bind outras_comidas CheckBox(default=false))

**Mostrar Simulação:** $(@bind mostrar_simulacao CheckBox(default=true))
"""

# Parâmetros baseados no contexto
begin
	# Fatias por pessoa (média) baseado no contexto
	if tipo_evento == "casual"
		μ_fatias = horario == "almoco" ? 3.5 : horario == "jantar" ? 4.0 : 2.5
		σ_fatias = 1.2
	elseif tipo_evento == "trabalho"
		μ_fatias = horario == "almoco" ? 2.8 : 2.0
		σ_fatias = 0.8
	elseif tipo_evento == "festa"
		μ_fatias = horario == "jantar" ? 4.5 : 3.5
		σ_fatias = 1.5
	elseif tipo_evento == "criancas"
		μ_fatias = 2.0
		σ_fatias = 0.7
	elseif tipo_evento == "esportivo"
		μ_fatias = 5.0  # Pessoal come mais assistindo jogo!
		σ_fatias = 1.8
	end
	
	# Ajuste se há outras comidas
	if outras_comidas
		μ_fatias *= 0.7
		σ_fatias *= 0.8
	end
	
	# Ajuste por horário
	if horario == "madrugada"
		μ_fatias *= 1.2  # Pessoal come mais de madrugada
	elseif horario == "lanche"
		μ_fatias *= 0.8
	end
end

# Simulação Monte Carlo
begin
	Random.seed!(42)
	n_sim = 10000
	
	# Simular consumo individual (distribuição Gamma é mais realista)
	# Gamma evita valores negativos e tem cauda longa
	α = (μ_fatias / σ_fatias)^2  # parâmetro de forma
	θ = σ_fatias^2 / μ_fatias    # parâmetro de escala
	
	consumo_individual = rand(Gamma(α, θ), n_sim, n_pessoas)
	consumo_total = sum(consumo_individual, dims=2)[:, 1]
	
	# Converter para pizzas (8 fatias por pizza)
	fatias_por_pizza = 8
	pizzas_necessarias = consumo_total ./ fatias_por_pizza
	
	# Estatísticas
	media_pizzas = mean(pizzas_necessarias)
	std_pizzas = std(pizzas_necessarias)
	quantil_pizzas = quantile(pizzas_necessarias, confianca)
	
	# Recomendação (sempre arredondar para cima)
	pizzas_recomendadas = ceil(Int, quantil_pizzas)
	
	# Probabilidade de sobrar vs faltar
	prob_sobrar = mean(pizzas_necessarias .<= pizzas_recomendadas)
	prob_faltar = 1 - prob_sobrar
end

# Gráfico da distribuição
begin
	if mostrar_simulacao
		hist_plot = histogram(pizzas_necessarias, bins=30, alpha=0.7, 
			color=:orange, normalize=:probability,
			title="Distribuição de Pizzas Necessárias\n($n_pessoas pessoas, $tipo_evento, $horario)",
			xlabel="Número de Pizzas", ylabel="Probabilidade",
			legend=false)
		
		# Linha da média
		vline!(hist_plot, [media_pizzas], color=:blue, linewidth=3, 
			label="Média", linestyle=:dash)
		
		# Linha da recomendação
		vline!(hist_plot, [pizzas_recomendadas], color=:red, linewidth=3,
			label="Recomendação")
		
		# Área de confiança
		área_confiança = pizzas_necessarias .<= pizzas_recomendadas
		if sum(área_confiança) > 0
			histogram!(hist_plot, pizzas_necessarias[área_confiança], 
				bins=30, alpha=0.5, color=:green, normalize=:probability)
		end
		
		hist_plot
	else
		plot(title="Ative 'Mostrar Simulação' para ver o gráfico", 
			showaxis=false, grid=false, legend=false)
	end
end

# Resultados principais
md"""
## 🎯 Resultado da Simulação

### Recomendação Principal:
# **$(pizzas_recomendadas) pizzas** 🍕

### Estatísticas Detalhadas:
- **Média esperada:** $(round(media_pizzas, digits=2)) pizzas
- **Desvio padrão:** $(round(std_pizzas, digits=2)) pizzas  
- **Nível de confiança:** $(round(confianca*100, digits=1))%
- **Probabilidade de sobrar:** $(round(prob_sobrar*100, digits=1))%
- **Probabilidade de faltar:** $(round(prob_faltar*100, digits=1))%

### Consumo Médio Estimado:
- **Por pessoa:** $(round(μ_fatias, digits=1)) fatias
- **Total:** $(round(μ_fatias * n_pessoas, digits=1)) fatias
- **Equivale a:** $(round(μ_fatias * n_pessoas / 8, digits=1)) pizzas
"""

# Análise de sensibilidade
begin
	# Testar diferentes números de pizzas
	pizzas_teste = (pizzas_recomendadas-2):(pizzas_recomendadas+3)
	pizzas_teste = pizzas_teste[pizzas_teste .> 0]
	
	resultados = []
	for p in pizzas_teste
		fatias_disponíveis = p * fatias_por_pizza
		prob_suficiente = mean(consumo_total .<= fatias_disponíveis)
		prob_desperdicio = mean(consumo_total .< fatias_disponíveis * 0.8)
		push!(resultados, (p, prob_suficiente, prob_desperdicio))
	end
	
	# Gráfico de análise
	pizzas_vals = [r[1] for r in resultados]
	prob_suficiente_vals = [r[2] for r in resultados]
	prob_desperdicio_vals = [r[3] for r in resultados]
	
	analise_plot = plot(pizzas_vals, prob_suficiente_vals * 100, 
		marker=:circle, linewidth=3, color=:green,
		label="Probabilidade de Ser Suficiente", 
		title="Análise de Sensibilidade",
		xlabel="Número de Pizzas", ylabel="Probabilidade (%)",
		ylim=(0, 100), legend=:right)
	
	plot!(analise_plot, pizzas_vals, prob_desperdicio_vals * 100,
		marker=:square, linewidth=3, color=:red,
		label="Probabilidade de Muito Desperdício")
	
	# Linha da recomendação
	vline!(analise_plot, [pizzas_recomendadas], color=:blue, 
		linewidth=2, linestyle=:dash, label="Recomendação")
	
	analise_plot
end

# Tabela de cenários
md"""
## 📊 Tabela de Cenários

| Pizzas | Prob. Suficiente | Prob. Desperdício | Recomendação |
|--------|------------------|-------------------|--------------|
$(join([
	"| $(r[1]) | $(round(r[2]*100, digits=1))% | $(round(r[3]*100, digits=1))% | $(r[1] == pizzas_recomendadas ? "✅ **Ótimo**" : r[2] < 0.8 ? "⚠️ Arriscado" : r[3] > 0.3 ? "💸 Muito desperdício" : "👍 Razoável") |"
	for r in resultados
], "\n"))
"""

# Dicas adicionais
md"""
## 💡 Dicas Estatísticas e Práticas

### Como Funciona a Simulação:
1. **Distribuição Gamma**: Modela o consumo individual (sempre positivo, com cauda longa)
2. **Monte Carlo**: Simula $(n_sim) cenários diferentes
3. **Quantil**: Usa o percentil $(round(confianca*100))% para a recomendação

### Fatores Considerados:
- **Tipo de evento**: $(tipo_evento) (afeta apetite médio)
- **Horário**: $(horario) (influencia fome)
- **Outras comidas**: $(outras_comidas ? "Sim" : "Não") (reduz consumo de pizza)
- **Variabilidade**: Pessoas comem diferente (σ = $(round(σ_fatias, digits=1)))

### Interpretação dos Resultados:
$(if prob_faltar < 0.05
	"🟢 **Baixo risco**: Chance muito pequena de faltar pizza"
elseif prob_faltar < 0.15
	"🟡 **Risco moderado**: Pequena chance de faltar, mas controlada"
else
	"🔴 **Alto risco**: Considere pedir mais pizzas ou aumentar nível de confiança"
end)

$(if prob_desperdicio_vals[findfirst(x -> x == pizzas_recomendadas, pizzas_vals)] > 0.4
	"💸 **Atenção**: Alto risco de desperdício significativo"
else
	"💚 **Equilibrado**: Boa relação entre suficiência e desperdício"
end)

### Para Eventos Especiais:
- **Reunião importante**: Use confiança ≥ 95%
- **Orçamento apertado**: Use confiança ≈ 85%
- **Sobra é ok**: Use confiança ≥ 95%
- **Quer ser exato**: Use confiança ≈ 80%
"""