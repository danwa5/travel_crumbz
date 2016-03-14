require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user, first_name: 'Coconut', middle_name: nil, last_name: 'Jones') }

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:trips) }
  end

  describe 'fields' do
    it { is_expected.to have_fields(:username, :first_name, :middle_name, :last_name, :email) }
    it { is_expected.to be_timestamped_document }
  end

  describe 'validations' do
    describe '#username' do
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
      it { is_expected.to validate_length_of(:username).within(2..20) }
      it { is_expected.to validate_format_of(:username).to_allow('a1_-') }
    end
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
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
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
