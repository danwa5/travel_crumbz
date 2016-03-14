require 'rails_helper'

RSpec.describe Location, type: :model do
  subject { build(:location) }

  it 'has a valid factory' do
    expect(build(:location)).to be_valid
  end

  describe 'fields' do
    it { is_expected.to have_fields(:formatted_address, :street_address, :city, :state, :country, :postal_code, :latitude, :longitude) }
    it { is_expected.to be_timestamped_document }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:formatted_address) }
    it { is_expected.to validate_uniqueness_of(:formatted_address).case_insensitive }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_format_of(:latitude).to_allow('-12.34') }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_format_of(:longitude).to_allow('5') }
  end

  describe '#coordinates' do
    it 'returns an array of latitude and longitude' do
      expect(subject.coordinates).to eq([subject.latitude, subject.longitude])
    end
  end
end
