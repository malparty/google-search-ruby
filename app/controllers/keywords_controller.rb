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

  def create
    if csv_form.save(create_params)
      redirect_to :keywords_path, notice: I18n.t('csv.upload_success')
    else
    redirect_to :keywords_path, alert: csv_form.errors.full_messages
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
end
