Feature: Disable parts of the decoding
  As a hacker who works with LaTeX
  I want to turn off individual decoding steps

  Scenario: Keep braces
    When I decode the string '{a} -- b' without strip_braces
    Then the result should be '{a} – b'
    When I decode the string '{\"a} -- b' without strip_braces
    Then the result should be '{ä} – b'

  Scenario: Keep punctuation
    When I decode the string '{a} -- b' without punctuation
    Then the result should be 'a -- b'
    When I decode the string '\"a -- b' without punctuation
    Then the result should be 'ä -- b'
