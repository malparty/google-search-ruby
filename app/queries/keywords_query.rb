# frozen_string_literal: true

class KeywordsQuery
  QUERY_PARAMS = [:url_pattern, :keyword_pattern, { link_types: [] }].freeze

  attr_reader :keywords, :url_match_count

  def initialize(user)
    @user = user
    @keywords = user.keywords.select(Keyword.column_names.excluding('html'))
  end

  def call(params = {})
    @keyword_pattern = params[:keyword_pattern]
    @url_pattern = params[:url_pattern]
    @link_types = params[:link_types]

    where_name

    where_result_links

    order_by_name

    @url_match_count = result_links_filtered.count

    self
  end

  private

  attr_reader :user, :keyword_pattern, :url_pattern, :link_types

  def order_by_name
    @keywords = keywords.order(:name)
  end

  def where_name
    @keywords = keywords.where('name ~* ?', keyword_pattern) if keyword_pattern.present?
  end

  def where_result_links
    @keywords = keywords.where(result_links: result_links_filtered) if filter_on_result_link?
  end

  def result_links_filtered
    result_links = ResultLink.where(keyword: user.keywords)

    result_links = result_links.where('url ~* ?', url_pattern) if url_pattern.present?

    result_links = result_links.where(link_type: link_types) if link_types.present?

    result_links
  end

  def filter_on_result_link?
    url_pattern.present? || link_types.present?
  end
end
