# frozen_string_literal: true

class PreviewController < ApplicationController
  def index
    keyword = Keyword.find(index_params[:keyword_id])

    render layout: false, locals: {
      keyword: keyword
    }
  end

  private

  def index_params
    params.permit(:keyword_id)
  end
end
