# frozen_string_literal: true

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    pagy, keywords = pagy(KeywordsQuery.new(current_user).call)

    render locals: {
      pagy: pagy, keywords: keywords
    }
  end
end
