class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  geocoded_by :address

  reverse_geocoded_by :coordinates do |object,results|
    if geo = results.first
      object.street_number  = geo.street_number
      object.route          = geo.route
      object.city           = geo.city
      object.state_province = geo.state
      object.country        = geo.country
      object.postal_code    = geo.postal_code
    end
  end

  after_validation :geocode, :reverse_geocode, :if => lambda{ |obj| obj.address_changed? }

  embedded_in :trip

  field :address, type: String
  field :street_number, type: String
  field :route, type: String
  field :city, type: String
  field :state_province, type: String
  field :country, type: String
  field :postal_code, type: String
  field :coordinates, :type => Array

  validates :address, presence: true

  def latitude
    coordinates[-1].to_s if coordinates.present?
  end

  def longitude
    coordinates[0].to_s if coordinates.present?
  end
end
