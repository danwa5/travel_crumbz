class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :original_file, PhotoUploader

  embedded_in :trip

  before_save :generate_checksum

  field :original_file, type: String
  field :caption, type: String
  field :checksum, type: String

  validates_uniqueness_of :checksum, scope: :trip

  private

  def generate_checksum
    if original_file.present? && original_file_changed?
      self.checksum = original_file.checksum
    end
  end
end
