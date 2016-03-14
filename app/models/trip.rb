class Trip
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :users, class_name: 'User'
  has_and_belongs_to_many :locations

  field :name, type: String

  validates :user_ids, presence: true
end
