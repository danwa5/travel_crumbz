require 'rails_helper'

RSpec.describe Trip, type: :model do
  it 'has a valid factory' do
    expect(build(:trip, :with_user)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:users) }
    it { is_expected.to embed_many(:locations) }
    it { is_expected.to accept_nested_attributes_for(:locations) }
  end

  describe 'fields' do
    it { is_expected.to have_fields(:name) }
    it { is_expected.to be_timestamped_document }
  end

  describe 'validations' do
    describe '#name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_ids) }
    end
    describe '#user_ids' do
      it { is_expected.to validate_presence_of(:user_ids) }
    end
  end

  describe '#created_at / #updated_at' do
    subject { FactoryGirl.create(:user) }
    it { expect(subject.created_at).to be_present }
    it { expect(subject.updated_at).to be_present }
  end
end
