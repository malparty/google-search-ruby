# frozen_string_literal: true

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    pagy, keywords = pagy(keywords)

    render locals: {
      pagy: pagy, keywords: keywords
    }
  end

  private

  def keywords
    KeywordsQuery.new(current_user).call
  end

end
