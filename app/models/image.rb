# == Schema Information
#
# Table name: images
#
#  id                  :integer          not null, primary key
#  imageable_id        :integer
#  imageable_type      :string(255)
#  upload_file_name    :string(255)
#  upload_content_type :string(255)
#  upload_file_size    :integer
#  upload_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  alt_label           :string(255)
#

class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  validates :alt_label, length: { maximum: 255 }, allow_blank: true

  has_attached_file :upload

  validates_with AttachmentContentTypeValidator,
                 attributes: :upload,
                 content_type: ['image/jpeg', 'image/png', 'image/gif']

  validates_with AttachmentFileNameValidator,
                 attributes: :upload,
                 matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i]
end
