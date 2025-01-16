require 'rails_helper'

RSpec.describe 'Devise routes', type: :request do
  it 'responds to user sign-in route' do
    get new_user_session_path
    expect(response).to have_http_status(:success)
  end
end