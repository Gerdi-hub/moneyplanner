require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    describe 'username' do
      it 'is required' do
        user = build(:user, username: nil)
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("can't be blank")
      end

      it 'must be unique' do
        duplicate_user = build(:user, username: user.username)
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:username]).to include("has already been taken")
      end

      it 'must be at least 3 characters' do
        user = build(:user, username: 'ab')
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("is too short (minimum is 3 characters)")
      end

      it 'must not exceed 25 characters' do
        user = build(:user, username: 'a' * 26)
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("is too long (maximum is 25 characters)")
      end
    end

    describe 'email' do
      it 'is required' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'must be unique' do
        duplicate_user = build(:user, email: user.email)
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).to include("has already been taken")
      end

      it 'must be in valid format' do
        user = build(:user, email: 'invalid_email')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    describe 'password' do
      it 'is required for new records' do
        user = build(:user, password: nil)
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end

      it 'must meet minimum length requirement' do
        user = build(:user, password: '12345')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end
    end
  end

  describe 'associations' do
    it { should have_many(:cashflows).dependent(:destroy) }

    describe 'cashflows association' do
      it 'can have many cashflows' do
        user = create(:user)
        create_list(:cashflow, 3, user: user)
        expect(user.cashflows.count).to eq(3)
      end

      it 'deletes associated cashflows when user is deleted' do
        user = create(:user)
        create_list(:cashflow, 3, user: user)
        expect { user.destroy }.to change { Cashflow.count }.by(-3)
      end
    end
  end

  describe 'authentication' do
    it 'authenticates with correct password' do
      user = create(:user, password: 'password123')
      expect(user.valid_password?('password123')).to be true
    end

    it 'does not authenticate with incorrect password' do
      user = create(:user, password: 'password123')
      expect(user.valid_password?('wrongpassword')).to be false
    end
  end
end