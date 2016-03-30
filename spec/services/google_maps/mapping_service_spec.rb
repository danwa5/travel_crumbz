require 'rails_helper'

RSpec.describe GoogleMaps::MappingService, type: :feature do
  let(:trip) { create(:trip, :with_user, :with_location) }

  before { make_google_maps_stub_request }

  describe '.call' do
    it 'must return an array of geocoded hashes' do
      address = [{:lat=>"12.34", :lng=>"-98.76", :marker_title=>"TITLE", :infowindow=>"ADDRESS"}]
      expect(Gmaps4rails).to receive(:build_markers).with(trip.locations).and_return(address)
      described_class.call(trip.locations)
    end
  end

  def make_google_maps_stub_request
    stub_request(:get, /maps.googleapis.com\/maps\/api\/geocode\/.+/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end
