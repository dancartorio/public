### A Pluto.jl notebook ###
# v0.20.10

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ b1dddc57-5c1d-474f-bde7-27b3eac5ccdf
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Handcalcs", "PlutoUI", "LinearAlgebra", "Latexify", "LaTeXStrings"])
    using Handcalcs, PlutoUI, LinearAlgebra, Latexify, LaTeXStrings
    using Markdown
    using InteractiveUtils
end

# ╔═╡ 3bdf5365-9917-459a-a6b6-d6b38d47a47e
### A Pluto.jl notebook ###
# v0.20.4





# cell-titulo
md"""
# 📐 Normalização Vetorial — Cálculo do DOI

**Transformação:** $\quad\mathbf{d} = \dfrac{100}{\mathbf{1}^T\mathbf{r}}\,\mathbf{r}$
"""

# cell-sliders

# ╔═╡ c16b1b16-ee21-49bf-9038-0e22a378ffc5
@bind vals PlutoUI.combine() do Child
    md"""
    ## 1. Entradas — Vetor dos Reais $\mathbf{r}$

    | Componente | Valor Real (%) |
    |:----------:|:--------------:|
    | A | $(Child(:A, Slider(0:0.5:100, default=10, show_value=true))) |
    | B | $(Child(:B, Slider(0:0.5:100, default=10, show_value=true))) |
    | C | $(Child(:C, Slider(0:0.5:100, default=5,  show_value=true))) |
    | D | $(Child(:D, Slider(0:0.5:100, default=2,  show_value=true))) |
    """
end

# cell-secao2

# ╔═╡ ceda314c-7c05-4f04-840e-a7b545db882e
md"## 2. Vetor dos Reais $\mathbf{r}$"

# cell-vetor-r-display

# ╔═╡ bc1cb18a-5572-47f8-8429-0c9a8b921720
let
    A, B, C, D = vals.A, vals.B, vals.C, vals.D
    r = [A, B, C, D]
    rows = join(string.(r), " \\\\ ")
    lstr = latexstring(raw"\mathbf{r} = \begin{bmatrix}", rows, raw"\end{bmatrix}")
    Markdown.parse("``" * lstr.s * "``")
end

# ╔═╡ 39ba7ab2-3c9c-47e3-82a4-03bb4f2bd61d
md"""
## 3. Soma Total — $\mathbf{1}^T\mathbf{r}$

O vetor linha de uns:
"""

# cell-soma-display

# ╔═╡ 13d42f80-4f5a-43fd-9db9-6277a49c9c31
let
    A, B, C, D = vals.A, vals.B, vals.C, vals.D
    r     = [A, B, C, D]
    total = sum(r)

    r_tex  = "\\begin{bmatrix}" * join(r, " \\\\ ") * "\\end{bmatrix}"
    oT_tex = "\\begin{bmatrix}" * join(ones(Int,4), " & ") * "\\end{bmatrix}"

    lstr = latexstring(
        raw"\mathbf{1}^T\mathbf{r} = ",
        oT_tex, r_tex,
        " = ", round(total, digits=4)
    )
    Markdown.parse("``" * lstr.s * "``")
end

# ╔═╡ a1ce00c6-ebf9-43c7-91f4-7df2287c4cbc
@handcalcs begin
    A = vals.A; B = vals.B; C = vals.C; D = vals.D
    total_real = A + B + C + D
end

# cell-secao4

# ╔═╡ 6ec8bfcd-20d7-4cc2-ac7e-5d1ff7b6be45
md"""
## 4. Escalar de Normalização $\alpha$
"""

# cell-handcalcs-alpha

# ╔═╡ 42a25fee-df1b-49b0-bfb2-6497cace1a65
@handcalcs begin
    α = 100 / total_real
end precision=6

# cell-secao5

# ╔═╡ d8e0b88f-0935-408c-87ad-a44cdc759d37
md"""
## 5. Matriz de Transformação $T = \alpha \cdot I$

$$T = \frac{100}{\mathbf{1}^T\mathbf{r}}\,I$$
"""

# cell-T-display

# ╔═╡ c863685f-080b-45ec-aa62-bf7fb9abffaa
let
    A, B, C, D = vals.A, vals.B, vals.C, vals.D
    r     = [A, B, C, D]
    total = sum(r)
    α     = round(100 / total, digits=4)
    T_mat = α * Matrix(I(4))

    rows_tex = join(
        [join(round.(row, digits=4), " & ") for row in eachrow(T_mat)],
        " \\\\ "
    )
    T_tex = "\\begin{bmatrix}" * rows_tex * "\\end{bmatrix}"

    lstr = latexstring(raw"T = \alpha\,I = ", T_tex)
    Markdown.parse("``" * lstr.s * "``")
end

# ╔═╡ 357296db-c8f6-47e7-9ea3-71d5c4756334
md"""
## 6. Vetor DOI — $\mathbf{d} = \alpha\,\mathbf{r}$

$$\mathbf{d} = \frac{100}{\mathbf{1}^T\mathbf{r}}\,\mathbf{r}$$
"""

# cell-doi-display

