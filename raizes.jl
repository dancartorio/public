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

# ╔═╡ af638a92-3996-11f1-107b-cb7a9b1c4710
begin
	using PlutoUI
	using Handcalcs
	using Markdown
	using HypertextLiteral
	TableOfContents()
end

# ╔═╡ 088b3770-6187-4602-b8e1-78df059e70ab
md"""
# 📌 Regras de Raiz

Notebook interativo em Pluto.jl para estudar as principais `identidades de radiciação`.

Use os sliders para alterar os valores e observar as regras funcionando numericamente.
"""

# ╔═╡ 802a4695-954a-43a0-a852-991316793740
md"""
## 1. Exemplo clássico

$$c = \sqrt{a^2 + b^2}$$
"""

# ╔═╡ b4b597a3-0b6d-4e8f-81a8-5e65c6199510
md"""
## 2. Produto de radicais

Regra:

$$\sqrt{ab} = \sqrt{a}\,\sqrt{b}$$
"""

# ╔═╡ afce6230-b969-4de7-acd4-cb9cb7db1cd7
begin
	hidecloak(name) = HTML("""
	<style>
	plj-cloak.$(name) {
		opacity: 0;
		display: block;
	}
	</style>
	""")

	"Válida para a ≥ 0 e b ≥ 0."
	atenção(name) = x -> @htl("<plj-cloak class=$(name)>$(x)</plj-cloak>")
end

# ╔═╡ 421b630c-1590-4aa3-aa79-c777bf6526d0
md"""
## 3. Quociente de radicais

Regra:

$$\sqrt{\frac{a}{b}} = \frac{\sqrt{a}}{\sqrt{b}}$$

com $a \ge 0$ e $b > 0$.
"""

# ╔═╡ 54778daa-38c0-4f73-bdcf-95a299323e36
begin
	hidecloak2(name) = HTML("""
	<style>
	plj-cloak.$(name) {
		opacity: 0;
		display: block;
	}
	</style>
	""")

	"Com a ≥ 0 e b ≥ 0."
	atenção2(name) = x -> @htl("<plj-cloak class=$(name)>$(x)</plj-cloak>")
end

# ╔═╡ 262c93d1-c737-4f52-8123-8cf5c85ca4e0
md"""
## 4. Extração de fator da raiz

Regra:

$$\sqrt{k^2 a} = k\sqrt{a}$$

para $k \ge 0$.
"""

# ╔═╡ 9dddf9e6-aa75-416a-9f59-b3afc4b8c781
md"""
## 5. Raiz de quadrado

A regra correta é:

$$\sqrt{x^2} = |x|$$

e **não** simplesmente $x$.

Isso é importante quando $x$ é negativo.
"""

# ╔═╡ e116a7bc-f07d-406a-b540-95ff90bd5d66
md"""
## 6. Quadrado da raiz

Regra:

$$(\sqrt{a})^2 = a$$

para $a \ge 0$.
"""

# ╔═╡ 8c12ac0b-aa92-4b68-bb8b-9a242b0003e1
md"""
## 7. Raiz n-ésima como potência

Regra:

$$\sqrt[n]{a} = a^{1/n}$$
"""

# ╔═╡ 1f9e2543-422d-447f-825b-cb3426f7dd30
md"""
## 8. Potência dentro da raiz n-ésima

Regra:

$$\sqrt[n]{a^m} = a^{m/n}$$
"""

# ╔═╡ b0a04137-2b9f-4b2b-a84d-37e2a9ee4afe
md"""
## 9. Produto na raiz n-ésima

Regra:

$$\sqrt[n]{ab} = \sqrt[n]{a}\sqrt[n]{b}$$
"""

# ╔═╡ 600a744c-3eb5-4df8-abd1-5d924b54340b
md"""
## 10. Quociente na raiz n-ésima

Regra:

$$\sqrt[n]{\frac{a}{b}} = \frac{\sqrt[n]{a}}{\sqrt[n]{b}}$$
"""

# ╔═╡ b2e45a73-3fb4-4a5c-b244-5a3dd31b1804
md"""
## 11. Raiz de raiz

Regra:

$$\sqrt{\sqrt{a}} = a^{1/4}$$
"""

# ╔═╡ 4885fa31-1982-4da8-88a5-ad122c7d910c
md"""
## 12. Expoente racional

Regra geral:

$$a^{p/q} = \sqrt[q]{a^p}$$

Aqui vamos testar com $p = m$ e $q = n$.
"""

# ╔═╡ cdf7c30a-a7b7-4b82-86fb-a5ba18fcd6e1
md"""
## 13. Cancelamento de índice com expoente

Quando faz sentido no domínio dos reais:

$$\sqrt[n]{a^n}$$

- se $n$ é **ímpar**, o resultado é $a$
- se $n$ é **par**, o resultado correto é parecido com valor absoluto no caso real adequado

Para evitar problemas, vamos usar um valor positivo.
"""

