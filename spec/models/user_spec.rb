require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(first_name: 'Coconut', last_name: 'Jones') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_format_of(:email).to_allow('testing@email.com') }
  end

  describe '#name' do
    it 'returns first and last names' do
      expect(subject.name).to eq('Coconut Jones')
    end
  end
end
