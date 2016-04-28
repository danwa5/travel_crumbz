require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'associations' do
    it { is_expected.to be_embedded_in(:trip) }
  end

  describe 'fields' do
    it { is_expected.to have_fields(:original_file, :caption, :checksum) }
    it { is_expected.to be_timestamped_document }
  end

  describe 'validations' do
    describe '#checksum' do
      it { is_expected.to validate_uniqueness_of(:checksum).scoped_to(:trip) }
    end
  end
end