# ╔═╡ 4f34821a-c744-4fd4-9cb2-17aca72405df
let
    A, B, C, D = vals.A, vals.B, vals.C, vals.D
    r     = [A, B, C, D]
    total = sum(r)
    α     = 100 / total
    d     = α .* r

    bmat(v) = "\\begin{bmatrix}" * join(round.(v, digits=4), " \\\\ ") * "\\end{bmatrix}"

    lstr = latexstring(
        raw"\mathbf{d} = \frac{100}{", round(total, digits=4), raw"}\,",
        bmat(r),
        " = ",
        bmat(d)
    )
    Markdown.parse("``" * lstr.s * "``")
end

# ╔═╡ 6402fa8e-4ef5-4c2f-b486-dcd3f8d09d42
@handcalcs begin
    d_A = α * A
    d_B = α * B
    d_C = α * C
    d_D = α * D
end precision=4

# cell-secao7

# ╔═╡ 618118ff-b9d6-4832-90d9-e9fe7af29820
md"""
## 7. Verificação — $\mathbf{1}^T\mathbf{d} = 100$
"""

# cell-check-display

# ╔═╡ af894e60-ce40-41ae-895b-29c0d935a4b5
let
    A, B, C, D = vals.A, vals.B, vals.C, vals.D
    r     = [A, B, C, D]
    total = sum(r)
    α     = 100 / total
    d     = α .* r
    soma  = sum(d)

    bmat_col(v) = "\\begin{bmatrix}" * join(round.(v, digits=4), " \\\\ ") * "\\end{bmatrix}"
    bmat_row(v) = "\\begin{bmatrix}" * join(v, " & ") * "\\end{bmatrix}"

    lstr = latexstring(
        raw"\mathbf{1}^T\mathbf{d} = ",
        bmat_row(ones(Int, 4)), bmat_col(d),
        " = ", round(soma, digits=4)
    )
    Markdown.parse("``" * lstr.s * "``")
end

# ╔═╡ ed857a21-cb39-4ad3-b719-55ac4081b9a7
@handcalcs begin
    soma_DOI = d_A + d_B + d_C + d_D
end precision=4

# cell-resultado

# ╔═╡ 1f63e14f-b754-4370-ae7c-3751c6fce876
let
    A, B, C, D = vals.A, vals.B, vals.C, vals.D
    r     = [A; B; C; D]
    total = sum(r)
    α     = 100 / total
    d     = α .* r

    ok = isapprox(sum(d), 100.0; atol=1e-8)
    if ok
        md"""
        !!! success "✅ Normalização verificada — soma DOI = 100,00%"

            | Comp. | Real (%) | DOI (%) |
            |:-----:|:--------:|:-------:|
            | A | $(round(A, digits=2)) | $(round(d[1], digits=4)) |
            | B | $(round(B, digits=2)) | $(round(d[2], digits=4)) |
            | C | $(round(C, digits=2)) | $(round(d[3], digits=4)) |
            | D | $(round(D, digits=2)) | $(round(d[4], digits=4)) |
            | **Total** | **$(round(total, digits=2))** | **$(round(sum(d), digits=4))** |
        """
    else
        md"""!!! danger "❌ Erro: soma = $(round(sum(d), digits=6))" """
    end
end

# cell-nota

# ╔═╡ a426af80-c432-416e-a5ed-e54ed7c2c667
md"""
---
### 📝 Forma compacta final

$$\boxed{\mathbf{d} = \frac{100}{\mathbf{1}^T\mathbf{r}}\,\mathbf{r}}$$

- Total fixo → transformação **linear**
- Total variável (depende de $\mathbf{r}$) → **normalização** (não-linear no sentido estrito)
"""

# ╔═╡ Cell order:
# ╠═b1dddc57-5c1d-474f-bde7-27b3eac5ccdf
# ╟─3bdf5365-9917-459a-a6b6-d6b38d47a47e
# ╟─c16b1b16-ee21-49bf-9038-0e22a378ffc5
# ╟─ceda314c-7c05-4f04-840e-a7b545db882e
# ╟─bc1cb18a-5572-47f8-8429-0c9a8b921720
# ╟─39ba7ab2-3c9c-47e3-82a4-03bb4f2bd61d
# ╟─13d42f80-4f5a-43fd-9db9-6277a49c9c31
# ╟─a1ce00c6-ebf9-43c7-91f4-7df2287c4cbc
# ╟─6ec8bfcd-20d7-4cc2-ac7e-5d1ff7b6be45
# ╟─42a25fee-df1b-49b0-bfb2-6497cace1a65
# ╟─d8e0b88f-0935-408c-87ad-a44cdc759d37
# ╟─c863685f-080b-45ec-aa62-bf7fb9abffaa
# ╟─357296db-c8f6-47e7-9ea3-71d5c4756334
# ╟─4f34821a-c744-4fd4-9cb2-17aca72405df
# ╟─6402fa8e-4ef5-4c2f-b486-dcd3f8d09d42
# ╟─618118ff-b9d6-4832-90d9-e9fe7af29820
# ╟─af894e60-ce40-41ae-895b-29c0d935a4b5
# ╟─ed857a21-cb39-4ad3-b719-55ac4081b9a7
# ╟─1f63e14f-b754-4370-ae7c-3751c6fce876
# ╟─a426af80-c432-416e-a5ed-e54ed7c2c667
