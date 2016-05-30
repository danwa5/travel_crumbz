require 'rails_helper'

RSpec.describe 'SearchForm', type: :feature do
  subject { page }

  before do
    visit discover_path
    google_map_stub_request
  end

  describe 'class methods' do
    it { expect(SearchForm.model_name.name).to eq('SearchForm') }
  end

  describe 'GET /discover' do
    let(:location_1) { build(:location, city: 'Copenhagen', country: 'Denmark') }
    let(:location_2) { build(:location, city: 'Byron Bay', country: 'Australia') }

    before do
      create(:trip, :with_user, name: 'Scandinavia', locations: [location_1])
      create(:trip, :with_user, name: 'Beaches', locations: [location_2])
      create(:trip, :with_user, name: 'Europe', locations: [location_1])
    end

    it 'must return all trips that contain search phrase' do
      find('#keywords').set('copenhagen')
      click_button 'SEARCH'
      expect(current_path).to eq(discover_path)
      expect(page).to have_selector('div.post-title h2', text: 'Scandinavia')
      expect(page).to have_selector('div.post-title h2', text: 'Europe')
      expect(page).not_to have_selector('div.post-title h2', text: 'Australia')
    end
  end

  def google_map_stub_request
    stub_request(:get, /.*maps.googleapis.com\/maps.*/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end