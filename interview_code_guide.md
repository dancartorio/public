# Códigos Essenciais para Entrevistas: Julia vs Python

Este guia apresenta códigos fundamentais que demonstram domínio básico das linguagens Julia e Python em entrevistas técnicas.

## 1. Definindo Funções

### Julia
```julia
# Função simples
function saudacao(nome)
    return "Olá, $(nome)!"  # Use $() ou ${} quando há pontuação após a variável
end

# Testando a função
println(saudacao("Dante"))

# Alternativas corretas:
saudacao2(nome) = "Olá, ${nome}!"  # Com chaves
saudacao3(nome) = "Olá, " * nome * "!"  # Concatenação

# Função com múltiplos argumentos e valor padrão
function calcular_area(largura, altura=1.0)
    return largura * altura
end

# Função com tipo de retorno especificado
function fibonacci(n::Int)::Int
    if n <= 1
        return n
    else
        return fibonacci(n-1) + fibonacci(n-2)
    end
end

# Sintaxe compacta para funções simples
quadrado(x) = x^2
```

### Python
```python
# Função simples
def saudacao(nome):
    return f"Olá, {nome}!"

# Função com múltiplos argumentos e valor padrão
def calcular_area(largura, altura=1.0):
    return largura * altura

# Função com type hints
def fibonacci(n: int) -> int:
    if n <= 1:
        return n
    else:
        return fibonacci(n-1) + fibonacci(n-2)

# Função lambda
quadrado = lambda x: x**2
```

## 2. Trabalhando com DataFrames

### Julia (usando DataFrames.jl)
```julia
using DataFrames, Random

# Criar DataFrame com dados aleatórios
Random.seed!(123)
df = DataFrame(
    id = 1:100,
    nome = ["Pessoa_$i" for i in 1:100],
    idade = rand(18:65, 100),
    salario = rand(3000:15000, 100),
    departamento = rand(["TI", "RH", "Vendas", "Marketing"], 100)
)

# Visualizar primeiras linhas
first(df, 5)

# Filtrar dados
df_filtrado = filter(row -> row.idade > 30, df)

# Agrupar e sumarizar
using Statistics
resultado = combine(groupby(df, :departamento), :salario => mean => :salario_medio)

# Adicionar nova coluna
df.categoria_idade = [idade < 30 ? "Jovem" : idade < 50 ? "Adulto" : "Senior" for idade in df.idade]
```

### Python (usando pandas)
```python
import pandas as pd
import numpy as np
import random

# Criar DataFrame com dados aleatórios
random.seed(123)
np.random.seed(123)

df = pd.DataFrame({
    'id': range(1, 101),
    'nome': [f'Pessoa_{i}' for i in range(1, 101)],
    'idade': np.random.randint(18, 66, 100),
    'salario': np.random.randint(3000, 15001, 100),
    'departamento': np.random.choice(['TI', 'RH', 'Vendas', 'Marketing'], 100)
})

# Visualizar primeiras linhas
print(df.head())

# Filtrar dados
df_filtrado = df[df['idade'] > 30]

# Agrupar e sumarizar
resultado = df.groupby('departamento')['salario'].mean().reset_index()
resultado.columns = ['departamento', 'salario_medio']

# Adicionar nova coluna
df['categoria_idade'] = df['idade'].apply(
    lambda x: 'Jovem' if x < 30 else 'Adulto' if x < 50 else 'Senior'
)
```

## 3. Manipulação de Listas/Arrays

### Julia
```julia
# Criar arrays
numeros = [1, 2, 3, 4, 5]
matriz = [1 2 3; 4 5 6; 7 8 9]

# Operações com arrays
dobrados = numeros .* 2  # Broadcast
pares = filter(x -> x % 2 == 0, numeros)
soma_total = sum(numeros)

# List comprehension
quadrados = [x^2 for x in 1:10]
pares_quadrados = [x^2 for x in 1:10 if x % 2 == 0]

# Ordenação
numeros_desordenados = [3, 1, 4, 1, 5, 9, 2, 6]
ordenados = sort(numeros_desordenados)
```

