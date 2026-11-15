LaTeX::Decode
=============
[![CI](https://github.com/inukshuk/latex-decode/actions/workflows/ci.yml/badge.svg)](https://github.com/inukshuk/latex-decode/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/latex-decode.svg)](https://badge.fury.io/rb/latex-decode)

LaTeX::Decode is a Ruby gem to convert LaTeX input to Unicode.
Its original use was as an input filter for [BibTeX-Ruby][]
but it can be used independently to decode LaTeX.
Many of the patterns used by this Ruby gem
are based on François Charette's equivalent Perl module [LaTeX::Decode][].

Quickstart
----------
    $ gem install latex-decode
    $ irb
    >> require 'latex/decode'
    >> LaTeX.decode "dipl\\^{o}me d'\\'{e}tudes sup\\'erieures"
    => "diplôme d'études supérieures"

Math
----
Math in `$…$`, `\(…\)`, `$$…$$` or `\[…\]`
is converted to Unicode if all of it can be represented,
which covers most math found in bibliographies:
Greek letters and symbols, sub- and superscripts,
font letters like `\mathbb`, accents, fractions and roots.

    >> LaTeX.decode '$\alpha$-decay of $^{13}$C'
    => "α-decay of ¹³C"
    >> LaTeX.decode 'Sorting in $O(n \log n)$ on $\mathbb{R}^n$'
    => "Sorting in O(n log n) on ℝⁿ"

Math that cannot be converted completely is kept as it is,
including the delimiters,
so that it can still be rendered,
for example, by MathJax or KaTeX.
Unicode has no subscript f, for instance:

    >> LaTeX.decode 'Effective temperature $T_{\mathrm{eff}}$'
    => "Effective temperature $T_{\\mathrm{eff}}$"

To keep all math as it is always, pass `math: false`:

    >> LaTeX.decode '$\alpha$-decay', math: false
    => "$\\alpha$-decay"

Math nested in text inside math,
like `$a \text{ if $b$} c$`,
is not currently supported.


Issues
------
Please use the tracker of the project's [repository][]
to report any issues.
When describing intended behaviour,
please use the syntax of the Cucumber features used by LaTeX::Decode.
For instance, you could describe the example above as:
```Gherkin
    Feature: Decode LaTeX accents
      As a hacker who works with LaTeX
      I want to be able to decode LaTeX accents

      Scenario: A French sentence
        When I decode the string "dipl\\^{o}me d'\\'{e}tudes sup\\'erieures"
        Then the result should be "diplôme d'études supérieures"
```

Credits
-------
Kudos and thanks to all [contributors][]
who have made LaTeX::Decode possible!

Copyright (C) 2011-2026 Sylvester Keil\
Copyright (C) 2010 François Charette


[BibTeX-Ruby]: https://rubygems.org/gems/bibtex-ruby
[LaTeX::Decode]: https://github.com/fc7/LaTeX-Decode

[repository]: https://github.com/inukshuk/latex-decode 
[contributors]: https://github.com/inukshuk/latex-decode/contributors
[LICENSE]: https://github.com/inukshuk/latex-decode/blob/main/LICENSE
