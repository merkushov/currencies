class Currency < ApplicationRecord
  validates :code, :name, presence: true
end
