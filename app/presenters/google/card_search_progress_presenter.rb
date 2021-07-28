# frozen_string_literal: true

module Google
  class CardSearchProgressPresenter
    attr_reader :pending_count, :failed_count, :parsed_count

    def initialize(parsed_count:, failed_count:, pending_count:)
      @parsed_count = parsed_count
      @failed_count = failed_count
      @pending_count = pending_count
    end

    def percent_parsed
      (100.0 * parsed_count.to_f / total_count.to_f).to_i
    end

    def percent_failed
      (100.0 * failed_count.to_f / total_count.to_f).to_i
    end

    def total_count
      failed_count + pending_count + parsed_count
    end

    def local_time
      Time.zone.now.strftime('%H:%M:%S')
    end
  end
end
