# frozen_string_literal: true

class KeywordsPresenter
  def initialize(keywords)
    @keywords = keywords
  end

  def groups
    @keywords.group_by { |keyword| keyword.name[0].upcase.to_sym }
  end
end
