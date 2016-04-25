require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'associations' do
    it { is_expected.to be_embedded_in(:trip) }
  end

  describe 'fields' do
    it { is_expected.to have_fields(:original_file, :caption) }
    it { is_expected.to be_timestamped_document }
  end
end
