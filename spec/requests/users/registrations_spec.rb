require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe 'POST /users/sign_in' do
    it 'logs in a user with valid credentials' do
      user = create(:user, password: 'password123')
      post user_session_path, params: { user: { email: user.email, password: 'password123' } }
      expect(response).to redirect_to(root_path)
    end

    it 'does not log in a user with invalid credentials' do
      post user_session_path, params: { user: { email: 'wrong@example.com', password: 'password123' } }
      expect(response).to render_template(:new)
    end
  end
  end

