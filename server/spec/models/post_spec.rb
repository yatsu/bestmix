require 'spec_helper'

describe Post do
  it { should accept_values_for(:title, "aaa", Faker::Product.letters(255)) }
  it { should_not accept_values_for(:title, "", "aa", nil, Faker::Product.letters(256)) }

  it { should accept_values_for(:content, nil, "", "aaa", Faker::Product.letters(10000)) }
  it { should_not accept_values_for(:content, Faker::Product.letters(10001)) }
end
