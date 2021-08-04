# frozen_string_literal: true

class KeywordsCollectionPresenter
  def initialize(keywords)
    @keywords = keywords
  end

  def keyword_groups
    keywords.group_by { |keyword| keyword.name[0].upcase.to_sym }
  end

  private

  attr_reader :keywords
end
