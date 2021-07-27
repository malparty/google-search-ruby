# frozen_string_literal: true

class KeywordsQuery
  QUERY_PARAMS = [:url_pattern, :keyword_pattern, { link_types: [] }].freeze

  def initialize(relation, filters = {})
    @relation = relation

    @keyword_pattern = filters[:keyword_pattern]
    @url_pattern = filters[:url_pattern]
    @link_types = filters[:link_types]&.reject(&:empty?)
  end

  def keywords_filtered
    scope = without_html_column(relation)

    scope = filter_by_name(scope) if keyword_pattern.present?
    scope = filter_by_result_links(scope) if result_link_filter_exist?

    order_by_name(scope)
  end

  def url_match_count
    result_links_filtered.count
  end

  private

  attr_reader :relation, :keyword_pattern, :url_pattern, :link_types

  def without_html_column(scope)
    scope.select(Keyword.column_names.excluding('html'))
  end

  def order_by_name(scope)
    scope.order(:name)
  end

  def filter_by_name(scope)
    scope.where('name ~* ?', keyword_pattern)
  end

  def filter_by_result_links(scope)
    scope.where(result_links: result_links_filtered)
  end

  def result_links_filtered
    result_links = ResultLink.where(keyword: relation)
    result_links = result_links.where('url ~* ?', url_pattern) if url_pattern.present?
    result_links = result_links.where(link_type: link_types) if link_types.present?

    result_links
  end

  def result_link_filter_exist?
    url_pattern.present? || link_types.present?
  end
end