# ╔═╡ d54a7842-88e0-4f10-a533-95ae5dc24c54
md"""
## 14. Regra que **não** vale

Em geral:

$$\sqrt{a+b} \ne \sqrt{a} + \sqrt{b}$$

Essa é uma das confusões mais comuns.
"""

# ╔═╡ ae1d167f-9fe2-4d6e-aa5d-41fb0d6055f4
md"""
## 15. Outra regra que **não** vale

Em geral:

$$\sqrt{a-b} \ne \sqrt{a} - \sqrt{b}$$

Para evitar erro de domínio, usamos $a+b$ no primeiro exemplo e agora garantimos $c \ge b$.
"""

# ╔═╡ 7ef0c519-373e-4ce2-ad5c-7b203e3180f7
md"""
## 16. Simplificação de radical

Exemplo do tipo:

$$\sqrt{12} = \sqrt{4\cdot 3} = 2\sqrt{3}$$

Aqui fazemos a versão geral:

$$\sqrt{k^2 b} = k\sqrt{b}$$
"""

# ╔═╡ 12015be5-0e05-4320-98c0-ed395e5cc4c5
md"""
## 🎛 Parâmetros interativos
"""

# ╔═╡ d3503c40-7876-468d-9299-04395942604f
sidebar = @htl("""
<div class="plutoui-sidebar aside">
	<header>
		<span class="sidebar-toggle open-sidebar">🕹</span>
		<span class="sidebar-toggle closed-sidebar">🕹</span>
		Parâmetros interativos
	</header>

	<p>Escolha valores para testar as identidades:</p>

	<div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:1rem;">
		<strong>a</strong>
		$(@bind a PlutoUI.Scrubbable(1:1:20, default=3))
	</div>

	<div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:1rem;">
		<strong>b</strong>
		$(@bind b PlutoUI.Scrubbable(1:1:20, default=4))
	</div>

	<div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:1rem;">
		<strong>c</strong>
		$(@bind c PlutoUI.Scrubbable(1:1:20, default=5))
	</div>

	<div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:1rem;">
		<strong>k</strong>
		$(@bind k PlutoUI.Scrubbable(1:1:10, default=2))
	</div>

	<div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:1rem;">
		<strong>n</strong>
		$(@bind n PlutoUI.Scrubbable(2:1:8, default=3))
	</div>

	<div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:1rem;">
		<strong>m</strong>
		$(@bind m PlutoUI.Scrubbable(1:1:10, default=2))
	</div>

	<div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:1rem;">
		<strong>x (com sinal)</strong>
		$(@bind x PlutoUI.Scrubbable(-10:1:10, default=-3))
	</div>
</div>
""")

# ╔═╡ 6991a81c-12fa-40b2-aa97-736e98d9e32a
@handcalcs begin
	sqrt(a^2 + b^2)
end

# ╔═╡ 4184f23a-8c08-40cd-bd9b-14ac1941ef5c
@handcalcs begin
	sqrt(a * b)
	sqrt(a) * sqrt(b)
end

# ╔═╡ 0071b242-11c2-4419-8c8d-dba08fe4c2e6
@handcalcs begin
	sqrt(a / b)
	sqrt(a) / sqrt(b)
end

# ╔═╡ 3bdf2578-55bb-4a1f-b43e-f8838c729e3d
@handcalcs begin
	sqrt(k^2 * a)
	k * sqrt(a)
end

# ╔═╡ 6b0e939b-60df-4b66-8d10-2ceff5ba9ac1
@handcalcs begin
	sqrt(x^2)
	abs(x)
end

# ╔═╡ bacf643d-05f1-421a-a1fa-8a5501d6aca5
@handcalcs begin
	(sqrt(a))^2
	a
end

# ╔═╡ 2c077974-e6d3-476e-b7bc-19b008a6caa1
@handcalcs begin
	a^(1 / n)
end

# ╔═╡ 1f196ecb-4851-4990-b84f-05fd0599fc1f
@handcalcs begin
	(a^m)^(1 / n)
	a^(m / n)
end

# ╔═╡ 2c149256-a016-445d-af37-7b15abb8fc57
@handcalcs begin
	(a * b)^(1 / n)
	a^(1 / n) * b^(1 / n)
end

# ╔═╡ 0c635436-8cea-471a-becd-e87282543fb5
@handcalcs begin
	(a / b)^(1 / n)
	a^(1 / n) / b^(1 / n)
end

