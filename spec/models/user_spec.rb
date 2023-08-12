# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'associations' do
    it { should have_many(:tasks).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_presence_of(:email) }

    describe 'password complexity' do
      it 'fails when password does not meet complexity requirements' do
        user = build(:user, password: 'simple')
        expect(user).to_not(be_valid)
        error_message = 'Complexity requirement not met. Length should be 8-70 characters ' \
                        'and include: 1 uppercase, 1 lowercase, 1 digit, and 1 special character'
        expect(user.errors[:password]).to include(error_message)
      end

      it 'passes when password meets complexity requirements' do
        complex_password = 'Pa$$w0rd'
        user = build(:user, password: complex_password)
        expect(user).to be_valid
      end
    end
  end

  describe 'devise module' do
    it { should have_db_column(:encrypted_password) }
    it { should have_db_column(:reset_password_token) }
    it { should have_db_column(:remember_created_at) }
    it { should have_db_column(:sign_in_count) }
    it { should have_db_column(:current_sign_in_at) }
    it { should have_db_column(:last_sign_in_at) }
    it { should have_db_column(:current_sign_in_ip) }
    it { should have_db_column(:last_sign_in_ip) }
  end

  describe '.authenticate' do
    let(:user) { create(:user, password: 'Pa$$w0rd') }

    context 'with valid credentials' do
      it 'returns true' do
        expect(User.authenticate(user, 'Pa$$w0rd')).to be(true)
      end
    end

    context 'with invalid credentials' do
      it 'returns false' do
        expect(User.authenticate(user, 'wrong_password')).to be(false)
      end
    end

    context 'with nil user' do
      it 'returns false' do
        expect(User.authenticate(nil, 'Pa$$w0rd')).to be(nil)
      end
    end
  end
end
