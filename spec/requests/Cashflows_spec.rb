require 'rails_helper'

RSpec.describe "Cashflows", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:cashflows) { create_list(:cashflow, 3, user: user) }
  let!(:deleted_cashflows) { create_list(:cashflow, 2, :deleted, user: user) }
  let!(:other_users_cashflows) { create_list(:cashflow, 2, user: other_user) }
  include CsvHelper

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

    it "fetches correct year cashflows" do
      cashflow_2024 = create(:cashflow, user: user, date: Date.new(2024, 1, 1))
      cashflow_2025 = create(:cashflow, user: user, date: Date.new(2025, 2, 1))

      get cashflows_path, params: { years: [ "2024" ] }
      expect(response).to have_http_status(:success)
      expect(assigns(:cashflows).map(&:id)).to include(cashflow_2024.id)
      expect(assigns(:cashflows).map(&:id)).not_to include(cashflow_2025.id)
    end

    it "fetches correct month cashflows" do
        cashflow_01 = create(:cashflow, user: user, date: Date.new(2024, 1, 1))
        cashflow_02 = create(:cashflow, user: user, date: Date.new(2024, 2, 1))

        get cashflows_path, params: { months: [ "01-2024" ] }

        expect(response).to have_http_status(:success)
        expect(assigns(:cashflows).map(&:id)).to include(cashflow_01.id)
        expect(assigns(:cashflows).map(&:id)).not_to include(cashflow_02.id)
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

  describe "PATCH /cashflows/:id" do
      let (:cashflow) { create(:cashflow, user: user) }
      it "updates the requested cashflow with valid params" do
        get edit_cashflow_path(cashflow)
        expect(response).to have_http_status(:success)

        updated_attributes = {
          amount: 200.0,
          description: "Updated description",
          date: "2025-01-23",
          type_name: "Updated type"
        }

        patch cashflow_path(cashflow), params: { cashflow: updated_attributes }
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to have_http_status(:success)
        cashflow.reload
        expect(cashflow.amount).to eq(200.0)
        expect(cashflow.description).to eq("Updated description")
        expect(cashflow.date.to_s).to eq("2025-01-23")
        expect(cashflow.type_name).to eq("Updated type")
      end

      it "can not update cashflow with invalid params" do
        get edit_cashflow_path(cashflow)
        updated_description = { description: nil }
        patch cashflow_path(cashflow), params: { cashflow: updated_description }
        assert_response :unprocessable_entity
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

  describe "Post /import_records" do
    let(:seb_csv) { load_seb_fixture }
    let(:swed_csv) { load_swed_fixture }
    let(:invalid_csv) { load_invalid_fixture }
    context 'with valid SEB CSV' do
      it 'successfully imports transactions from SEB CSV' do
        expect { post import_records_path, params: { file: seb_csv } }.to change(Cashflow, :count).by(2)
        post import_records_path, params: { file: seb_csv }
        last_cashflow = Cashflow.last
        expect(last_cashflow.amount).to eq(BigDecimal("50.0"))
        expect(last_cashflow.description).to eq("Grete Test seb, rida2")
        expect(last_cashflow.date).to eq(Date.parse("2024-12-18"))
        expect(last_cashflow.credit_debit).to eq("debit")
      end
    end

    context 'with valid SWEDBANK CSV' do
      it 'successfully imports transactions from SWEDBANK CSV' do
        expect { post import_records_path, params: { file: swed_csv } }.to change(Cashflow, :count).by(2)
        post import_records_path, params: { file: swed_csv }
        last_cashflow = Cashflow.last
        expect(last_cashflow.amount).to eq(BigDecimal("-200.0"))
        expect(last_cashflow.description).to eq("Test swed, rida 2 Easy Saver")
        expect(last_cashflow.date).to eq(Date.parse("2025-01-03"))
        expect(last_cashflow.credit_debit).to eq("credit")
      end
    end

    context 'with invalid CSV' do
      it 'can not import invalid CSV' do
        post import_records_path, params: { file: invalid_csv }
        expect(flash[:alert]).to include("Error importing CSV: Unsupported CSV format")
      end
    end
  end
end
