# frozen_string_literal: true

class Keyword < ApplicationRecord
  include Discard::Model

  validates :name, presence: true, length: { maximum: 255 }
  validates :user, presence: true, unless: :bulk_insert?

  belongs_to :user, inverse_of: :keywords, optional: true

  default_scope -> { kept }

  attr_accessor :bulk_insert

  # disable validations generating SQL queries for bulk insert
  def bulk_insert?
    bulk_insert
  end
end
