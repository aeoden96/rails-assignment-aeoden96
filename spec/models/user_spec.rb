# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  first_name :string           not null
#  last_name  :string
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  user_params = { first_name: 'Marko', email: 'marko@gmail.com' }

  let(:user) { described_class.new(user_params) }

  describe 'validations' do
    it 'all attributes are valid' do
      expect(user).to be_valid
    end

    it 'is not valid with a first name less than 2 characters' do
      user.first_name = 'J'
      expect(user).not_to be_valid
    end

    describe 'email' do
      it 'is duplicated' do
        described_class.create!(user_params)
        expect(user).not_to be_valid
      end

      it 'is not valid with an invalid email' do
        email = 'some_text'
        user.email = email
        expect(user).not_to be_valid
      end

      it 'is not valid with an an invalid email' do
        email = 'text@.com'
        user.email = email
        expect(user).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:bookings).dependent(:destroy) }
    it { is_expected.to have_many(:flights).through(:bookings) }
  end
end
