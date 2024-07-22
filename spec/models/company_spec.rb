# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { create(:company) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    describe 'name uniqueness' do
      subject { create(:company) }

      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:flights).dependent(:destroy) }
  end
end
