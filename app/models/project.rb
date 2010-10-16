class Project < ActiveRecord::Base
  has_many :releases
  validates_format_of :code, :with => /^[a-zA-Z_]+$/
end
