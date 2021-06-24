# frozen_string_literal: true

class KeywordsDecorator
  def initialize(keywords)
    @keywords = keywords
  end

  def sections
    @keywords.group_by { |keyword| keyword.name[0].upcase.to_sym }
  end
end
