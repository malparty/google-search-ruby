# frozen_string_literal: true

module Google
  class ClientServiceError < StandardError; end

  class SearchKeywordJob < ApplicationJob
    queue_as :default

    def perform(keyword_id)
      keyword = Keyword.find keyword_id

      return unless keyword

      html_result = ClientService.new(keyword: keyword.name).call

      raise ClientServiceError unless html_result

      update_keyword keyword, ParserService.new(html_response: html_result).call
    rescue ActiveRecord::RecordNotFound, ClientServiceError, ArgumentError
      update_keyword_status keyword, :failed

      raise
    ensure
      SearchProgressJob.perform_now keyword.user_id
    end

    private

    def update_keyword_status(keyword, status)
      keyword.update! status: status
    end

    def update_keyword(keyword, attributes)
      Keyword.transaction do
        # rubocop:disable Rails/SkipsModelValidations
        keyword.result_links.insert_all attributes[:result_links]
        # rubocop:enable Rails/SkipsModelValidations

        keyword.update! attributes.except(:result_links)
      end
    end
  end
end
