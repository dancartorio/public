### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 70192a52-275b-11f0-00fb-933573a8737f
begin
    using PlutoUI
    using Markdown
    
    # Definir as cores como constantes globais
    const PRIMARY_COLOR = "#3498db"
    const SECONDARY_COLOR = "#2ecc71"
end

# ╔═╡ ebef3ede-e3ef-4cb3-89ad-7c38180c3f4c
md"""
# 📐 Guia de Estudo: Conversor de Unidades e Sistema Internacional de Medidas

## 🔹 1. Introdução

A conversão de unidades é essencial para trabalhar com diferentes sistemas de medição, especialmente em áreas como ciência, engenharia e comércio internacional. O **Sistema Internacional de Unidades (SI)** é o sistema padrão usado mundialmente.

---

## 🔸 2. Sistema Internacional de Unidades (SI)

O SI é baseado em **7 unidades fundamentais**:

| Grandeza Física        | Unidade SI  | Símbolo |
|------------------------|-------------|---------|
| Comprimento            | metro       | m       |
| Massa                  | quilograma  | kg      |
| Tempo                  | segundo     | s       |
| Corrente elétrica      | ampère      | A       |
| Temperatura termodinâmica | kelvin   | K       |
| Quantidade de substância | mol       | mol     |
| Intensidade luminosa   | candela     | cd      |

### 🌟 Prefixos do SI

Usamos prefixos para representar múltiplos ou submúltiplos das unidades:

| Prefixo  | Símbolo | Fator         |
|----------|---------|---------------|
| giga     | G       | 10⁹           |
| mega     | M       | 10⁶           |
| quilo    | k       | 10³           |
| hecto    | h       | 10²           |
| deca     | da      | 10¹           |
| (base)   | —       | 10⁰           |
| deci     | d       | 10⁻¹          |
| centi    | c       | 10⁻²          |
| mili     | m       | 10⁻³          |
| micro    | µ       | 10⁻⁶          |
| nano     | n       | 10⁻⁹          |

---

## 🔸 3. Unidades Comuns e Conversões

### 📏 Comprimento

| Unidade     | Equivalência em metros |
|-------------|------------------------|
| 1 km        | 1.000 m                |
| 1 m         | 1 m                    |
| 1 cm        | 0,01 m                 |
| 1 mm        | 0,001 m                |
| 1 pol (in)  | 0,0254 m               |
| 1 pé (ft)   | 0,3048 m               |

### ⚖️ Massa

| Unidade     | Equivalência em kg     |
|-------------|------------------------|
| 1 tonelada  | 1.000 kg               |
| 1 kg        | 1 kg                   |
| 1 g         | 0,001 kg               |
| 1 mg        | 0,000001 kg            |
| 1 lb (libra)| 0,453592 kg            |

### ⏱️ Tempo

| Unidade     | Equivalência em segundos |
|-------------|--------------------------|
| 1 hora      | 3600 s                   |
| 1 minuto    | 60 s                     |
| 1 dia       | 86.400 s                 |

### 🌡️ Temperatura

- Celsius → Kelvin: `K = °C + 273,15`
- Fahrenheit → Celsius: `°C = (°F - 32) × 5/9`

---

## 🔸 4. Como Converter Unidades

### ✅ Etapas básicas:

1. **Identifique** a unidade de origem e a de destino.
2. **Multiplique ou divida** usando a equivalência correta.
3. **Use fator unitário** para garantir que as unidades sejam canceladas corretamente.

### 🧮 Exemplo:

Converter 5 km para metros:


"""

# ╔═╡ e0c3fbcc-c588-4aa8-8409-e7d8e49d8643
md"""
### Velocidade

Um carro está se deslocando a uma velocidade constante de **5 quilômetros por hora (km/h)**. Para realizar certos cálculos de física, é necessário converter essa velocidade para *metros* por *segundo* (m/s).

Utilize os fatores de conversão:
- **1km = 1000m**
- **1h = 3600s**

##### Pergunta:

Qual é a velocidade do carro em metros por segundo?

---

Dado:

$$5 \frac{km}{h} \cdot \left[\frac{1000 \, m}{1 \, km}\right] \cdot \left[\frac{1 \, h}{3600 \, s}\right] = 5 \cdot \frac{1000 \, m}{3600 \, s} = 5 \cdot \frac{1 \times 10^3 \, m}{3{,}6 \times 10^3 \, s} = \frac{5}{3{,}6} \frac{m}{s} = 1{,}39 \, m/s$$

Também é possível usar a seguinte regra prática:

- Para converter de km/h para m/s: **divida por 3,6**
- Para converter de m/s para km/h: **multiplique por 3,6**

"""

