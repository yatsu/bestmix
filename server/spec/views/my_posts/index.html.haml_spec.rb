require 'spec_helper'

describe "my_posts/index.html.haml" do
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
    assign(:posts, FactoryGirl.create_list(:post, 25))
  end

  it "displays my posts" do
    render
    rendered.should render_template("my_posts/index")
  end
end
