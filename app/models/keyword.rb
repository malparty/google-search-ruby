# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }

  belongs_to :user, inverse_of: :keywords
end
