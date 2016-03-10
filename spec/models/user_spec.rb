require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(first_name: 'Coconut', middle_name: nil, last_name: 'Jones') }

  describe 'validations' do
    describe '#first_name' do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_length_of(:first_name).with_maximum(50) }
    end
    describe '#last_name' do
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_length_of(:last_name).with_maximum(50) }
    end
    describe '#email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email) }
      it { is_expected.to validate_format_of(:email).to_allow('testing@email.com') }
    end
  end

  describe 'before_save callback' do
    subject { FactoryGirl.create(:user, email: 'USER@EMAIL.COM') }
    it 'downcases the entire email' do
      expect(subject.email).to eq('user@email.com')
    end
  end

  describe '#created_at / #updated_at' do
    subject { FactoryGirl.create(:user) }
    it { expect(subject.created_at).to be_present }
    it { expect(subject.updated_at).to be_present }
  end

  describe '#full_name' do
    context 'when middle name is not present' do
      it 'returns first and last names' do
        expect(subject.full_name).to eq('Coconut Jones')
      end
    end
    context 'when middle is present' do
      it 'returns first, middle, and last names' do
        subject.middle_name = 'T'
        expect(subject.full_name).to eq('Coconut T Jones')
      end
    end
  end
end
