class Content < ActiveRecord::Base
  has_many :photos
  has_one :audio
end
