# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index; end

  def create
    keyword = params['keyword']
    raw_response = GoogleService::ClientService.new(keyword).query_result

    if raw_response
      render :create, locals: {
        keyword: keyword,
        raw_response: raw_response
      }
      return
    end

    redirect_to keywords_path, alert: I18n.t('keywords.could_not_query')
  end
end
