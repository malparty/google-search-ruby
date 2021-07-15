# frozen_string_literal: true

class KeywordSerializer
  include JSONAPI::Serializer

  attributes :name, :created_at, :status, :ads_top_count, :ads_page_count, :non_ads_result_count, :total_link_count

  attribute :html, if: proc { |_, params| params[:show] }

  has_many :result_links, if: proc { |_, params| params[:show] }
end