# ╔═╡ 431fa16a-a5ba-4b1b-b5fb-e0412f3d0b5b
md"""
# Fórmulas Matemáticas para Conversão de Unidades

## 1. Conversão Linear Padrão

Para unidades como comprimento, massa e tempo:

$$\text{ValorConvertido} = \text{ValorOriginal} \times \left( \frac{\text{FatorUnidadeOrigem}}{\text{FatorUnidadeDestino}} \right)$$

**Exemplo** (quilômetros → metros):

$$5\,\text{km} = 5 \times \left( \frac{1000\,\text{m}}{1\,\text{km}} \right) = 5000\,\text{m}$$

## 2. Conversão de Temperatura

### Celsius ↔ Fahrenheit

$$°F = °C \times \frac{9}{5} + 32 \\
°C = (°F - 32) \times \frac{5}{9}$$

### Celsius ↔ Kelvin

$$K = °C + 273.15 \\
°C = K - 273.15$$

### Fahrenheit ↔ Kelvin

$$K = (°F - 32) \times \frac{5}{9} + 273.15 \\
°F = (K - 273.15) \times \frac{9}{5} + 32$$

## 3. Conversão de Área (Unidades Quadradas)

$$\text{ÁreaConvertida} = \text{ÁreaOriginal} \times \left( \frac{\text{FatorLinearOrigem}}{\text{FatorLinearDestino}} \right)^2$$

**Exemplo** (pés² → m²):

$$10\,\text{pés}^2 = 10 \times \left( \frac{0.3048\,\text{m}}{1\,\text{pé}} \right)^2 \approx 0.929\,\text{m}^2$$

## 4. Fluxo de Conversão Genérico

$$\text{Resultado} = \begin{cases} \text{Valor} \times \frac{\text{FatorOrigem}}{\text{FatorDestino}}, & \text{para unidades lineares} \\\text{Fórmulas de temperatura}, & \text{para conversão termométrica}
\end{cases}$$

> **Nota**: Todos os fatores de conversão são relativos a uma unidade base padrão (metro, grama, segundo, etc.)
"""

# ╔═╡ 9bd1eced-dc4e-4a78-8740-55529fb86df2
md"""
# 📏 Conversor de Unidades Dinâmico

Bem-vindo ao conversor de unidades interativo! Selecione o tipo de unidade e os valores para conversão abaixo.
"""

# ╔═╡ 660a57cc-f929-45fe-a1be-fdea4f7ddd0d
begin
    categories = Dict(
        "Comprimento" => Dict(
            "metros" => 1.0,
            "quilômetros" => 1000.0,
            "centímetros" => 0.01,
            "milímetros" => 0.001,
            "polegadas" => 0.0254,
            "pés" => 0.3048,
            "jardas" => 0.9144,
            "milhas" => 1609.34
        ),
        "Massa" => Dict(
            "gramas" => 1.0,
            "quilogramas" => 1000.0,
            "miligramas" => 0.001,
            "libras" => 453.592,
            "onças" => 28.3495
        ),
        "Temperatura" => Dict(
            "Celsius" => :celsius,
            "Fahrenheit" => :fahrenheit,
            "Kelvin" => :kelvin
        ),
        "Tempo" => Dict(
            "segundos" => 1.0,
            "minutos" => 60.0,
            "horas" => 3600.0,
            "dias" => 86400.0,
            "semanas" => 604800.0
        )
    )
    
    @bind category Select(collect(keys(categories)))
end

# ╔═╡ 972b9cb7-6cb5-4666-aeb1-e15442fd0ff2
begin
    local_units = categories[category]
    is_temperature = category == "Temperatura"
    
    if is_temperature
        md"""
        ### 🌡 Conversão de Temperatura
        
        De: $(@bind from_unit Select(collect(keys(local_units))))
        Para: $(@bind to_unit Select(collect(keys(local_units))))
        
        Valor: $(@bind input_value NumberField(-273.15:0.1:1000; default=0))
        """
    else
        md"""
        ### 🔄 Conversão de $(category)
        
        De: $(@bind from_unit Select(collect(keys(local_units))))
        Para: $(@bind to_unit Select(collect(keys(local_units))))
        
        Valor: $(@bind input_value NumberField(0:0.1:10000; default=1))
        """
    end
end

