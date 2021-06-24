# frozen_string_literal: true

class KeywordsQuery
  attr_reader :keywords

  def initialize(user)
    @keywords = user.keywords
  end

  def call
    @keywords = order
  end

  private

  def order
    keywords.order(:name)
  end
end