# ╔═╡ ae11aedd-c7ee-4946-97ca-b011256044f2
@handcalcs begin
	sqrt(sqrt(a))
	a^(1 / 4)
end

# ╔═╡ 0d122dae-1a9f-42a3-ba32-99d8ad8a91a6
@handcalcs begin
	a^(m / n)
	(a^m)^(1 / n)
end

# ╔═╡ 9bb4c1a1-7c37-4421-8eb5-ef6f3524091e
@handcalcs begin
	a
	(a^n)^(1 / n)
	a
end

# ╔═╡ cbd8c5fc-f643-428f-97bd-317f9faf43b7
@handcalcs begin
	sqrt(a + b)
	sqrt(a) + sqrt(b)
end

# ╔═╡ f85ac6ef-0c61-4265-be6f-cb70e3bcd9e2
@handcalcs begin
	c + b
	sqrt(c + b - b)
	sqrt(c + b) - sqrt(b)
end

# ╔═╡ e46bd90f-ca13-4ff1-afe6-bc9656142f72
@handcalcs begin
	sqrt(k^2 * b)
	k * sqrt(b)
end

# ╔═╡ c1bceda6-73ed-4cab-b288-d4c310928713
html"""
<style>
	div.plutoui-sidebar.aside {
		position: fixed;
		right: 1rem;
		top: 10rem;
		width: min(80vw, 300px);
		padding: 10px;
		border: 3px solid rgba(0, 0, 0, 0.15);
		border-radius: 10px;
		box-shadow: 0 0 11px 0px #00000010;
		max-height: calc(100vh - 5rem - 56px);
		overflow: auto;
		z-index: 40;
		background: white;
		transition: transform 300ms cubic-bezier(0.18, 0.89, 0.45, 1.12);
		color: var(--pluto-output-color);
		background-color: var(--main-bg-color);
	}

	div.plutoui-sidebar.aside.hide {
		transform: translateX(calc(100% - 32px));
	}

	.plutoui-sidebar header {
		display: block;
		font-size: 1.25em;
		margin-top: -0.1em;
		margin-bottom: 0.6em;
		padding-bottom: 0.4em;
		font-weight: bold;
		border-bottom: 2px solid rgba(0, 0, 0, 0.15);
	}

	.plutoui-sidebar.aside.hide .open-sidebar,
	.plutoui-sidebar.aside:not(.hide) .closed-sidebar {
		display: none;
	}

	.sidebar-toggle {
		cursor: pointer;
		margin-right: 0.4em;
	}
</style>

<script>
	let listener = event => {
		if (event.target.classList.contains("sidebar-toggle")) {
			document.querySelectorAll('.plutoui-sidebar').forEach(function(el) {
				el.classList.toggle("hide");
			});
		}
	}
	document.addEventListener('click', listener);

	invalidation.then(() => {
		document.removeEventListener('click', listener);
	})
</script>
"""

