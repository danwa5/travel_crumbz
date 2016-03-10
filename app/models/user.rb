class User
  include Mongoid::Document

  field :last_name, type: String
  field :first_name, type: String
  field :email, type: String

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  def name
    first_name + ' ' + last_name
  end
end
