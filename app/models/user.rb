class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :trips, class_name: 'Trip'

  field :username, type: String
  field :first_name, type: String
  field :middle_name, type: String
  field :last_name, type: String
  field :email, type: String

  VALID_USERNAME_REGEX = /\A[a-z0-9_\-]{2,20}\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { within: (2..20) },
                       format: { with: VALID_USERNAME_REGEX }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  before_save do
    self.email = email.downcase
  end

  def full_name
    if middle_name.present?
      "#{first_name} #{middle_name} #{last_name}"
    else
      "#{first_name} #{last_name}"
    end
  end
end
