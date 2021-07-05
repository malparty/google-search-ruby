# frozen_string_literal: true

class ResultLink < ApplicationRecord
  belongs_to :keyword, inverse_of: :result_links

  enum link_type: { ads_top: 0, ads_page: 1, non_ads: 2 }

  validates :url, presence: true, allow_blank: false
  validates :keyword, presence: true
end