### Python
```python
# Criar listas
numeros = [1, 2, 3, 4, 5]
matriz = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

# Operações com listas
dobrados = [x * 2 for x in numeros]
pares = list(filter(lambda x: x % 2 == 0, numeros))
soma_total = sum(numeros)

# List comprehension
quadrados = [x**2 for x in range(1, 11)]
pares_quadrados = [x**2 for x in range(1, 11) if x % 2 == 0]

# Ordenação
numeros_desordenados = [3, 1, 4, 1, 5, 9, 2, 6]
ordenados = sorted(numeros_desordenados)
```

## 4. Estruturas de Controle

### Julia
```julia
# If-else
function classificar_nota(nota)
    if nota >= 90
        return "A"
    elseif nota >= 80
        return "B"
    elseif nota >= 70
        return "C"
    else
        return "D"
    end
end

# For loops
for i in 1:5
    println("Iteração: $i")
end

# While loop
contador = 1
while contador <= 5
    println("Contador: $contador")
    contador += 1
end

# Try-catch
function divisao_segura(a, b)
    try
        return a / b
    catch e
        println("Erro: $e")
        return nothing
    end
end
```

### Python
```python
# If-else
def classificar_nota(nota):
    if nota >= 90:
        return "A"
    elif nota >= 80:
        return "B"
    elif nota >= 70:
        return "C"
    else:
        return "D"

# For loops
for i in range(1, 6):
    print(f"Iteração: {i}")

# While loop
contador = 1
while contador <= 5:
    print(f"Contador: {contador}")
    contador += 1

# Try-except
def divisao_segura(a, b):
    try:
        return a / b
    except ZeroDivisionError as e:
        print(f"Erro: {e}")
        return None
```

## 5. Trabalhando com Dicionários/Dict

### Julia
```julia
# Criar dicionário
pessoa = Dict("nome" => "João", "idade" => 30, "cidade" => "São Paulo")

# Acessar valores
nome = pessoa["nome"]

# Adicionar/modificar
pessoa["profissao"] = "Engenheiro"
pessoa["idade"] = 31

# Iterar
for (chave, valor) in pessoa
    println("$chave: $valor")
end

# Verificar se existe chave
if haskey(pessoa, "nome")
    println("Nome encontrado!")
end
```

### Python
```python
# Criar dicionário
pessoa = {"nome": "João", "idade": 30, "cidade": "São Paulo"}

# Acessar valores
nome = pessoa["nome"]

# Adicionar/modificar
pessoa["profissao"] = "Engenheiro"
pessoa["idade"] = 31

# Iterar
for chave, valor in pessoa.items():
    print(f"{chave}: {valor}")

# Verificar se existe chave
if "nome" in pessoa:
    print("Nome encontrado!")
```

## 6. Leitura e Escrita de Arquivos

### Julia
```julia
using CSV, DataFrames

# Escrever arquivo CSV
dados = DataFrame(
    nome = ["Ana", "Bruno", "Carlos"],
    idade = [25, 30, 35],
    salario = [5000, 6000, 7000]
)
CSV.write("funcionarios.csv", dados)

# Ler arquivo CSV
dados_lidos = CSV.read("funcionarios.csv", DataFrame)

# Trabalhar com arquivos texto
open("exemplo.txt", "w") do arquivo
    write(arquivo, "Olá, mundo!\n")
    write(arquivo, "Segunda linha")
end

# Ler arquivo texto
conteudo = read("exemplo.txt", String)
```

### Python
```python
import pandas as pd

# Escrever arquivo CSV
dados = pd.DataFrame({
    'nome': ['Ana', 'Bruno', 'Carlos'],
    'idade': [25, 30, 35],
    'salario': [5000, 6000, 7000]
})
dados.to_csv('funcionarios.csv', index=False)

# Ler arquivo CSV
dados_lidos = pd.read_csv('funcionarios.csv')

# Trabalhar com arquivos texto
with open('exemplo.txt', 'w') as arquivo:
    arquivo.write("Olá, mundo!\n")
    arquivo.write("Segunda linha")

# Ler arquivo texto
with open('exemplo.txt', 'r') as arquivo:
    conteudo = arquivo.read()
```

## 7. Operações Matemáticas e Estatísticas

