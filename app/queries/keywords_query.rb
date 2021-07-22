# frozen_string_literal: true

class KeywordsQuery
  QUERY_PARAMS = %i[url_pattern keyword_pattern].freeze

  attr_reader :keywords, :url_match_count

  def initialize(user)
    @user = user
    @keywords = user.keywords.select(Keyword.column_names.excluding('html'))
  end

  def call(params = {})
    @keyword_pattern = params[:keyword_pattern]
    @url_pattern = params[:url_pattern]

    where_keyword_pattern

    where_url_pattern

    order_by_name

    @url_match_count = result_links_where_url_pattern.count

    self
  end

  private

  attr_reader :user, :keyword_pattern, :url_pattern

  def order_by_name
    @keywords = keywords.order(:name)
  end

  def where_keyword_pattern
    @keywords = keywords.where('name ~* ?', keyword_pattern) if keyword_pattern.present?
  end

  def where_url_pattern
    @keywords = keywords.where(result_links: result_links_where_url_pattern) if url_pattern.present?
  end

  def result_links_where_url_pattern
    ResultLink.where(keyword: user.keywords).where('url ~* ?', url_pattern)
  end
end
