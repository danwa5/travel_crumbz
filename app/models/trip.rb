class Trip
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  has_and_belongs_to_many :users, class_name: 'User'
  embeds_many :locations, cascade_callbacks: true
  embeds_many :photos

  after_save :save_locations_list

  accepts_nested_attributes_for :locations, :allow_destroy => true

  field :name, type: String
  field :start_date, type: Date
  field :end_date, type: Date
  field :likes, type: Integer, default: 0
  field :locations_list, type: String
  slug :name

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_ids }
  validates :user_ids, presence: true

  scope :most_recent, -> { order_by(created_at: :desc) }

  def dates
    if start_date.present? && end_date.present?
      "#{format_date(start_date)} - #{format_date(end_date)}"
    else
      format_date(start_date)
    end
  end

  def format_date(date)
    date.present? ? date.strftime('%-m.%-d.%Y') : ''
  end

  def users_list
    users.map { |u| u.username }.join(', ')
  end

  def cover(large=false)
    if large == true
      photos.any? ? photos.first.original_file.url : "/featured/#{rand(1..16)}_large.jpg"
    else
      photos.any? ? photos.first.original_file.scaled.url : "/featured/#{rand(1..16)}.jpg"
    end
  end

  private

  def save_locations_list
    value = locations.map { |loc| loc.address }.join(' &raquo; ').html_safe
    self.class.find(self.id).set(locations_list: value)
  end
end
