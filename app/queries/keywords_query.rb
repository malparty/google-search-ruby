# frozen_string_literal: true

class KeywordsQuery
  QUERY_PARAMS = %i[url_pattern keyword_pattern].freeze

  def initialize(user)
    @keywords = user.keywords.select(Keyword.column_names.excluding('html'))
  end

  def call(params = {})
    where_keyword_pattern params[:keyword_pattern] if params[:keyword_pattern].present?

    where_url_pattern params[:url_pattern] if params[:url_pattern].present?

    order_by_name
  end

  private

  attr_reader :keywords

  def order_by_name
    @keywords = keywords.order(:name)
  end

  def where_keyword_pattern(pattern)
    @keywords = keywords.where('name ~* ?', pattern)
  end

  def where_url_pattern(pattern)
    @keywords = keywords.where(result_links: ResultLink.where('url ~* ?', pattern))
  end
end
