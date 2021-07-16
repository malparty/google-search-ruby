# frozen_string_literal: true

module Google
  class DistributeSearchJob < ApplicationJob
    queue_as :default

    def perform(keyword_ids)
      keyword_ids.each do |keyword_id|
        SearchKeywordJob.perform_later(keyword_id)
      end
    end
  end
end
