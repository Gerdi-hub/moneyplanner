require 'rails_helper'

RSpec.describe 'HomeController', type: :request do
  let(:user) { create(:user) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  it 'responds successfully to index when logged in' do
    get root_path
    expect(response).to have_http_status(:success)
  end
end






