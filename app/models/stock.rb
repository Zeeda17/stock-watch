class Stock < ApplicationRecord
  validates :name, presence: true
end
