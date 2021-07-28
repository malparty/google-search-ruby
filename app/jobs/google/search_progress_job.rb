# frozen_string_literal: true

module Google
  class SearchProgressJob < ApplicationJob
    queue_as :default

    def perform(user_id)
      user = User.find(user_id)

      SearchProgressChannel.broadcast_replace_to "toast_search_progress_stream:user_#{user.id}",
                                                 target: 'toast_search_progress',
                                                 partial: 'keywords/toast_search_progress',
                                                 locals: { pending_count: user.keywords.pending.count }
    end
  end
end
