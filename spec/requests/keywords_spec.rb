require 'rails_helper'

RSpec.describe 'Keywords', type: :request do
  let(:user) { create(:user) }
  let!(:keywords) { create_list(:keyword, 2) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe 'GET /keywords' do
    it 'returns a success response' do
      get keywords_path
      expect(response).to be_successful
    end
  end

  describe 'POST /keywords' do
    let(:valid_attributes) {
      { keyword: attributes_for(:keyword) }
    }


    it 'creates a new keyword' do
      get new_keyword_path
      assert_response :success
      expect {
        post keywords_path, params: valid_attributes
      }.to change(Keyword, :count).by(1)
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) {
        { keyword: { name: '' } }
      }

      it 'does not create a new keyword' do
        expect {
          post keywords_path, params: invalid_attributes
        }.not_to change(Keyword, :count)
      end

      it 'returns unprocessable entity status' do
        post keywords_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new template' do
        post keywords_path, params: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /keywords/:id' do
    let(:keyword) { create(:keyword) }
    let(:invalid_attributes) { { name: nil } }

    it 'updates a keyword' do
      get edit_keyword_path(keyword)
      assert_response :success
      expect(response.body).to include(keyword.name)
      patch keyword_path(keyword), params: { keyword: { name: keyword.name } }
      assert_response :redirect
      follow_redirect!
      assert_response :success
      expect(response.body).to include(keyword.name)
    end

    it 'can not update a keyword with invalid params' do
      patch keyword_path(keyword), params: { keyword: invalid_attributes }
      assert_response :unprocessable_entity
    end
  end
end
