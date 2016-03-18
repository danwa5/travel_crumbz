class Trip
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  has_and_belongs_to_many :users, class_name: 'User'
  embeds_many :locations

  accepts_nested_attributes_for :locations, :allow_destroy => true

  field :name, type: String
  slug :name

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_ids }
  validates :user_ids, presence: true
end
