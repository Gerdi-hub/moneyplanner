require 'rails_helper'

RSpec.describe Keyword, type: :model do
  it "is valid with valid attributes" do
    keyword = build(:keyword)
    expect(keyword).to be_valid
  end

  it "is invalid without a name" do
    keyword = build(:keyword, name: nil)
    expect(keyword).not_to be_valid
  end

  it "is invalid without a type_name" do
    keyword = build(:keyword, type_name: nil)
    expect(keyword).not_to be_valid
  end

  it "is invalid with a too long name" do
    keyword = build(:keyword, name: Faker::Lorem.characters(number: 200))
    expect(keyword).not_to be_valid
  end

  it "is invalid with a too long type_name" do
    keyword = build(:keyword, type_name: Faker::Lorem.characters(number: 200))
    expect(keyword).not_to be_valid
  end
end