### Julia
```julia
using Statistics, LinearAlgebra, StatsBase

# Dados de exemplo
numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
dados_com_repeticao = [1, 2, 2, 3, 3, 3, 4, 4, 5]

# Funções estatísticas implementadas manualmente
function calcular_media(dados)
    return sum(dados) / length(dados)
end

function calcular_mediana(dados)
    ordenados = sort(dados)
    n = length(ordenados)
    if n % 2 == 1
        return ordenados[(n + 1) ÷ 2]
    else
        meio1 = ordenados[n ÷ 2]
        meio2 = ordenados[n ÷ 2 + 1]
        return (meio1 + meio2) / 2
    end
end

function calcular_moda(dados)
    # Contar frequências
    freq = Dict{eltype(dados), Int}()
    for valor in dados
        freq[valor] = get(freq, valor, 0) + 1
    end
    
    # Encontrar maior frequência
    max_freq = maximum(values(freq))
    modas = [k for (k, v) in freq if v == max_freq]
    
    return length(modas) == 1 ? modas[1] : modas
end

# Testando funções manuais
println("=== Funções Implementadas Manualmente ===")
println("Média: $(calcular_media(numeros))")
println("Mediana: $(calcular_mediana(numeros))")
println("Moda dos dados [1,2,2,3,3,3,4,4,5]: $(calcular_moda(dados_com_repeticao))")

# Usando bibliotecas built-in
println("\n=== Usando Bibliotecas ===")
media = mean(numeros)
mediana = median(numeros)
moda = mode(dados_com_repeticao)  # StatsBase.jl
desvio_padrao = std(numeros)
minimo = minimum(numeros)
maximo = maximum(numeros)

println("Média (built-in): $media")
println("Mediana (built-in): $mediana")
println("Moda (built-in): $moda")
println("Desvio padrão: $desvio_padrao")
println("Min/Max: $minimo / $maximo")

# Operações com matrizes
A = [1 2; 3 4]
B = [5 6; 7 8]

soma_matriz = A + B
produto_matriz = A * B
determinante = det(A)
inversa = inv(A)

# Estatísticas mais avançadas
dados_grandes = rand(1000)  # 1000 números aleatórios
quartis = quantile(dados_grandes, [0.25, 0.5, 0.75])
println("Quartis: $quartis")
```

### Python
```python
import numpy as np
import pandas as pd
from collections import Counter
from statistics import mode, multimode

# Dados de exemplo
numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
dados_com_repeticao = [1, 2, 2, 3, 3, 3, 4, 4, 5]

# Funções estatísticas implementadas manualmente
def calcular_media(dados):
    return sum(dados) / len(dados)

def calcular_mediana(dados):
    ordenados = sorted(dados)
    n = len(ordenados)
    if n % 2 == 1:
        return ordenados[n // 2]
    else:
        meio1 = ordenados[n // 2 - 1]
        meio2 = ordenados[n // 2]
        return (meio1 + meio2) / 2

def calcular_moda(dados):
    # Método 1: usando Counter
    contador = Counter(dados)
    max_freq = max(contador.values())
    modas = [valor for valor, freq in contador.items() if freq == max_freq]
    return modas[0] if len(modas) == 1 else modas

def calcular_moda_manual(dados):
    # Método 2: implementação manual
    freq = {}
    for valor in dados:
        freq[valor] = freq.get(valor, 0) + 1
    
    max_freq = max(freq.values())
    modas = [k for k, v in freq.items() if v == max_freq]
    return modas[0] if len(modas) == 1 else modas

# Testando funções manuais
print("=== Funções Implementadas Manualmente ===")
print(f"Média: {calcular_media(numeros)}")
print(f"Mediana: {calcular_mediana(numeros)}")
print(f"Moda dos dados [1,2,2,3,3,3,4,4,5]: {calcular_moda(dados_com_repeticao)}")

# Usando bibliotecas built-in
print("\n=== Usando Bibliotecas ===")
# NumPy
media_np = np.mean(numeros)
mediana_np = np.median(numeros)

# Statistics module (Python 3.4+)
from statistics import mean, median
media_stats = mean(numeros)
mediana_stats = median(numeros)

# Para moda, temos várias opções:
moda_stats = mode(dados_com_repeticao)  # Retorna uma moda
todas_modas = multimode(dados_com_repeticao)  # Retorna todas as modas

print(f"Média (NumPy): {media_np}")
print(f"Média (statistics): {media_stats}")
print(f"Mediana (NumPy): {mediana_np}")
print(f"Mediana (statistics): {mediana_stats}")
print(f"Moda (statistics): {moda_stats}")
print(f"Todas as modas: {todas_modas}")

# Usando pandas para análise mais completa
df = pd.DataFrame({'valores': dados_com_repeticao})
estatisticas = df.describe()
print(f"\nEstatísticas completas (pandas):\n{estatisticas}")

# Operações com arrays NumPy
A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])

soma_matriz = A + B
produto_matriz = A @ B  # ou np.dot(A, B)
determinante = np.linalg.det(A)
inversa = np.linalg.inv(A)

# Estatísticas mais avançadas
dados_grandes = np.random.rand(1000)
quartis = np.percentile(dados_grandes, [25, 50, 75])
print(f"Quartis: {quartis}")

# Usando scipy para mais funções estatísticas
from scipy import stats
moda_scipy = stats.mode(dados_com_repeticao, keepdims=False)
print(f"Moda (scipy): valor={moda_scipy.mode}, frequência={moda_scipy.count}")
```

