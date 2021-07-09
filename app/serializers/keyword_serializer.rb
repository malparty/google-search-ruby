# frozen_string_literal: true

class KeywordSerializer < KeywordsSerializer
  attribute :html

  has_many :result_links
end
