class Play < ActiveRecord::Base
  belongs_to :playwright
  belongs_to :category
  validates :name, :genre, :synopsis, presence: true
end
