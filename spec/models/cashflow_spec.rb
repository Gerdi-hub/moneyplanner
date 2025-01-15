require 'rails_helper'

RSpec.describe Cashflow, type: :model do
  it "is valid with valid attributes" do
    cashflow = FactoryBot.build(:cashflow)
    expect(cashflow).to be_valid
  end

  it "is invalid without an amount" do
    cashflow = FactoryBot.build(:cashflow, amount: nil)
    expect(cashflow).not_to be_valid
  end

  it "is invalid with amount equal to 0" do
    cashflow = FactoryBot.build(:cashflow, amount: 0)
    expect(cashflow).not_to be_valid
  end

  it "is invalid without a description" do
    cashflow = FactoryBot.build(:cashflow, description: nil)
    expect(cashflow).not_to be_valid
  end

  it "is invalid with a too long description" do
    cashflow = FactoryBot.build(:cashflow, description: "A" * 201)
    expect(cashflow).not_to be_valid
  end
  it "is valid with a valid user" do
    user = FactoryBot.create(:user)
    cashflow = FactoryBot.build(:cashflow, user: user)
    expect(cashflow).to be_valid
  end

end