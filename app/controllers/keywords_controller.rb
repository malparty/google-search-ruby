# frozen_string_literal: true

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    pagy, keywords_list = pagy(keywords)

    render locals: {
      pagy: pagy, keywords: KeywordsDecorator.new(keywords_list)
    }
  end

  private

  def keywords
    KeywordsQuery.new(current_user).call
  end
end
