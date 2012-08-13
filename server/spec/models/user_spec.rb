require 'spec_helper'

describe User do
  it { should accept_values_for(:email, "john@example.com", "lambda@gusiev.com") }
  it { should_not accept_values_for(:email, "invalid", nil, "a@b", "john@.com") }

  context "with email 'user@example.com'" do
    subject { create(:user, email: "user@example.com") }

    its(:email) { should == "user@example.com" }
  end
end
