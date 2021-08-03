# frozen_string_literal: true

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    pagy, keywords_list = pagy(keywords_query.keywords_filtered)

    render locals: {
      pagy: pagy,
      presenter: KeywordsCollectionPresenter.new(keywords_list),
      url_match_count: keywords_query.url_match_count,
      filter: keywords_query.filter,
      csv_form: csv_form
    }
  end

  def create
    if save_csv_file
      Google::DistributeSearchJob.perform_later(csv_form.keyword_ids)

      flash[:success] = I18n.t('csv.upload_success')
    else
      flash[:errors] = csv_form.errors.full_messages
    end

    redirect_to keywords_path
  end

  def show
    keyword = Keyword.includes(:result_links).find show_params[:id]

    render locals: {
      presenter: KeywordPresenter.new(keyword)
    }
  end

  private

  def keywords_query
    @keywords_query ||= KeywordsQuery.new(current_user.keywords, index_params)
  end

  def csv_form
    @csv_form ||= CSVUploadForm.new(current_user)
  end

  def save_csv_file
    csv_form.save(create_params[:csv_upload_form][:file])
  end

  def index_params
    params.permit(Filter::QUERY_PARAMS)
  end

  def create_params
    params.permit(csv_upload_form: [:file])
  end

  def show_params
    params.permit(:id)
  end
end
