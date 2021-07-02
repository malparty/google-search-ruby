# frozen_string_literal: true

module API
  module V1
    class KeywordsController < ApplicationController
      include ::Pagy::Backend
      include API::V1::Pagy::JSONAPIConcern

      def index
        pagy, keywords_list = pagy(keywords)

        if keywords.any?
          render json: KeywordSerializer.new(keywords_list, pagy_options(pagy)).serializable_hash, status: :ok
        else
          render_empty
        end
      end

      private

      def render_empty
        render json: { meta: I18n.t('keywords.empty_list'), data: [] }, status: :ok
      end

      def keywords
        KeywordsQuery.new(current_user).call
      end
    end
  end
end
