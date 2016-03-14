class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  geocoded_by :formatted_address

  field :formatted_address, type: String
  field :street_address, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String
  field :postal_code, type: String
  field :latitude, type: String
  field :longitude, type: String

  VALID_COORDINATE_REGEX = /\A-?\d+(\.\d+)?\z/i

  validates :formatted_address, presence: true, uniqueness: { case_sensitive: false }
  validates :country, presence: true
  validates :latitude, presence: true, format: { with: VALID_COORDINATE_REGEX }
  validates :longitude, presence: true, format: { with: VALID_COORDINATE_REGEX }

  def coordinates
    [latitude, longitude]
  end
end
