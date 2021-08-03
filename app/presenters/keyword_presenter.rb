# frozen_string_literal: true

class KeywordPresenter
  attr_reader :keyword

  def initialize(keyword)
    @keyword = keyword
  end

  def result_link_types
    keyword.result_links.group_by(&:link_type)
  end

  def created_at_date
    keyword.created_at.strftime '%F'
  end

  def created_at_time
    keyword.created_at.strftime '%T'
  end

  def url_title(url)
    result = url.sub(%r{https?://(www.)?}, '').split('/')[0]

    return result if result.present?

    'google.com'
  end

  def google_link
    "https://google.com/search?q=#{keyword.name}"
  end

  def result_link_type_icon(link_type)
    case link_type
    when :ads_top
      'bi bi-file-earmark-arrow-up-fill'
    when :ads_page
      'bi bi-file-earmark-break-fill'
    when :non_ads
      'bi bi-file-check'
    else
      'bi bi-file-earmark-text'
    end
  end

  def status_icon
    case keyword.status.to_sym
    when :pending
      'bi bi-hourglass-split text-warning'
    when :parsed
      'bi bi-check-lg text-success'
    else
      'bi bi-bug text-danger'
    end
  end

  def ads_top_count
    keyword.ads_top_count || 0
  end

  def ads_page_count
    keyword.ads_page_count || 0
  end

  def non_ads_result_count
    keyword.non_ads_result_count || 0
  end

  def total_link_count
    keyword.total_link_count || 0
  end
end
