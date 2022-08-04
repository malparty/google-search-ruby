# frozen_string_literal: true

class KeywordsQuery
  attr_reader :filter

  def initialize(relation, filter_params = {})
    @relation = relation
    @filter = Filter.from_params(filter_params)
  end

  def keywords_filtered
    return Keyword.none unless filter.valid?

    scope = without_html_column(relation)

    scope = filter_by_name(scope) if filter.keyword_pattern.present?
    scope = filter_by_result_links(scope) if filter.result_link_filter_exist?

    order_by_name(scope)
  end

  def url_match_count
    return 0 unless filter.valid?

    result_links_filtered.count
  end

  private

  attr_reader :relation

  def without_html_column(scope)
    scope.select(Keyword.column_names.excluding('html'))
  end

  def order_by_name(scope)
    scope.order(:name)
  end

  def filter_by_name(scope)
    scope.where('name ~* ?', filter.keyword_pattern)
  end

  def filter_by_result_links(scope)
    scope.where(result_links: result_links_filtered)
  end

  def result_links_filtered
    result_links = ResultLink.where(keyword: relation)
    result_links = result_links.where('url ~* ?', filter.url_pattern) if filter.url_pattern.present?
    result_links = result_links.where(link_type: filter.link_types) if filter.link_types.present?

    result_links
  end
end