## 12. Usando Constantes (const)

### Julia
```julia
# Constantes globais - melhor performance e clareza
const PI_PERSONALIZADO = 3.14159
const TAXA_JUROS = 0.05
const NOME_EMPRESA = "TechCorp"

# Constantes podem ser redefinidas, mas Julia emite warning
const VERSAO = "1.0"
# const VERSAO = "1.1"  # Warning: redefining constant

# Usando constantes em cálculos
function calcular_area_circulo(raio)
    return PI_PERSONALIZADO * raio^2
end

function calcular_juros(principal)
    return principal * TAXA_JUROS
end

# Constantes de tipos - muito útil para performance
const Vector3D = Vector{Float64}
const MatrizInt = Matrix{Int64}

# Constante com struct
struct Config
    max_tentativas::Int
    timeout::Float64
end
const APP_CONFIG = Config(3, 30.0)

# Testando
println("Área do círculo (raio=5): $(calcular_area_circulo(5))")
println("Juros sobre R\$ 1000: R\$ $(calcular_juros(1000))")
println("Empresa: $NOME_EMPRESA")
println("Configuração: $(APP_CONFIG.max_tentativas) tentativas")
```

### Python
```julia
# Python não tem const nativo, mas usa convenções

# CONVENÇÃO: MAIÚSCULAS para constantes (não são realmente imutáveis)
PI_PERSONALIZADO = 3.14159
TAXA_JUROS = 0.05
NOME_EMPRESA = "TechCorp"

# Com typing (Python 3.8+) - apenas hint, não impede mudanças
from typing import Final

VERSAO: Final = "1.0"
MAX_USUARIOS: Final[int] = 1000

# Usando constantes em funções
def calcular_area_circulo(raio):
    return PI_PERSONALIZADO * raio**2

def calcular_juros(principal):
    return principal * TAXA_JUROS

# Classe para agrupar constantes relacionadas
class Config:
    MAX_TENTATIVAS = 3
    TIMEOUT = 30.0
    DEBUG = True

# Usando dataclass para constantes mais complexas (Python 3.7+)
from dataclasses import dataclass

@dataclass(frozen=True)  # frozen=True torna imutável
class AppConfig:
    max_tentativas: int = 3
    timeout: float = 30.0
    nome_app: str = "MeuApp"

APP_CONFIG = AppConfig()

# Usando enum para constantes relacionadas (recomendado)
from enum import Enum

class StatusPedido(Enum):
    PENDENTE = "pendente"
    PROCESSANDO = "processando"
    CONCLUIDO = "concluido"
    CANCELADO = "cancelado"

class Cores(Enum):
    VERMELHO = "#FF0000"
    VERDE = "#00FF00"
    AZUL = "#0000FF"

# Testando
print(f"Área do círculo (raio=5): {calcular_area_circulo(5)}")
print(f"Juros sobre R$ 1000: R$ {calcular_juros(1000)}")
print(f"Empresa: {NOME_EMPRESA}")
print(f"Status: {StatusPedido.PENDENTE.value}")
print(f"Cor: {Cores.VERMELHO.value}")

# Demonstrando que não é realmente constante em Python
print(f"Versão antes: {VERSAO}")
# VERSAO = "1.1"  # Funciona, mas não é recomendado
# print(f"Versão depois: {VERSAO}")
```

