require 'rails_helper'

RSpec.describe Cashflow, type: :model do
  it "is valid with valid attributes" do
    cashflow = build(:cashflow)
    expect(cashflow).to be_valid
  end

  it "is invalid without an amount" do
    cashflow = build(:cashflow, amount: nil)
    expect(cashflow).not_to be_valid
  end

  it "is invalid with amount equal to 0" do
    cashflow = build(:cashflow, amount: 0)
    expect(cashflow).not_to be_valid
  end

  it "sets credit_debit value to credit, if negative" do
    cashflow = create(:cashflow, amount: "-1")
    expect(cashflow.credit_debit).to eq("credit")
  end

  it "is invalid without a description" do
    cashflow = build(:cashflow, description: nil)
    expect(cashflow).not_to be_valid
  end

  it "is invalid with a too long description" do
    cashflow = build(:cashflow, description: "A" * 201)
    expect(cashflow).not_to be_valid
  end
  it "is valid with a valid user" do
    user = create(:user)
    cashflow = build(:cashflow, user: user)
    expect(cashflow).to be_valid
  end
  
  it "assignes correct type_name" do
    create(:keyword, name: "test_keyword", type_name: "test_type")
    cashflow = create(:cashflow, description: "test_keyword")
    expect(cashflow.type_name).to eq("test_type")
  end

end
