# frozen_string_literal: true

module Google
  class DistributeSearchJob < ApplicationJob
    queue_as :default

    def perform(keywords)
      keywords.each do |keyword|
        SearchKeywordJob.perform_later(keyword)
      end
    end
  end
end
