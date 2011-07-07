When /^I decode the string '(.*)'$/ do |string|
  @result = LaTeX.decode(string)
end

Then /^the result should be '(.*)'$/ do |value|
  @result.should == value
end