require 'rails_helper'

RSpec.describe "Cashflows", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:cashflows) { create_list(:cashflow, 3, user: user) }
  let!(:deleted_cashflows) { create_list(:cashflow, 2, :deleted, user: user) }
  let!(:other_users_cashflows) { create_list(:cashflow, 2, user: other_user) }

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

    it "does not fetch deleted cashflows" do
      get cashflows_path
      deleted_ids = deleted_cashflows.map(&:id)
      fetched_ids = assigns(:user_cashflows).map(&:id)
      expect(fetched_ids).not_to include(*deleted_ids)
    end

    it "does not fetch other users' cashflows" do
      get cashflows_path
      other_users_ids = other_users_cashflows.map(&:id)
      fetched_ids = assigns(:user_cashflows).map(&:id)
      expect(fetched_ids).not_to include(*other_users_ids)
    end
  end

  describe "POST /cashflows" do
    let(:valid_cashflow) { attributes_for(:cashflow) }

    context "with valid parameters" do
      it "creates a new cashflow and redirects to the index" do
        expect {
          post cashflows_path, params: { cashflow: valid_cashflow }
        }.to change(Cashflow, :count).by(1)

        expect(response).to redirect_to(cashflows_path)
        follow_redirect!
        expect(response.body).to include("Cashflow added successfully!")
      end
    end

    context "with invalid parameters" do
      it "does not create a cashflow with zero amount" do
        invalid_cashflow = attributes_for(:cashflow, :invalid_zero_amount)

        expect {
          post cashflows_path, params: { cashflow: invalid_cashflow }
        }.not_to change(Cashflow, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a cashflow with no description" do
        invalid_cashflow = attributes_for(:cashflow, :invalid_no_description)

        expect {
          post cashflows_path, params: { cashflow: invalid_cashflow }
        }.not_to change(Cashflow, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a cashflow with a long description" do
        invalid_cashflow = attributes_for(:cashflow, :invalid_long_description)

        expect {
          post cashflows_path, params: { cashflow: invalid_cashflow }
        }.not_to change(Cashflow, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a cashflow with a long type name" do
        invalid_cashflow = attributes_for(:cashflow, :invalid_long_type_name)

        expect {
          post cashflows_path, params: { cashflow: invalid_cashflow }
        }.not_to change(Cashflow, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a cashflow with no date" do
        invalid_cashflow = attributes_for(:cashflow, :invalid_no_date)

        expect {
          post cashflows_path, params: { cashflow: invalid_cashflow }
        }.not_to change(Cashflow, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /cashflows/:id" do
    context "when the user owns the cashflow" do
      it "soft-deletes the cashflow and redirects to the index" do
        cashflow_to_delete = cashflows.first

        expect {
          delete cashflow_path(cashflow_to_delete)
        }.not_to change(Cashflow, :count)

        cashflow_to_delete.reload
        expect(cashflow_to_delete.deleted_at).not_to be_nil
        expect(response).to redirect_to(cashflows_path)
        follow_redirect!
        expect(response.body).to include("Cashflow marked as deleted!")
      end
    end

    context "when the cashflow belongs to another user" do
      it "does not delete the cashflow and returns a forbidden status" do
        cashflow_to_delete = other_users_cashflows.first

        expect {
          delete cashflow_path(cashflow_to_delete)
        }.not_to change(Cashflow, :count)

        cashflow_to_delete.reload
        expect(cashflow_to_delete.deleted_at).to be_nil
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
