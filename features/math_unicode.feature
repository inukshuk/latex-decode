Feature: Convert LaTeX math to Unicode
  As a hacker who works with LaTeX
  I want simple math to be converted to Unicode
  And complex math to be kept as it is

  Scenario Outline: Symbols, operators and function names
    When I decode the string '<latex>'
    Then the result should be '<unicode>'

    Examples:
      | latex             | unicode     |
      | $\\alpha$-decay   | α-decay     |
      | $\\Delta E$       | Δ E         |
      | $\\varepsilon$    | ε           |
      | $K(\\pi, 1)$      | K(π, 1)     |
      | $x \\leq y$       | x ≤ y       |
      | $a \\times b$     | a × b       |
      | $\\pm 1$          | ± 1         |
      | $n = 3$           | n = 3       |
      | $-1$              | −1          |
      | $f'(x)$           | f′(x)       |
      | $O(n \\log n)$    | O(n log n)  |
      | $\\sin x$         | sin x       |
      | ${x}$             | x           |
      | $\\{x\\}$         | {x}         |
      | $ x  =  y $       | x = y       |
      | $a \\bmod n$      | a mod n     |
      | $a \\mod n$       | a mod n     |
      | $\\backslash$     | \\          |
      | $\\varLambda$     | Λ           |
      | $\\circledR$      | ®           |
      | $\\scriptstyle x$ | x           |

  Scenario Outline: Superscripts and subscripts
    When I decode the string '<latex>'
    Then the result should be '<unicode>'

    Examples:
      | latex           | unicode |
      | $H_2O$          | H₂O     |
      | $E = mc^2$      | E = mc² |
      | $^{13}$C        | ¹³C     |
      | $x_{i+1}$       | xᵢ₊₁    |
      | $x^{-1}$        | x⁻¹     |
      | $x^n$           | xⁿ      |
      | $x_i^2$         | xᵢ²     |
      | $\\alpha^2$     | α²      |
      | $x_\\beta$      | xᵦ      |
      | $x^\\prime$     | x′      |
      | $x^*$           | x*      |
      | $90^\\circ$     | 90°     |
      | $x^{a b}$       | xᵃᵇ     |
      | $\\ell^{\\prime -}$ | ℓ′⁻ |
      | $C\\sp*$        | C*      |
      | $x\\sb 2$       | x₂      |

  Scenario Outline: Superscripts and subscripts without a Unicode equivalent
    When I decode the string '<latex>'
    Then the result should be '<latex>'

    Examples:
      | latex                  |
      | $T_c$                  |
      | $x^q$                  |
      | $T_{\\mathrm{eff}}$    |
      | $x^$                   |

  Scenario Outline: Font commands
    When I decode the string '<latex>'
    Then the result should be '<unicode>'

    Examples:
      | latex                     | unicode   |
      | $\\mathbb{R}^n$           | ℝⁿ        |
      | $\\mathbb{Z}_2$           | ℤ₂        |
      | $\\mathbb R$              | ℝ         |
      | $\\mathbb{E}$             | 𝔼         |
      | $\\mathbb{1}$             | 𝟙         |
      | $\\mathcal{O}(n)$         | 𝒪(n)      |
      | $\\mathcal{L}$            | ℒ         |
      | $\\mathfrak{g}$           | 𝔤         |
      | $\\mathfrak{H}$           | ℌ         |
      | $\\mathbf{x}$             | 𝐱         |
      | $\\mathsf{P}$             | 𝖯         |
      | $\\mathtt{a}$             | 𝚊         |
      | $\\mathrm{d}x$            | dx        |
      | $\\text{if } x > 0$       | if x > 0  |
      | $\\operatorname{rank}(A)$ | rank(A)   |
      | $\\boldsymbol{k}\\cdot\\boldsymbol{p}$ | 𝐤⋅𝐩 |
      | $\\boldsymbol{\\alpha}$   | 𝛂         |
      | $\\bm{x}$                 | 𝐱         |
      | $\\mathbf{\\Xi}$          | 𝚵         |
      | $\\mathbf{2.76}$          | 𝟐.𝟕𝟔      |
      | $\\mathbf{1^{--}}$        | 𝟏⁻⁻       |
      | $\\mathbb{R^n}$           | ℝⁿ        |
      | $\\mathbf{(\\frac{1}{2},0,\\frac{1}{2})}$ | (½,𝟎,½) |
      | $\\mathbf{SO(10)}\\times \\mathbf{S_4} $  | 𝐒𝐎(𝟏𝟎)× 𝐒₄ |

  Scenario Outline: Text inside math is decoded as text
    When I decode the string '<latex>'
    Then the result should be '<unicode>'

    Examples:
      | latex                              | unicode   |
      | $\\textit{s}$                      | s         |
      | $\\mbox{-}$                        | -         |
      | $x \\text{ if } y$                 | x if y    |
      | $\\text{na\\"ive}$                 | naïve     |
      | $\\text{Bi}_2\\text{Te}_3$         | Bi₂Te₃    |

  Scenario Outline: Old-style font switches
    When I decode the string '<latex>'
    Then the result should be '<unicode>'

    Examples:
      | latex                               | unicode        |
      | $\\bf P$                            | 𝐏              |
      | ${\\bf P}^{n}$                      | 𝐏ⁿ             |
      | ${\\rm GL}(2)$                      | GL(2)          |
      | ${\\rm Br}(X)={\\rm Br}'(X)$        | Br(X)=Br′(X)   |
      | ${\\cal O}$                         | 𝒪              |
      | ${\\it x}$                          | x              |
      | ${\\bf x} + y$                      | 𝐱 + y          |

  Scenario Outline: Font commands without a Unicode equivalent
    When I decode the string '<latex>'
    Then the result should be '<latex>'

    Examples:
      | latex                  |
      | $\\mathbb{\\alpha}$    |
      | $\\mathfrak{\\Gamma}$  |
      | $\\mathbb{}$           |
      | $\\boldsymbol{\\aleph}$ |

  Scenario Outline: Fractions and roots
    When I decode the string '<latex>'
    Then the result should be '<unicode>'

    Examples:
      | latex                    | unicode    |
      | $\\frac{1}{2}$           | ½          |
      | $\\frac{3}{4}$           | ¾          |
      | $\\frac12$               | ½          |
      | $\\tfrac{1}{3}$          | ⅓          |
      | $\\frac{a}{b}$           | a/b        |
      | $\\frac{n+1}{2}$         | (n+1)/2    |
      | $\\frac{1}{\\sqrt{2}}$   | 1/√2       |
      | $\\sqrt{x}$              | √x         |
      | $\\sqrt{13}$             | √13        |
      | $\\sqrt{x+1}$            | √(x+1)     |
      | $\\sqrt{s} = 13$         | √s = 13    |
      | $\\sqrt[3]{x}$           | ∛x         |
      | $\\sqrt[n]{x}$           | ⁿ√x        |
      | $\\sqrt[m]{d_1}$         | ᵐ√d₁       |
      | $\\sqrt{xy}$             | √(xy)      |
      | $\\sqrt[n]{p(n)}$        | ⁿ√(p(n))   |
      | $(r-1)!\\sqrt[r]{2+\\sqrt{5}}$ | (r−1)!ʳ√(2+√5) |

  Scenario Outline: Delimiters
    When I decode the string '<latex>'
    Then the result should be '<unicode>'

    Examples:
      | latex                              | unicode   |
      | $\\left(\\frac{a}{b}\\right)$      | (a/b)     |
      | $\\left\\{ x \\right\\}$           | { x }     |
      | $\\left. x \\right\|$              | x \|      |
      | $\\langle x \\rangle$              | ⟨ x ⟩     |
      | $\\bigl[ x \\bigr]$                | [ x ]     |

  Scenario: Spacing commands
    When I decode the string '$13\,\mathrm{TeV}$'
    Then I should get '13' + U+202F + 'TeV'
    When I decode the string '$a \quad b$'
    Then I should get 'a' + U+2003 + 'b'
    When I decode the string '$a\!b$'
    Then the result should be 'ab'

  Scenario Outline: Fractions and roots without a Unicode equivalent
    When I decode the string '<latex>'
    Then the result should be '<latex>'

    Examples:
      | latex             |
      | $\\sqrt[q]{x}$    |
      | $\\frac{1}$       |

  Scenario: Accents on a single symbol
    When I decode the string '$\bar{x}$'
    Then I should get 'x' + U+0304 + ''
    When I decode the string '$\hat p$'
    Then I should get 'p' + U+0302 + ''
    When I decode the string '$\tilde{A}$'
    Then I should get '' + U+00C3 + ''
    When I decode the string '$\dot{x}$'
    Then I should get '' + U+1E8B + ''
    When I decode the string '$\vec{v}$'
    Then I should get 'v' + U+20D7 + ''
    When I decode the string '$\barΨ Ψ$'
    Then I should get 'Ψ' + U+0304 + ' Ψ'

  Scenario: Over- and underlines mark every symbol
    When I decode the string '$\overline{AB}$'
    Then the code points should be U+0041 U+0305 U+0042 U+0305
    When I decode the string '$\underline{x}$'
    Then I should get 'x' + U+0332 + ''

  Scenario Outline: Accents without a Unicode equivalent
    When I decode the string '<latex>'
    Then the result should be '<latex>'

    Examples:
      | latex                    |
      | $\\hat{SO}(5)$           |
      | $\\widetilde{ABC}$       |
      | $\\overline{}$           |

  Scenario: Text around math is decoded too
    When I decode the string 'na\"ive $\alpha$ \c{c}a'
    Then the result should be 'naïve α ça'

  Scenario Outline: Unsupported math is kept as it is
    When I decode the string '<latex>'
    Then the result should be '<latex>'

    Examples:
      | latex                                |
      | $\\foo{x}$                           |
      | $\\begin{pmatrix} a \\end{pmatrix}$  |
      | $a & b$                              |
      | $\\alpha \\foo$                      |
