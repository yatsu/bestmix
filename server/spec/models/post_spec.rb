require 'spec_helper'

describe Post do
  it { should accept_values_for(:title, "aaa", Faker::Product.letters(255)) }
  it { should_not accept_values_for(:title, "", "aa", nil, Faker::Product.letters(256)) }

  it { should accept_values_for(:content, nil, "", "aaa", Faker::Product.letters(10000)) }
  it { should_not accept_values_for(:content, Faker::Product.letters(10001)) }

  context "with title 'my blog post'" do
    subject { create(:post, title: "my blog post") }

    its(:title) { should == "my blog post" }

    it "should belong to user" do
      subject.user.class.should be == User
    end
  end

  context "when it is published" do
    subject { create(:post) }

    its(:deleted) { should be_false }
    its(:published) { should be_true }
  end

  context "when it is not published" do
    subject { create(:non_published_post) }

    its(:deleted) { should be_false }
    its(:published) { should be_false }
  end

  context "when it is deleted" do
    subject { create(:deleted_post) }

    its(:deleted) { should be_true }
  end
end
