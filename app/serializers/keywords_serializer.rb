# frozen_string_literal: true

class KeywordsSerializer
  include JSONAPI::Serializer

  attributes :name, :created_at, :status, :ads_top_count, :ads_page_count, :non_ads_result_count, :total_link_count
end
