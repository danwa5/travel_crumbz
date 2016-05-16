class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_secure_password

  has_and_belongs_to_many :trips, class_name: 'Trip'

  field :username, type: String
  field :first_name, type: String
  field :middle_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password, type: String
  field :password_digest, type: String
  field :remember_token, type: String
  field :email_confirmed, type: Boolean, default: false
  field :confirm_token, type: String

  VALID_USERNAME_REGEX = /\A[a-zA-Z\d]{2,20}\z/
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
  validates :password, length: { maximum: 72 }

  before_save do
    self.username = username.downcase
    self.email = email.downcase
  end

  before_create :create_remember_token, :create_confirm_token

  class << self
    def new_secure_token
      SecureRandom.urlsafe_base64
    end

    def encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end
  end

  def to_param
    username
  end

  def full_name
    if middle_name.present?
      "#{first_name} #{middle_name} #{last_name}"
    else
      "#{first_name} #{last_name}"
    end
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def grid_photos
    photos = []
    if trips.present?
      my_photos = trips.map { |t| t.photos }.flatten
      my_photos.each { |photo| photos << photo.original_file.medium.url }
    end

    random_arr = (photos.count < 12) ? (1..12).to_a.sample(12 - photos.count) : []
    if random_arr.any?
      random_arr.each do |index|
        photos << "/featured/#{index}.jpg"
      end
    end
    photos.sample(12)
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_secure_token)
  end

  def create_confirm_token
    self.confirm_token = User.new_secure_token if self.confirm_token.blank?
  end
end
