Feature: Preserve LaTeX math
  As a hacker who works with LaTeX
  I want math to be kept separate from the surrounding text
  So that text decoding does not mangle it

  Scenario: Inline math is preserved
    When I decode the string '$\alpha$-decay'
    Then the result should be '$\alpha$-decay'

  Scenario: Commands and braces inside math are preserved
    When I decode the string '$\mathcal{O}(n \log n)$'
    Then the result should be '$\mathcal{O}(n \log n)$'
    When I decode the string '$\frac{1}{2}$'
    Then the result should be '$\frac{1}{2}$'
    When I decode the string '$\sqrt{x}$'
    Then the result should be '$\sqrt{x}$'

  Scenario: Text rules do not apply inside math
    When I decode the string '$a -- b$'
    Then the result should be '$a -- b$'
    When I decode the string '$a~b$'
    Then the result should be '$a~b$'
    When I decode the string "$f''(x)$"
    Then the result should be "$f''(x)$"

  Scenario: Text around math is still decoded
    When I decode the string 'na\"ive $\alpha$ \c{c}a'
    Then the result should be 'naïve $\alpha$ ça'

  Scenario: Multiple math spans
    When I decode the string '$x$ \textendash{} $\beta$'
    Then the result should be '$x$ – $\beta$'

  Scenario: Math inside braces
    When I decode the string '{$\alpha$}-decay'
    Then the result should be '$\alpha$-decay'

  Scenario: Display math is preserved
    When I decode the string '$$\sum_{i} x_{i}$$'
    Then the result should be '$$\sum_{i} x_{i}$$'

  Scenario: Parenthesis and bracket delimiters are preserved
    When I decode the string '\(\alpha\) and \[\frac{1}{2}\]'
    Then the result should be '\(\alpha\) and \[\frac{1}{2}\]'

  Scenario: Escaped dollar signs are not math
    When I decode the string 'costs \$5 or \$10'
    Then the result should be 'costs $5 or $10'

  Scenario: Escaped dollar signs inside math are preserved
    When I decode the string '$\$5$'
    Then the result should be '$\$5$'

  Scenario: An escaped backslash does not escape a following dollar sign
    When I decode the string 'a\\$x$'
    Then the result should be 'a\\$x$'

  Scenario: Unmatched dollar signs are text
    When I decode the string 'a $ b'
    Then the result should be 'a $ b'

  Scenario: Unmatched math delimiters are text
    When I decode the string 'a \( 1'
    Then the result should be 'a \( 1'

  Scenario: Adjacent math spans
    When I decode the string '$a$$b$'
    Then the result should be '$a$$b$'

  Scenario: Line breaks with spacing are not display math
    When I decode the string 'a\\[2pt] b'
    Then the result should be 'a\\[2pt] b'

  Scenario: Math spanning multiple lines
    When I decode the following string:
      """
      $a +
      \alpha$
      """
    Then the result should be the following string:
      """
      $a +
      \alpha$
      """

  Scenario: Many unmatched delimiters are handled in linear time
    When I decode 10000 repetitions of '\( 1 ' within 2 seconds