### Quando Usar Constantes

**Em Julia:**
- **Performance**: `const` melhora performance para variáveis globais
- **Tipos**: `const MeuTipo = Vector{Float64}` para aliases de tipos
- **Configurações**: Valores que não mudam durante execução
- **Constantes matemáticas**: Valores fixos usados em cálculos

**Em Python:**
- **Convenção**: Use MAIÚSCULAS para indicar que não deve ser alterado
- **Configurações**: Parâmetros da aplicação
- **Enums**: Para conjuntos de constantes relacionadas
- **Final**: Type hint para indicar imutabilidade (Python 3.8+)
- **frozen dataclass**: Para objetos de configuração imutáveis

**Exemplos Práticos:**

```julia
# Julia - Configuração de aplicação
const MAX_CONEXOES = 100
const TIMEOUT_DEFAULT = 30.0
const SUPPORTED_FORMATS = ["json", "xml", "csv"]

function processar_arquivo(formato)
    if formato in SUPPORTED_FORMATS
        return "Processando arquivo $formato"
    else
        return "Formato não suportado"
    end
end
```

```python
# Python - Configuração equivalente
MAX_CONEXOES = 100
TIMEOUT_DEFAULT = 30.0
SUPPORTED_FORMATS = ["json", "xml", "csv"]

def processar_arquivo(formato):
    if formato in SUPPORTED_FORMATS:
        return f"Processando arquivo {formato}"
    else:
        return "Formato não suportado"

# Versão com Enum (mais robusta)
from enum import Enum

class FormatosSuportados(Enum):
    JSON = "json"
    XML = "xml"
    CSV = "csv"

def processar_arquivo_v2(formato):
    try:
        formato_enum = FormatosSuportados(formato)
        return f"Processando arquivo {formato_enum.value}"
    except ValueError:
        return "Formato não suportado"
```

### Julia
```julia
# Definir struct
struct Pessoa
    nome::String
    idade::Int
    salario::Float64
end

# Struct mutável
mutable struct ContaBancaria
    titular::String
    saldo::Float64
end

# Função para struct
function depositar!(conta::ContaBancaria, valor::Float64)
    conta.saldo += valor
    return conta.saldo
end

# Usar structs
pessoa = Pessoa("Maria", 28, 5500.0)
conta = ContaBancaria("João", 1000.0)
novo_saldo = depositar!(conta, 500.0)
```

### Python
```python
# Definir classe
class Pessoa:
    def __init__(self, nome, idade, salario):
        self.nome = nome
        self.idade = idade
        self.salario = salario
    
    def __str__(self):
        return f"Pessoa(nome={self.nome}, idade={self.idade})"

class ContaBancaria:
    def __init__(self, titular, saldo=0.0):
        self.titular = titular
        self.saldo = saldo
    
    def depositar(self, valor):
        self.saldo += valor
        return self.saldo
    
    def sacar(self, valor):
        if valor <= self.saldo:
            self.saldo -= valor
            return self.saldo
        else:
            return "Saldo insuficiente"

# Usar classes
pessoa = Pessoa("Maria", 28, 5500.0)
conta = ContaBancaria("João", 1000.0)
novo_saldo = conta.depositar(500.0)
```

## 10. Manipulação Avançada de Dados e Análise Estatística

