# frozen_string_literal: true

class KeywordsQuery
  attr_reader :keywords

  def initialize(user)
    @keywords = user.keywords
  end

  def call
    @keywords = order_by_name
  end

  private

  def order_by_name
    keywords.order(:name)
  end
end
