# frozen_string_literal: true

module Google
  class SearchProgressJob < ApplicationJob
    queue_as :default

    def perform(user_id)
      user = User.find(user_id)

      raise ArgumentError unless user

      SearchProgressChannel.broadcast_to user, data: progress_data(user)
    end

    private

    def progress_data(user)
      {
        pending_count: user.keywords.pending.count,
        failed_count: user.keywords.failed.count
      }
    end
  end
end
