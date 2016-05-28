require 'rails_helper'

RSpec.describe Trip, type: :model do
  let(:trip) { create(:trip, :with_user, name: 'Round the World, Part 1') }
  subject { trip }

  it 'has a valid factory' do
    expect(build(:trip, :with_user)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:users) }
    it { is_expected.to embed_many(:locations) }
    it { is_expected.to accept_nested_attributes_for(:locations) }
    it { is_expected.to embed_many(:photos) }
  end

  describe 'fields' do
    it { is_expected.to have_fields(:name) }
    it { is_expected.to have_fields(:likes) }
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

  describe 'scopes' do
    xdescribe '#most_recent' do
    end
  end

  describe '#users_str' do
    let(:user_1) { create(:user, username: 'sara') }
    let(:user_2) { create(:user, username: 'samo') }
    let(:trip) { create(:trip, user_ids: [user_1.id, user_2.id]) }
    it 'returns a comma-delimited string of users full names' do
      expect(trip.users_str).to eq('sara, samoo')
    end
  end

  describe '#created_at / #updated_at' do
    it { expect(subject.created_at).to be_present }
    it { expect(subject.updated_at).to be_present }
  end
end
