require 'rails_helper'

RSpec.describe "Keywords", type: :request do
  let(:user) { create(:user) }
  let!(:keywords) { create_list(:keyword, 2 ) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe 'GET /keywords' do
    it "returns a success response" do
      get keywords_path
      expect(response).to be_successful
    end
  end

  describe 'Post /keywords' do

  end

end
