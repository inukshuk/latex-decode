When /^I decode the string ('|")(.*)\1$/ do |quote,string|
  @result = LaTeX.decode(string)
end

When /^I decode the string ('|")(.*)\1 keeping math as TeX$/ do |quote,string|
  @result = LaTeX.decode(string, math: false)
end

When /^I decode the following string:$/ do |string|
  @result = LaTeX.decode(string)
end

When /^I decode the following string keeping math as TeX:$/ do |string|
  @result = LaTeX.decode(string, math: false)
end

When /^I decode (\d+) repetitions of ('|")(.*)\2 within (\d+) seconds?$/ do |n,quote,string,seconds|
  Timeout.timeout(seconds.to_i) do
    @result = LaTeX.decode(string * n.to_i)
  end
end

Then /^the result should be ('|")(.*)\1$/ do |quote,value|
  expect(@result).to eq(value)
end

Then /^the result should be the following string:$/ do |value|
  expect(@result).to eq(value)
end

Then /^the code points should be ((?:U\+\h{4,} ?)+)$/ do |codes|
  expect(@result.codepoints).to eq(codes.scan(/U\+(\h+)/).flatten.map(&:hex))
end

# For whitespace or other characters that are hard to read in source code:
Then /^I should get '([^']*)' \+ U\+(\h{4,}) \+ '([^']*)'$/ do |pre,code,post|
  expect(@result).to eq(pre + code.hex.chr(Encoding::UTF_8) + post)
end
