# frozen_string_literal: true

module API
  module V1
    class KeywordsController < ApplicationController
      include ::Pagy::Backend
      include API::V1::Pagy::JSONAPIConcern

      def index
        pagy, keywords_list = pagy(keywords)

        render json: KeywordSerializer.new(keywords_list, pagy_options(pagy))
      end

      private

      def keywords
        KeywordsQuery.new(current_user).call
      end
    end
  end
end