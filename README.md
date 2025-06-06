# Meu Projeto

Este repositório segue uma estrutura de diretórios recomendada para projetos de ciência de dados e estatística, suportando scripts e notebooks em Python, Julia e R.

## Estrutura de Diretórios

```text
data/
├── raw/           # Dados originais, sem alterações
├── processed/     # Dados limpos e transformados
└── external/      # Dados de fontes externas (ex: IBGE, INMET)

notebooks/         # Notebooks exploratórios (Jupyter, Pluto.jl, Rmd, etc.)

scripts/
├── preprocess/    # Scripts de pré-processamento
├── analysis/      # Scripts de análise estatística
│   ├── regression/       # REG: Regressão
│   ├── classification/   # CLF: Classificação
│   ├── clustering/       # CLT: Agrupamento
│   ├── timeseries/       # TS: Séries temporais
│   ├── sampling/         # SMP: Amostragem
│   └── bayesian/         # BAY: Modelos Bayesianos
└── visualization/ # Scripts para gráficos e relatórios

models/            # Modelos estatísticos salvos ou treinados

reports/
├── figures/       # Figuras e gráficos usados nos relatórios
├── pdf/           # Relatórios finais em PDF, HTML, etc.
└── latex/         # Arquivos-fonte editáveis dos relatórios (ex: .tex, .Rmd, .ipynb)

results/           # Resultados de simulações, outputs de modelos, etc.

references/        # Artigos, livros e documentos de apoio

environment/       # Arquivos de ambiente (requirements.txt, Project.toml, DESCRIPTION, etc.)

README.md          # Descrição do projeto
.gitignore         # Arquivos a serem ignorados pelo Git
LICENSE            # Licença do projeto (se aplicável)
```

**Exemplo de scripts em `scripts/analysis/`:**
- `scripts/analysis/regression/regressao-linear.py`
- `scripts/analysis/classification/classificador-arvore.jl`
- `scripts/analysis/clustering/kmeans.R`
- `scripts/analysis/timeseries/arima.py`
- `scripts/analysis/sampling/bootstrapping.py`
- `scripts/analysis/bayesian/modelo-bayesiano.jl`

## Regras e Convenções

- Utilize **kebab-case** (letras minúsculas e hífens) para nomear pastas e arquivos, exceto arquivos de configuração padrão (ex: `README.md`, `.gitignore`).
- Scripts devem ser nomeados de forma descritiva, também em kebab-case, por exemplo: `limpeza-dados.py`, `analise-exploratoria.jl`, `visualizacao-resultados.R`.
- Não armazene dados sensíveis ou confidenciais no repositório.
- Documente dependências e instruções de uso na pasta `environment/` e neste `README.md`.
- Mantenha o repositório organizado, removendo arquivos temporários e desnecessários.

## Como usar

1. Organize seus dados na pasta `data/`.
2. Utilize os notebooks para exploração e análise inicial.
3. Salve scripts reutilizáveis em `scripts/`.
4. Armazene modelos treinados em `models/`.
5. Gere relatórios e salve-os em `reports/`.
6. Documente dependências em `environment/`.

Sinta-se à vontade para adaptar a estrutura conforme as necessidades do seu projeto!

## Como iniciar um novo projeto a partir deste modelo

Para garantir que todos os colaboradores sigam a mesma estrutura, utilize este repositório como template:

### 1. Clonando o template do GitHub

```bash
git clone https://github.com/empresa/nome-do-template.git novo-projeto
cd novo-projeto
git remote remove origin
```
> Substitua `https://github.com/empresa/nome-do-template.git` pela URL do repositório da sua empresa.

### 2. Usando como template no GitHub

No GitHub, clique em **"Use this template"** para criar um novo repositório já com esta estrutura.

### 3. (Opcional) Utilizando Docker para padronizar o ambiente

Se o projeto possuir um `Dockerfile` e/ou `docker-compose.yml`, basta rodar:

```bash
docker compose up
```
ou

```bash
docker build -t meu-projeto .
docker run -it meu-projeto
```

Assim, todos os colaboradores terão o mesmo ambiente de desenvolvimento, facilitando a reprodução dos resultados.

### 4. Checklist inicial após criar o novo projeto

- Renomeie o projeto e atualize o campo `nome` no README.
- Atualize as informações de contato e licença, se necessário.
- Configure variáveis de ambiente na pasta `environment/`.
- Instale as dependências:
    - Python: `pip install -r environment/requirements.txt`
    - Julia: `julia --project=environment -e 'using Pkg; Pkg.instantiate()'`
    - R: `Rscript -e 'install.packages(readLines("environment/DESCRIPTION"))'`

### 5. Convenções de colaboração

- Use mensagens de commit claras e descritivas.
- Crie branches para novas features ou correções, seguindo o padrão: `feature/nome-da-feature` ou `fix/nome-da-correção`.
- Sempre abra um Pull Request para revisão antes de mesclar no branch principal.
- Em caso de dúvidas, entre em contato pelo canal interno da equipe ou e-mail do responsável pelo repositório.

### Sobre a pasta `reports/`

A pasta `reports/` deve ser utilizada para armazenar todos os relatórios gerados durante o projeto, tanto intermediários quanto finais. Recomenda-se que, além dos arquivos finais em PDF ou HTML (armazenados em `reports/pdf/`), o projeto também contenha os arquivos-fonte dos relatórios, como arquivos LaTeX (`.tex`), RMarkdown (`.Rmd`), Jupyter Notebook (`.ipynb`) ou outros formatos editáveis.

Dessa forma, qualquer colaborador pode editar, atualizar ou gerar novamente os relatórios conforme necessário, garantindo transparência e reprodutibilidade. Por exemplo, ao gerar um relatório em PDF via LaTeX, inclua o arquivo `.tex` correspondente e todos os recursos necessários (imagens, tabelas, bibliografia) na mesma pasta ou em subpastas organizadas.

**Exemplo de organização:**
```
reports/
├── figures/
│   └── grafico-exemplo.png
├── pdf/
│   └── relatorio-final.pdf
└── latex/
    ├── relatorio-final.tex
    ├── referencias.bib
    └── imagens/
        └── grafico-exemplo.png
```

> **Dica:** Sempre que possível, mantenha os arquivos editáveis dos relatórios junto com os PDFs finais para facilitar futuras atualizações e revisões.

---

Siga sempre este modelo para novos projetos, garantindo padronização e organização em toda a equipe.
