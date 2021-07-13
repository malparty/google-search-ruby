# frozen_string_literal: true

module Google
  class ClientServiceError < StandardError; end

  class SearchKeywordJob < ApplicationJob
    queue_as :default

    retry_on ClientServiceError, ArgumentError

    def perform(keyword)
      html_result = ClientService.new(keyword: keyword.name).call

      raise ClientServiceError unless html_result

      update_keyword keyword.id, ParserService.new(html_response: html_result).call
    rescue ClientServiceError, ArgumentError => e
      job_failed keyword.id

      raise e
    end

    private

    def job_failed(keyword_id)
      Keyword.update keyword_id, status: :failed
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
