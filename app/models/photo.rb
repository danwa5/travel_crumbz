class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  # attr_accessible :original_file, :original_file_cache

  mount_uploader :original_file, PhotoUploader#, mount_on: :original_file_filename

  embedded_in :trip

  field :original_file, type: String
  field :caption, type: String
end