### Julia
```julia
using DataFrames, CSV, Statistics, StatsBase, Dates

# Criando dataset mais realista para análise
Random.seed!(42)
n = 1000

df = DataFrame(
    id = 1:n,
    nome = ["Cliente_$i" for i in 1:n],
    idade = rand(18:80, n),
    salario = rand(2000:20000, n),
    departamento = rand(["TI", "RH", "Vendas", "Marketing", "Financeiro"], n),
    data_contratacao = Date(2020, 1, 1) .+ Day.(rand(0:1095, n)),
    vendas_trimestre = rand(0:100000, n),
    ativo = rand([true, false], n, ProbabilityWeights([0.8, 0.2]))
)

# 1. LIMPEZA E PREPARAÇÃO DE DADOS
# Identificar valores outliers (método IQR)
function identificar_outliers(dados)
    q1, q3 = quantile(dados, [0.25, 0.75])
    iqr = q3 - q1
    limite_inf = q1 - 1.5 * iqr
    limite_sup = q3 + 1.5 * iqr
    return (dados .< limite_inf) .| (dados .> limite_sup)
end

outliers_salario = identificar_outliers(df.salario)
println("Número de outliers em salário: $(sum(outliers_salario))")

# Remover outliers
df_limpo = df[.!outliers_salario, :]

# 2. AGREGAÇÕES E GRUPOS
# Estatísticas por departamento
stats_dept = combine(groupby(df_limpo, :departamento), 
    :salario => mean => :salario_medio,
    :salario => median => :salario_mediano,
    :salario => std => :desvio_salario,
    :idade => mean => :idade_media,
    :vendas_trimestre => sum => :vendas_total,
    nrow => :num_funcionarios
)
println("Estatísticas por departamento:")
println(stats_dept)

# 3. ANÁLISE TEMPORAL
# Extrair ano/mês da data de contratação
df_limpo.ano_contratacao = year.(df_limpo.data_contratacao)
df_limpo.mes_contratacao = month.(df_limpo.data_contratacao)

# Contratações por ano
contratacoes_ano = combine(groupby(df_limpo, :ano_contratacao), nrow => :contratacoes)
println("Contratações por ano:")
println(contratacoes_ano)

# 4. CORRELAÇÃO E ANÁLISE ESTATÍSTICA
# Matriz de correlação
using LinearAlgebra
dados_numericos = select(df_limpo, [:idade, :salario, :vendas_trimestre, :ano_contratacao])
matriz_corr = cor(Matrix(dados_numericos))
println("Matriz de correlação:")
println(matriz_corr)

# 5. CATEGORIZAÇÃO E BINNING
# Criar faixas etárias
function categorizar_idade(idade)
    if idade < 25
        return "Jovem"
    elseif idade < 40
        return "Adulto"
    elseif idade < 55
        return "Experiente"
    else
        return "Senior"
    end
end

df_limpo.faixa_etaria = categorizar_idade.(df_limpo.idade)

# Análise cruzada: faixa etária vs departamento
tabela_cruzada = combine(groupby(df_limpo, [:faixa_etaria, :departamento]), nrow => :count)
println("Distribuição por faixa etária e departamento:")
println(tabela_cruzada)

# 6. RANKING E PERCENTIS
# Top 10 maiores salários
top_salarios = sort(df_limpo, :salario, rev=true)[1:10, [:nome, :salario, :departamento]]
println("Top 10 salários:")
println(top_salarios)

# Percentis de vendas
percentis_vendas = quantile(df_limpo.vendas_trimestre, [0.1, 0.25, 0.5, 0.75, 0.9])
println("Percentis de vendas: $percentis_vendas")

# 7. PIVÔ E RESHAPE
# Vendas médias por departamento e faixa etária (pivot)
pivot_vendas = unstack(
    combine(groupby(df_limpo, [:departamento, :faixa_etaria]), 
            :vendas_trimestre => mean => :vendas_media),
    :faixa_etaria, :vendas_media
)
println("Pivot - Vendas médias:")
println(pivot_vendas)

# 8. ANÁLISE DE MISSING VALUES
# Simular alguns valores missing
df_com_missing = copy(df_limpo)
missing_indices = sample(1:nrow(df_com_missing), 50, replace=false)
df_com_missing.salario[missing_indices] .= missing

# Contar missings
missing_count = sum(ismissing.(df_com_missing.salario))
println("Valores missing em salário: $missing_count")

# Imputar com mediana
mediana_salario = median(skipmissing(df_com_missing.salario))
df_com_missing.salario = coalesce.(df_com_missing.salario, mediana_salario)
```

