# Meu Projeto

<!-- Badges -->
![GitHub last commit](https://img.shields.io/github/last-commit/SEU_USUARIO/SEU_REPOSITORIO?label=último%20commit)
![GitHub issues](https://img.shields.io/github/issues/SEU_USUARIO/SEU_REPOSITORIO?label=issues)
![GitHub pull requests](https://img.shields.io/github/issues-pr/SEU_USUARIO/SEU_REPOSITORIO?label=pull%20requests)
![GitHub](https://img.shields.io/github/license/SEU_USUARIO/SEU_REPOSITORIO?label=licença)
![Python](https://img.shields.io/badge/Python-3.10%2B-blue?logo=python)
![R](https://img.shields.io/badge/R-4.0%2B-blue?logo=r)
![Julia](https://img.shields.io/badge/Julia-1.10%2B-purple?logo=julia)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-orange?logo=jupyter)
![Docker](https://img.shields.io/badge/Docker-ready-blue?logo=docker)
![Data Science](https://img.shields.io/badge/Data%20Science-ready-brightgreen)
![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)

> Substitua `[SEU_USUARIO/SEU_REPOSITORIO](https://github.com/dancartorio/public)` pela URL do seu repositório no GitHub para os badges funcionarem corretamente.

---

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

---

# 📊 MODELO EDITÁVEL PARA NOVOS PROJETOS (EDITABLE TEMPLATE FOR NEW PROJECTS)

> **Atenção / Attention:** Ao iniciar um novo projeto, apague este bloco de instruções e preencha com as informações do seu projeto.  
> (When starting a new project, delete this instruction block and fill in your project information.)

## Nome do Projeto (Project Name)

_Descreva aqui o nome do projeto._  
_(Describe the project name here.)_

## Descrição (Description)

_Explique brevemente o objetivo do projeto, contexto, área de aplicação e principais entregáveis._  
_(Briefly explain the project objective, context, application area, and main deliverables.)_

## Equipe (Team)

- **Responsável / Lead:** _Nome do responsável (Lead name)_
- **Colaboradores / Collaborators:** _Lista de membros (List of members)_

## Contato (Contact)

- _E-mail, canal interno, etc. (Email, internal channel, etc.)_

## Estrutura de Diretórios (Directory Structure)

```text
data/
├── raw/
├── processed/
└── external/

notebooks/

scripts/
├── preprocess/
├── analysis/
│   ├── regression/
│   ├── classification/
│   ├── clustering/
│   ├── timeseries/
│   ├── sampling/
│   └── bayesian/
└── visualization/

models/

reports/
├── figures/
├── pdf/
└── latex/

results/

references/

environment/

README.md
.gitignore
LICENSE
```

## Como usar (How to use)

1. _Explique como iniciar o projeto, rodar scripts, notebooks, etc._  
   _(Explain how to start the project, run scripts, notebooks, etc.)_
2. _Inclua instruções para instalação de dependências, se necessário._  
   _(Include instructions for installing dependencies, if needed.)_
3. _Descreva como gerar relatórios ou outputs principais._  
   _(Describe how to generate reports or main outputs.)_

## Dependências (Dependencies)

- Python: _Versão e principais pacotes (Version and main packages)_
- Julia: _Versão e principais pacotes (Version and main packages)_
- R: _Versão e principais pacotes (Version and main packages)_
- Outros: _Docker, LaTeX, etc. (Others: Docker, LaTeX, etc.)_

## Relatórios (Reports)

_Descreva onde encontrar os relatórios finais e intermediários, e onde editar os arquivos-fonte (LaTeX, Rmd, etc.)._  
_(Describe where to find final and intermediate reports, and where to edit source files.)_

## Comandos úteis (Useful commands)

### Subindo suas alterações locais para o GitHub

1. **Adicione os arquivos alterados ao controle de versão:**
   ```bash
   git add .
   ```
2. **Faça um commit com uma mensagem descritiva:**
   ```bash
   git commit -m "Descreva brevemente a alteração realizada"
   ```
3. **Envie as alterações para o repositório remoto:**
   ```bash
   git push origin main
   ```
   > Substitua `main` pelo nome do branch, se estiver usando outro.

---

### Sincronizando seu repositório local com o GitHub (baixando atualizações)

1. **Busque e aplique as alterações do repositório remoto:**
   ```bash
   git pull origin main
   ```
   > Isso garante que seu repositório local esteja atualizado com o remoto.

---

### Desfazendo alterações locais e retornando à versão do GitHub

> ⚠️ **Atenção:** Este procedimento irá descartar todas as alterações locais não salvas/commitadas!

1. **Descarte todas as alterações locais e volte para a última versão do GitHub:**
   ```bash
   git fetch origin
   git reset --hard origin/main
   ```
   > Novamente, substitua `main` pelo nome do branch, se necessário.

---

### Comandos úteis para estatísticos e ciência de dados

- **Executar um script Python:**
  ```bash
  python caminho/do/script.py
  ```

- **Executar um script R:**
  ```bash
  Rscript caminho/do/script.R
  ```

- **Executar um script Julia:**
  ```bash
  julia caminho/do/script.jl
  ```

- **Abrir um Jupyter Notebook:**
  ```bash
  jupyter notebook
  ```

- **Converter um notebook Jupyter para PDF (requer LaTeX instalado):**
  ```bash
  jupyter nbconvert --to pdf caminho/do/notebook.ipynb
  ```

- **Instalar dependências Python:**
  ```bash
  pip install -r environment/requirements.txt
  ```

- **Instalar dependências Julia:**
  ```bash
  julia --project=environment -e 'using Pkg; Pkg.instantiate()'
  ```

- **Instalar dependências R:**
  ```bash
  Rscript -e 'install.packages(readLines("environment/DESCRIPTION"))'
  ```

- **Compilar um arquivo LaTeX para PDF:**
  ```bash
  pdflatex caminho/do/arquivo.tex
  ```

- **Buscar arquivos por extensão (exemplo: todos os .csv no projeto):**
  ```bash
  dir /s /b *.csv
  ```

---

### Comandos Git úteis para o dia a dia

- **Ver o status dos arquivos modificados:**
  ```bash
  git status
  ```

- **Ver o histórico de commits:**
  ```bash
  git log --oneline --graph --all
  ```

- **Criar e trocar para um novo branch:**
  ```bash
  git checkout -b nome-do-branch
  ```

- **Mesclar um branch ao branch atual:**
  ```bash
  git merge nome-do-branch
  ```

- **Ver diferenças entre arquivos modificados e o último commit:**
  ```bash
  git diff
  ```

- **Desfazer alterações em um arquivo específico antes do commit:**
  ```bash
  git checkout -- caminho/do/arquivo
  ```

- **Remover um arquivo do controle de versão:**
  ```bash
  git rm caminho/do/arquivo
  ```

- **Reverter um commit já enviado:**
  ```bash
  git revert <hash-do-commit>
  ```

- **Clonar apenas uma pasta específica de um repositório remoto (via sparse-checkout):**
  ```bash
  git clone --filter=blob:none --no-checkout https://github.com/empresa/repositorio.git
  cd repositorio
  git sparse-checkout init --cone
  git sparse-checkout set caminho/da/pasta
  git checkout main
  ```

---

> 💡 **Dica:** Consulte sempre a [documentação oficial do Git](https://git-scm.com/doc) para mais comandos e detalhes avançados.

## Política de Versionamento (Versioning Policy)

Adotamos o [SemVer](https://semver.org/lang/pt-BR/) (Versionamento Semântico) para controle de versões do projeto:

- **MAJOR**: Mudanças incompatíveis na API ou estrutura.
- **MINOR**: Novas funcionalidades, mantendo compatibilidade.
- **PATCH**: Correções de bugs e pequenas melhorias.

Exemplo de versão: `v2.1.3`  
Se preferir, pode-se adotar versionamento por data, como `2025.06.06`.

---

## Padrão para Issues e Pull Requests (Issues and Pull Requests Standard)

- **Issues**
  - Use títulos claros e objetivos.
  - Descreva o problema, contexto, passos para reproduzir e, se possível, inclua prints ou logs.
  - Utilize labels (ex: bug, enhancement, question) para facilitar o acompanhamento.
  - Associe a issue a um responsável e milestone, se aplicável.

- **Pull Requests**
  - Sempre relacione o PR a uma issue (ex: "Closes #12").
  - Descreva resumidamente o que foi feito e o impacto das mudanças.
  - Siga o padrão de branch:  
    - `feature/nome-da-feature` para novas funcionalidades  
    - `fix/nome-da-correção` para correções de bugs  
    - `hotfix/nome-do-hotfix` para correções urgentes
  - Solicite revisão de pelo menos um membro da equipe.
  - Aguarde aprovação antes de fazer merge no branch principal.

---

> 💡 Consulte a documentação interna da empresa para mais detalhes sobre o fluxo de trabalho colaborativo.

## Observações (Notes)

- _Inclua observações importantes, limitações, pontos de atenção, etc._  
  _(Include important notes, limitations, points of attention, etc.)_
- _Adapte este modelo conforme necessário para o seu projeto._  
  _(Adapt this template as needed for your project.)_

## Links Úteis (Useful Links)

- [Morrison Külsenn](https://morrisonkulsenn.com)
- [Documentação Oficial do Git](https://git-scm.com/doc)
- [Documentação do Python](https://docs.python.org/3/)
- [Documentação do R](https://cran.r-project.org/manuals.html)
- [Documentação do Julia](https://docs.julialang.org/)
- [Jupyter Notebooks](https://jupyter.org/)
- [Docker Docs](https://docs.docker.com/)
- [Markdown Guide](https://www.markdownguide.org/basic-syntax/)
- [GitHub Docs](https://docs.github.com/)

## Checklist de Entrega de Projeto (Project Delivery Checklist)

Antes de finalizar e entregar o projeto, verifique se todos os itens abaixo foram cumpridos:

- [x] README.md atualizado e completo (objetivo, equipe, instruções de uso, dependências, etc.)
- [ ] Estrutura de diretórios conforme o padrão do template
- [ ] Todos os scripts e notebooks revisados, comentados e funcionando
- [ ] Dados organizados nas pastas corretas (`data/raw`, `data/processed`, etc.)
- [ ] Modelos treinados salvos em `models/` (se aplicável)
- [ ] Relatórios finais e intermediários disponíveis em `reports/`, com fontes editáveis (LaTeX, Rmd, etc.)
- [ ] Dependências documentadas e arquivos de ambiente atualizados (`requirements.txt`, `Project.toml`, etc.)
- [ ] `.gitignore` configurado para evitar arquivos desnecessários no repositório
- [ ] Licença do projeto definida em `LICENSE`
- [ ] Issues e Pull Requests resolvidos e fechados
- [ ] Versão do projeto definida conforme a política de versionamento
- [ ] Checklist revisado e validado por pelo menos um membro da equipe

> 💡 **Dica:** Adapte este checklist conforme as necessidades específicas do seu projeto.

---

![Logo da Empresa](caminho/para/logo.png)

> **Apague este bloco após preencher com as informações do seu projeto.**  
> (Delete this block after filling in your project information.)
