# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  first_name      :string           not null
#  last_name       :string
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  token           :string
#  role            :string
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }

    describe 'email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to allow_value('a@a.com').for(:email) }
      it { is_expected.not_to allow_value('a@a').for(:email) }
      it { is_expected.not_to allow_value('a.com').for(:email) }
    end

    describe 'email uniqueness' do
      subject { create(:user) }

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:bookings).dependent(:destroy) }
    it { is_expected.to have_many(:flights).through(:bookings) }
  end
end
