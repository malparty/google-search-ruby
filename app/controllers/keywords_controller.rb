# frozen_string_literal: true

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    pagy, keywords_list = pagy(keywords)

    render locals: {
      pagy: pagy, keywords: KeywordsCollectionPresenter.new(keywords_list),
      csv_form: csv_form
    }
  end

  def show
    render locals: {
      keyword: current_user.keywords.find(show_params[:id])
    }
  end

  def create
    if csv_form.save(create_params[:csv_upload_form][:file])
      flash[:success] = I18n.t('csv.upload_success')
    else
      flash[:errors] = csv_form.errors.full_messages
    end

    redirect_to keywords_path
  end

  private

  def keywords
    KeywordsQuery.new(current_user).call
  end

  def csv_form
    @csv_form ||= CSVUploadForm.new(current_user)
  end

  def create_params
    params.permit(csv_upload_form: [:file])
  end

  def show_params
    params.permit(:id)
  end
end
