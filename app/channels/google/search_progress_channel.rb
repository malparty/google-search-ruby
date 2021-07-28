# frozen_string_literal: true

module Google
  class SearchProgressChannel < ApplicationCable::Channel
    def subscribed
      stream_for current_user
    end
  end
end
