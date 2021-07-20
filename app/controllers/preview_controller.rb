# frozen_string_literal: true

class PreviewController < ApplicationController
  def show
    keyword = Keyword.find(show_params[:id])

    render partial: 'show', locals: {
      keyword: keyword
    }
  end

  private

  def show_params
    params.permit :id
  end
end
