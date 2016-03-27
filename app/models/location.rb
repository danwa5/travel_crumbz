class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  geocoded_by :address do |loc, results|
    if result = results.first
      dm = DataMappers::Geocoder.new(result.data).mapped
      loc.full_address   = dm['full_address']
      loc.street_number  = dm['street_number']
      loc.route          = dm['route']
      loc.city           = dm['city']
      loc.state_province = dm['state_province']
      loc.country        = dm['country']
      loc.postal_code    = dm['postal_code']
      loc.coordinates    = result.coordinates.reverse
    end
  end

  after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }

  embedded_in :trip

  field :address, type: String
  field :full_address, type: String
  field :street_number, type: String
  field :route, type: String
  field :city, type: String
  field :state_province, type: String
  field :country, type: String
  field :postal_code, type: String
  field :coordinates, type: Array
  field :order, type: Integer

  validates :address, presence: true
  validates :order, uniqueness: true

  default_scope -> { order_by(order: :asc) }

  def latitude
    coordinates[-1].to_s if coordinates.present?
  end

  def longitude
    coordinates[0].to_s if coordinates.present?
  end
end
