# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  authorizable_type :string(255)
#  authorizable_id   :integer
#  created_at        :datetime
#  updated_at        :datetime
#  resource_type     :string(255)
#  resource_id       :integer
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  scopify
end
