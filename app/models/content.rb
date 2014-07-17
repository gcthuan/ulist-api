class Content < ActiveRecord::Base
  has_many :photos
  has_one :audio
  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :audio
end
