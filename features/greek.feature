Feature: Decode LaTeX Greek Letters
  As a hacker who works with LaTeX
  I want to be able to decode Greek letters

  Scenario Outline: LaTeX to Unicode transformation
    When I decode the string '<latex>'
    Then the result should be '<unicode>'

  Scenarios: Greek
    | latex                | unicode |
    | \\alpha              | α       |
    | \\lambda             | λ       |
    | \\Lambda             | Λ       |
    | \\pi                 | π       |
    | \\Pi                 | Π       |

  Scenario: Capital Delta is the Greek letter, not the increment sign
    When I decode the string '\Delta'
    Then I should get '' + U+0394 + ''
