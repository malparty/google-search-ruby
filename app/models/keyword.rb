# frozen_string_literal: true

class Keyword < ApplicationRecord
  include Discard::Model

  validates :name, presence: true, length: { maximum: 255 }

  belongs_to :user, inverse_of: :keywords

  default_scope -> { kept }
end
