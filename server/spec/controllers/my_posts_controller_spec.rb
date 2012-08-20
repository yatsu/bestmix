require 'spec_helper'

describe MyPostsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    # it "returns http success" do
    #   get 'create'
    #   response.should be_success
    # end
  end
end
