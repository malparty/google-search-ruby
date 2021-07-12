# frozen_string_literal: true

class Keyword < ApplicationRecord
  include Discard::Model

  validates :name, presence: true, length: { maximum: 255 }

  belongs_to :user, inverse_of: :keywords

  has_many :result_links, inverse_of: :keyword, dependent: :destroy

  default_scope -> { kept }

  enum status: { pending: 0, parsed: 1, failed: 2 }
end
