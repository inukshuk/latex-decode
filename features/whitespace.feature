Feature: Decode LaTeX whitespace directives
  As a hacker who works with LaTeX
  I want to be able to decode LaTeX whitespace

  Scenario Outline: LaTeX to Unicode transformation
    When I decode the string '<latex>'
    Then I should get <pre> + U+<code> + <post>

  Scenarios: Whitespace
    | latex | pre | code | post | description                |
    | x~x   | 'x' | 00A0 | 'x'  | non-breaking space         |
    | ~y    | ''  | 00A0 | 'y'  | leading non-breaking space |
    | z\\,z | 'z' | 2009 | 'z'  | small space                |