# ╔═╡ 631d62d4-ff35-423c-bf7f-14de63dd13ab
html"""
<style>
	div.plutoui-sidebar.aside {
		position: fixed;
		right: 1rem;
		top: 10rem;
		width: min(80vw, 300px);
		padding: 10px;
		border: 3px solid rgba(0, 0, 0, 0.15);
		border-radius: 10px;
		box-shadow: 0 0 11px 0px #00000010;
		max-height: calc(100vh - 5rem - 56px);
		overflow: auto;
		z-index: 40;
		background: white;
		transition: transform 300ms cubic-bezier(0.18, 0.89, 0.45, 1.12);
		color: var(--pluto-output-color);
		background-color: var(--main-bg-color);

.plutoui-sidebar header {
	font-size: 1.05rem;
	font-weight: 700;
	margin-bottom: 12px;
	padding-bottom: 8px;
	border-bottom: 1px solid rgba(255,255,255,0.12);
}
</style>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Handcalcs = "e8a07092-c156-4455-ab8e-ed8bc81edefb"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Handcalcs = "~0.5.1"
HypertextLiteral = "~1.0.0"
PlutoUI = "~0.7.80"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "53f0e21fd724f1ac5f4f9d2477638fee0d193dd9"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "062c5e1a5bf6ada13db96a4ae4749a4c2234f521"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.9"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "67e11ee83a43eb71ddc950302c53bf33f0690dfe"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.1"
weakdeps = ["StyledStrings"]

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

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

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Zlib_jll"]
git-tree-sha1 = "38044a04637976140074d0b0621c1edf0eb531fd"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.1+0"

[[deps.Handcalcs]]
deps = ["AbstractTrees", "CodeTracking", "InteractiveUtils", "LaTeXStrings", "Latexify", "MacroTools", "PrecompileTools", "Revise", "TestHandcalcFunctions"]
git-tree-sha1 = "13ea045e74df71c6580dcf036546f9b781861292"
uuid = "e8a07092-c156-4455-ab8e-ed8bc81edefb"
version = "0.5.1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "d1a86724f81bcd184a38fd284ce183ec067d71a0"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "1.0.0"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c0c9b76f3520863909825cbecdef58cd63de705a"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.5+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "6ac9e4acc417a5b534ace12690bc6973c25b862f"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.10.3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "Ghostscript_jll", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "44f93c47f9cd6c7e431f2f2091fcba8f01cd7e8f"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.10"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"
    TectonicExt = "tectonic_jll"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
    tectonic_jll = "d7dd28d6-a5e6-559c-9131-7eb760cdacc5"

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

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "4ef1c538614e3ec30cb6383b9eb0326a5c3a9763"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

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

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "fbc875044d82c113a9dee6fc14e16cf01fd48872"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.80"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.Revise]]
deps = ["CodeTracking", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "cedc9f9013f7beabd8a9c6d2e22c0ca7c5c2a8ed"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.7.6"

    [deps.Revise.extensions]
    DistributedExt = "Distributed"

    [deps.Revise.weakdeps]
    Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
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

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

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

[[deps.TestHandcalcFunctions]]
git-tree-sha1 = "54dac4d0a0cd2fc20ceb72e0635ee3c74b24b840"
uuid = "6ba57fb7-81df-4b24-8e8e-a3885b6fcae7"
version = "0.2.4"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

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
# ╠═af638a92-3996-11f1-107b-cb7a9b1c4710
# ╟─088b3770-6187-4602-b8e1-78df059e70ab
# ╟─802a4695-954a-43a0-a852-991316793740
# ╟─6991a81c-12fa-40b2-aa97-736e98d9e32a
# ╟─b4b597a3-0b6d-4e8f-81a8-5e65c6199510
# ╟─afce6230-b969-4de7-acd4-cb9cb7db1cd7
# ╟─4184f23a-8c08-40cd-bd9b-14ac1941ef5c
# ╟─421b630c-1590-4aa3-aa79-c777bf6526d0
# ╠═54778daa-38c0-4f73-bdcf-95a299323e36
# ╟─0071b242-11c2-4419-8c8d-dba08fe4c2e6
# ╟─262c93d1-c737-4f52-8123-8cf5c85ca4e0
# ╟─3bdf2578-55bb-4a1f-b43e-f8838c729e3d
# ╟─9dddf9e6-aa75-416a-9f59-b3afc4b8c781
# ╟─6b0e939b-60df-4b66-8d10-2ceff5ba9ac1
# ╟─e116a7bc-f07d-406a-b540-95ff90bd5d66
# ╟─bacf643d-05f1-421a-a1fa-8a5501d6aca5
# ╟─8c12ac0b-aa92-4b68-bb8b-9a242b0003e1
# ╟─2c077974-e6d3-476e-b7bc-19b008a6caa1
# ╟─1f9e2543-422d-447f-825b-cb3426f7dd30
# ╟─1f196ecb-4851-4990-b84f-05fd0599fc1f
# ╟─b0a04137-2b9f-4b2b-a84d-37e2a9ee4afe
# ╟─2c149256-a016-445d-af37-7b15abb8fc57
# ╟─600a744c-3eb5-4df8-abd1-5d924b54340b
# ╟─0c635436-8cea-471a-becd-e87282543fb5
# ╟─b2e45a73-3fb4-4a5c-b244-5a3dd31b1804
# ╟─ae11aedd-c7ee-4946-97ca-b011256044f2
# ╟─4885fa31-1982-4da8-88a5-ad122c7d910c
# ╟─0d122dae-1a9f-42a3-ba32-99d8ad8a91a6
# ╟─cdf7c30a-a7b7-4b82-86fb-a5ba18fcd6e1
# ╟─9bb4c1a1-7c37-4421-8eb5-ef6f3524091e
# ╟─d54a7842-88e0-4f10-a533-95ae5dc24c54
# ╟─cbd8c5fc-f643-428f-97bd-317f9faf43b7
# ╟─ae1d167f-9fe2-4d6e-aa5d-41fb0d6055f4
# ╟─f85ac6ef-0c61-4265-be6f-cb70e3bcd9e2
# ╟─7ef0c519-373e-4ce2-ad5c-7b203e3180f7
# ╟─e46bd90f-ca13-4ff1-afe6-bc9656142f72
# ╟─12015be5-0e05-4320-98c0-ed395e5cc4c5
# ╟─d3503c40-7876-468d-9299-04395942604f
# ╟─c1bceda6-73ed-4cab-b288-d4c310928713
# ╟─631d62d4-ff35-423c-bf7f-14de63dd13ab
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
