class Competition < ActiveRecord::Base
  has_many :entries, inverse_of: :competition

  validates_presence_of :name

  scope :recent_first, -> { order(created_at: :desc) }
end
