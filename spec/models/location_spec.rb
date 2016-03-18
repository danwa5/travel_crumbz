require 'rails_helper'

RSpec.describe Location, type: :model do
  subject { build(:location) }

  it 'has a valid factory' do
    expect(build(:location)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to be_embedded_in(:trip) }
  end

  describe 'fields' do
    it { is_expected.to have_fields(:address, :street_number, :route, :city, :state_province, :country, :postal_code) }
    it { is_expected.to have_field(:coordinates).of_type(Array) }
    it { is_expected.to be_timestamped_document }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:address) }
  end

  describe '#latitude' do
    it 'returns the second coordinate in #coordinates' do
      expect(subject.latitude).to eq(subject.coordinates[-1])
    end
  end

  describe '#longitude' do
    it 'returns the first coordinate in #coordinates' do
      expect(subject.longitude).to eq(subject.coordinates[0])
    end
  end
end
