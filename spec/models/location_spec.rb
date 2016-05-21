require 'rails_helper'

RSpec.describe Location, type: :model do
  subject { build(:location) }

  before { make_google_maps_stub_request }

  it 'has a valid factory' do
    expect(build(:location)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to be_embedded_in(:trip) }
  end

  describe 'fields' do
    it { is_expected.to have_fields(:address, :full_address, :street_number, :route, :city, :state_province, :country, :postal_code, :order) }
    it { is_expected.to have_field(:coordinates).of_type(Array) }
    it { is_expected.to be_timestamped_document }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_uniqueness_of(:order) }
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

  describe '#label' do
    it 'returns the order and address' do
      expect(subject.label).to eq(subject.order.to_s + '. ' + subject.address)
    end
  end

  def make_google_maps_stub_request
    stub_request(:get, /maps.googleapis.com\/maps\/api\/geocode\/.+/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end