### Python
```python
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import seaborn as sns
from scipy import stats
from sklearn.preprocessing import StandardScaler

# Criando dataset mais realista para análise
np.random.seed(42)
n = 1000

df = pd.DataFrame({
    'id': range(1, n+1),
    'nome': [f'Cliente_{i}' for i in range(1, n+1)],
    'idade': np.random.randint(18, 81, n),
    'salario': np.random.randint(2000, 20001, n),
    'departamento': np.random.choice(['TI', 'RH', 'Vendas', 'Marketing', 'Financeiro'], n),
    'data_contratacao': pd.date_range('2020-01-01', periods=n, freq='D')[:n],
    'vendas_trimestre': np.random.randint(0, 100001, n),
    'ativo': np.random.choice([True, False], n, p=[0.8, 0.2])
})

# 1. LIMPEZA E PREPARAÇÃO DE DADOS
# Identificar valores outliers (método IQR)
def identificar_outliers_iqr(dados):
    Q1 = dados.quantile(0.25)
    Q3 = dados.quantile(0.75)
    IQR = Q3 - Q1
    limite_inf = Q1 - 1.5 * IQR
    limite_sup = Q3 + 1.5 * IQR
    return (dados < limite_inf) | (dados > limite_sup)

# Identificar outliers usando Z-score
def identificar_outliers_zscore(dados, threshold=3):
    z_scores = np.abs(stats.zscore(dados))
    return z_scores > threshold

outliers_salario = identificar_outliers_iqr(df['salario'])
print(f"Número de outliers em salário (IQR): {outliers_salario.sum()}")

# Remover outliers
df_limpo = df[~outliers_salario].copy()

# 2. AGREGAÇÕES E GRUPOS
# Estatísticas por departamento
stats_dept = df_limpo.groupby('departamento').agg({
    'salario': ['mean', 'median', 'std', 'min', 'max'],
    'idade': 'mean',
    'vendas_trimestre': ['sum', 'mean'],
    'id': 'count'
}).round(2)

# Flatten column names
stats_dept.columns = ['_'.join(col).strip() for col in stats_dept.columns]
stats_dept = stats_dept.rename(columns={'id_count': 'num_funcionarios'})
print("Estatísticas por departamento:")
print(stats_dept)

# 3. ANÁLISE TEMPORAL
# Extrair componentes de data
df_limpo['ano_contratacao'] = df_limpo['data_contratacao'].dt.year
df_limpo['mes_contratacao'] = df_limpo['data_contratacao'].dt.month
df_limpo['trimestre'] = df_limpo['data_contratacao'].dt.quarter

# Contratações por ano
contratacoes_ano = df_limpo.groupby('ano_contratacao').size().reset_index(name='contratacoes')
print("Contratações por ano:")
print(contratacoes_ano)

# 4. CORRELAÇÃO E ANÁLISE ESTATÍSTICA
# Matriz de correlação
colunas_numericas = ['idade', 'salario', 'vendas_trimestre', 'ano_contratacao']
matriz_corr = df_limpo[colunas_numericas].corr()
print("Matriz de correlação:")
print(matriz_corr)

# Teste de correlação estatística
corr_idade_salario, p_value = stats.pearsonr(df_limpo['idade'], df_limpo['salario'])
print(f"Correlação idade-salário: {corr_idade_salario:.3f} (p-value: {p_value:.3f})")

# 5. CATEGORIZAÇÃO E BINNING
# Criar faixas etárias
def categorizar_idade(idade):
    if idade < 25:
        return 'Jovem'
    elif idade < 40:
        return 'Adulto'
    elif idade < 55:
        return 'Experiente'
    else:
        return 'Senior'

df_limpo['faixa_etaria'] = df_limpo['idade'].apply(categorizar_idade)

# Binning com pandas cut
df_limpo['faixa_salario'] = pd.cut(df_limpo['salario'], 
                                   bins=5, 
                                   labels=['Muito Baixo', 'Baixo', 'Médio', 'Alto', 'Muito Alto'])

# Análise cruzada: faixa etária vs departamento
tabela_cruzada = pd.crosstab(df_limpo['faixa_etaria'], df_limpo['departamento'])
print("Tabela cruzada - Faixa etária vs Departamento:")
print(tabela_cruzada)

# 6. RANKING E PERCENTIS
# Top 10 maiores salários
top_salarios = df_limpo.nlargest(10, 'salario')[['nome', 'salario', 'departamento']]
print("Top 10 salários:")
print(top_salarios)

# Percentis de vendas
percentis_vendas = df_limpo['vendas_trimestre'].quantile([0.1, 0.25, 0.5, 0.75, 0.9])
print("Percentis de vendas:")
print(percentis_vendas)

# Criar ranking por departamento
df_limpo['rank_salario_dept'] = df_limpo.groupby('departamento')['salario'].rank(method='dense', ascending=False)

# 7. PIVÔ E RESHAPE
# Vendas médias por departamento e faixa etária (pivot)
pivot_vendas = df_limpo.pivot_table(
    values='vendas_trimestre',
    index='departamento',
    columns='faixa_etaria',
    aggfunc='mean'
).round(0)
print("Pivot - Vendas médias por departamento e faixa etária:")
print(pivot_vendas)

# 8. ANÁLISE DE MISSING VALUES
# Simular alguns valores missing
df_com_missing = df_limpo.copy()
missing_indices = np.random.choice(df_com_missing.index, 50, replace=False)
df_com_missing.loc[missing_indices, 'salario'] = np.nan

# Analisar missings
missing_info = df_com_missing.isnull().sum()
print("Valores missing por coluna:")
print(missing_info[missing_info > 0])

# Diferentes estratégias de imputação
# Imputar com mediana
df_com_missing['salario_imputado_mediana'] = df_com_missing['salario'].fillna(
    df_com_missing['salario'].median()
)

# Imputar por grupo (departamento)
df_com_missing['salario_imputado_grupo'] = df_com_missing.groupby('departamento')['salario'].transform(
    lambda x: x.fillna(x.median())
)

# 9. DETECÇÃO DE ANOMALIAS
# Usando Z-score
z_scores = np.abs(stats.zscore(df_limpo['salario']))
anomalias_zscore = df_limpo[z_scores > 2.5]
print(f"Anomalias detectadas (Z-score > 2.5): {len(anomalias_zscore)}")

# 10. ANÁLISE DE PERFORMANCE
# KPIs por departamento
kpis = df_limpo.groupby('departamento').apply(lambda x: pd.Series({
    'total_funcionarios': len(x),
    'salario_medio': x['salario'].mean(),
    'vendas_totais': x['vendas_trimestre'].sum(),
    'vendas_per_capita': x['vendas_trimestre'].sum() / len(x),
    'idade_media': x['idade'].mean(),
    'taxa_ativo': x['ativo'].mean() * 100
})).round(2)

print("KPIs por departamento:")
print(kpis)

# 11. WINDOW FUNCTIONS (análise sequencial)
# Ranking móvel e diferenças
df_sorted = df_limpo.sort_values(['departamento', 'salario'], ascending=[True, False])
df_sorted['rank_departamento'] = df_sorted.groupby('departamento')['salario'].rank(method='dense', ascending=False)
df_sorted['diff_salario_anterior'] = df_sorted.groupby('departamento')['salario'].diff()

# Moving averages
df_sorted['media_movel_3'] = df_sorted.groupby('departamento')['salario'].rolling(window=3).mean().reset_index(0, drop=True)

print("Análise com window functions (primeiras 10 linhas):")
print(df_sorted[['nome', 'departamento', 'salario', 'rank_departamento', 'diff_salario_anterior']].head(10))
```

1. **Demonstre clareza**: Comente seu código quando apropriado
2. **Trate erros**: Mostre que considera casos extremos
3. **Seja eficiente**: Conheça as complexidades temporais básicas
4. **Teste mentalmente**: Pense em casos de teste para suas funções
5. **Explique seu raciocínio**: Verbalize seu processo de pensamento

Estes exemplos cobrem os fundamentos essenciais que demonstram competência básica em ambas as linguagens!