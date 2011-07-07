Feature: Decode LaTeX umlauts
  As a hacker who works with LaTeX
  I want to be able to decode LaTeX punctuation marks

  Scenario: Double dashes to german Gedankenstriche
    When I decode the string 'foo -- bar'
    Then the result should be 'foo – bar'

  Scenario: Standalone dashes to german Gedankenstriche
    When I decode the string 'foo - bar'
    Then the result should be 'foo – bar'

  Scenario: Escaped Ampersand
    When I decode the string 'foo \& bar'
    Then the result should be 'foo & bar'
