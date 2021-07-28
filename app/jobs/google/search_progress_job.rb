# frozen_string_literal: true

module Google
  class SearchProgressJob < ApplicationJob
    queue_as :default

    def perform(user_id)
      user = User.find(user_id)

      SearchProgressChannel.broadcast_append_to "card_search_progress_stream:user_#{user.id}",
                                                target: 'card_search_progress',
                                                partial: 'keywords/card_search_progress',
                                                locals: { presenter: presenter(user.keywords) }
    end

    private

    def presenter(keywords)
      Google::CardSearchProgressPresenter.new(
        parsed_count: keywords.parsed.where('updated_at > ?', 12.hours.ago).count,
        failed_count: keywords.failed.count,
        pending_count: keywords.pending.count
      )
    end
  end
end
