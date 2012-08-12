require 'spec_helper'

describe User do
  it { should accept_values_for(:email, "john@example.com", "lambda@gusiev.com") }
  it { should_not accept_values_for(:email, "invalid", nil, "a@b", "john@.com") }
end
