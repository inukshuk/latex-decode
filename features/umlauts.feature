Feature: Decode LaTeX umlauts
	As a hacker who works with LaTeX
	I want to be able to decode LaTeX umlauts
	
	Scenario: German umlauts
		When I decode the string '\"a\"o\"u'
		Then the result should be 'äöü'