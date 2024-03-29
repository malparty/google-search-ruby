# frozen_string_literal: true

module API
  module V1
    class KeywordsController < ApplicationController
      include ::Pagy::Backend
      include API::V1::Pagy::JSONAPIConcern

      def index
        pagy, keywords_list = pagy(keywords_query.keywords_filtered)

        options = pagy_options(pagy)

        options[:meta] = options[:meta].merge(url_match_count: keywords_query.url_match_count)

        render json: KeywordSerializer.new(keywords_list, options)
      end

      def show
        keyword = current_user.keywords.find show_params[:id]

        render json: KeywordSerializer.new(keyword, include: [:result_links], params: { show: true })
      end

      def create
        if csv_form.save(create_params[:file])
          Google::DistributeSearchJob.perform_later(csv_form.keyword_ids)

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

      def keywords_query
        @keywords_query ||= KeywordsQuery.new(current_user.keywords, index_params)
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

      def index_params
        params.permit(Filter::QUERY_PARAMS)
      end

      def show_params
        params.permit(:id)
      end
    end
  end
end
