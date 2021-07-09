# frozen_string_literal: true

module API
  module V1
    class KeywordsController < ApplicationController
      include ::Pagy::Backend
      include API::V1::Pagy::JSONAPIConcern

      def index
        pagy, keywords_list = pagy(keywords)

        render json: KeywordsSerializer.new(keywords_list, pagy_options(pagy))
      end

      def show
        keyword = current_user.keywords.find show_params[:id]

        render json: KeywordSerializer.new(keyword, include: [:result_links])
      end

      def create
        if csv_form.save(create_params[:file])
          render json: create_success_response
        else
          render_errors(
            details: csv_form.errors.full_messages,
            code: :invalid_file,
            status: :unprocessable_entity
          )
        end
      end

      private

      def keywords
        KeywordsQuery.new(current_user).call
      end

      def csv_form
        @csv_form ||= CSVUploadForm.new(current_user)
      end

      def create_params
        params.permit(:file)
      end

      def create_success_response
        {
          meta: I18n.t('csv.upload_success')
        }
      end

      def show_params
        params.permit(:id)
      end
    end
  end
end
