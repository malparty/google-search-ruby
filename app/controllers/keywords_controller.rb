# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index; end

  def create
    keyword = params['keyword']
    raw_response = GoogleService::ClientService.query(keyword)

    render :create, locals: {
      keyword: keyword,
      raw_response: raw_response
    }
  end
end
