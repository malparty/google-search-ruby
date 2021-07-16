# frozen_string_literal: true

module SearchProgressHelpers
  module System
    def perform_search_progress_job(user_id)
      visit root_path

      sleep 0.5.seconds # active jobs are not retried by capybara, so we need to wait for client subscription...

      Google::SearchProgressJob.perform_now user_id

      sleep 0.5.seconds # ...and for notification reception
    end

    def fabricate_keywords_to(user, pending: 0, parsed: 0, failed: 0)
      Fabricate.times(pending, :keyword, user: user)
      Fabricate.times(failed, :keyword, user: user, status: :failed)
      Fabricate.times(parsed, :keyword, user: user, status: :parsed)
    end
  end
end
