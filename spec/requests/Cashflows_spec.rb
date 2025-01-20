require 'rails_helper'

RSpec.describe "Cashflows", type: :request do
  let(:user) { create(:user) }
  let!(:cashflows) { create_list(:cashflow, 3, user: user, deleted_at: nil) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe "GET /cashflows" do
    it "returns a successful response" do
      get cashflows_path
      expect(response).to have_http_status(:success)
    end

    it "fetches the user's active cashflows" do
      get cashflows_path
      expect(assigns(:user_cashflows)).to match_array(cashflows)
    end
  end

  describe "POST /cashflows" do
    let(:valid_params) do
      {
        cashflow: {
          amount: 100.50,
          description: "Salary",
          type_name: "Income",
          date: Date.today
        }
      }
    end

    it "creates a new cashflow and redirects to the index" do
      expect {
        post cashflows_path, params: valid_params
      }.to change(Cashflow, :count).by(1)

      expect(response).to redirect_to(cashflows_path)
      follow_redirect!
      expect(response.body).to include("Cashflow added successfully!")
    end

    it "does not create a cashflow with invalid data" do
      invalid_params = { cashflow: { amount: nil, description: "", date: nil } }

      expect {
        post cashflows_path, params: invalid_params
      }.not_to change(Cashflow, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end