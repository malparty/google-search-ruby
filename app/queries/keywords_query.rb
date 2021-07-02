# frozen_string_literal: true

class KeywordsQuery
  def initialize(user)
    @keywords = user.keywords
  end

  def call
    order_by_name
  end

  private

  attr_reader :keywords

  def order_by_name
    keywords.order(:name)
  end
end