# ╔═╡ a920268f-e5f4-4b59-af14-1110035aef83
begin
    # Funções de conversão (mesmo código anterior)
    function convert_units(val, from, to, units_dict)
        factor_from = units_dict[from]
        factor_to = units_dict[to]
        val * factor_from / factor_to
    end
    
    function convert_temperature(val, from, to)
        from == to && return val
        
        celsius = if from == "Fahrenheit"
            (val - 32) * 5/9
        elseif from == "Kelvin"
            val - 273.15
        else
            val
        end
        
        if to == "Fahrenheit"
            celsius * 9/5 + 32
        elseif to == "Kelvin"
            celsius + 273.15
        else
            celsius
        end
    end
    
    # Realizar a conversão
    if category == "Temperatura"
        result = convert_temperature(input_value, from_unit, to_unit)
    else
        result = convert_units(input_value, from_unit, to_unit, local_units)
    end
    
    # Exibir o resultado formatado usando as constantes
    HTML("""
    <div style="
        border: 2px solid $(PRIMARY_COLOR);
        border-radius: 10px;
        padding: 20px;
        margin: 20px 0;
        background-color: #f8f9fa;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    ">
        <p style="font-size: 1.2em; color: #333;">
            $(round(input_value, digits=4)) $(from_unit) = 
            <span style="color: $(SECONDARY_COLOR); font-weight: bold;">
                $(round(result, digits=4)) $(to_unit)
            </span>
        </p>
    </div>
    """)
end

# ╔═╡ 5a9ce3a9-5e80-48c9-bf9c-7545a446cf56
begin
    conversion_factor = round(local_units[from_unit]/local_units[to_unit], digits=6)
    inverse_factor = round(local_units[to_unit]/local_units[from_unit], digits=6)
    
    HTML("""
    <div style="
        background-color: #f0f8ff;
        padding: 15px;
        border-radius: 8px;
        border-left: 4px solid $(PRIMARY_COLOR);
        margin-top: 10px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    ">
        <div style="
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 10px;
        ">
            <div style="
                background-color: white;
                padding: 12px;
                border-radius: 6px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            ">
                <div style="font-weight: bold; color: $(PRIMARY_COLOR); margin-bottom: 5px;">
                    ⇩ Conversão Direta
                </div>
                <div style="font-family: monospace; font-size: 1.1em;">
                    1 $(from_unit) = $(conversion_factor) $(to_unit)
                </div>
            </div>
            
            <div style="
                background-color: white;
                padding: 12px;
                border-radius: 6px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            ">
                <div style="font-weight: bold; color: $(PRIMARY_COLOR); margin-bottom: 5px;">
                    ⇧ Conversão Inversa
                </div>
                <div style="font-family: monospace; font-size: 1.1em;">
                    1 $(to_unit) = $(inverse_factor) $(from_unit)
                </div>
            </div>
        </div>
        
        <div style="
            margin-top: 15px;
            font-size: 0.9em;
            color: #555;
            border-top: 1px dashed #ccc;
            padding-top: 10px;
        ">
            <b>Dica:</b> Para converter qualquer valor, multiplique pelo fator de conversão correspondente.
        </div>
    </div>
    """)
end

# ╔═╡ 3a267f09-2d44-4f5e-8da6-7e64d0d1da74
md"""

---

## 🔸 5. Dicas de Estudo

- Faça tabelas-resumo como esta para revisar rapidamente.
- Pratique com exercícios de conversão.
- Memorize os prefixos mais usados (kilo, centi, mili, etc.).
- Use calculadoras ou sites como o [Convert Units](https://www.convertunits.com) para conferir.

---

## 📚 Exercícios Sugeridos

1. Converta 2500 mm em metros.
2. Quantos gramas há em 3,2 kg?
3. Converta 98,6°F para Celsius.
4. Quantos segundos há em 2 dias?
5. Converta 5 metros para polegadas.

---

> “Medir é o primeiro passo para entender.” – Anônimo


"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.61"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "52fc60b5f0a743b12e08790348d61a4f8b4c7b6c"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "7e71a55b87222942f0f9337be62e26b1f103d3e4"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.61"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═70192a52-275b-11f0-00fb-933573a8737f
# ╟─ebef3ede-e3ef-4cb3-89ad-7c38180c3f4c
# ╟─e0c3fbcc-c588-4aa8-8409-e7d8e49d8643
# ╟─431fa16a-a5ba-4b1b-b5fb-e0412f3d0b5b
# ╟─9bd1eced-dc4e-4a78-8740-55529fb86df2
# ╟─660a57cc-f929-45fe-a1be-fdea4f7ddd0d
# ╟─972b9cb7-6cb5-4666-aeb1-e15442fd0ff2
# ╟─a920268f-e5f4-4b59-af14-1110035aef83
# ╟─5a9ce3a9-5e80-48c9-bf9c-7545a446cf56
# ╟─3a267f09-2d44-4f5e-8da6-7e64d0d1da74
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
