# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user, inverse_of: :keywords
end
