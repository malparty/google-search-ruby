# frozen_string_literal: true

module Google
  class ClientServiceError < StandardError; end

  class SearchKeywordJob < ApplicationJob
    queue_as :default

    retry_on ClientServiceError, ArgumentError, wait: 12.seconds

    def perform(keyword_id)
      keyword = Keyword.where(id: keyword_id).select(:id, :name, :user_id).take

      return unless keyword

      html_result = ClientService.new(keyword: keyword.name).call

      raise ClientServiceError unless html_result

      update_keyword keyword_id, ParserService.new(html_response: html_result).call
    rescue ActiveRecord::RecordNotFound, ClientServiceError, ArgumentError
      update_keyword_status keyword_id, :failed

      raise
    end

    private

    def update_keyword_status(keyword_id, status)
      Keyword.update keyword_id, status: status
    end

    def update_keyword(keyword_id, attributes)
      Keyword.transaction do
        # rubocop:disable Rails/SkipsModelValidations
        Keyword.find(keyword_id).result_links.insert_all attributes[:result_links]
        # rubocop:enable Rails/SkipsModelValidations

        Keyword.update keyword_id, attributes.except(:result_links)
      end
    end
  end
end
