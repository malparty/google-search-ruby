# frozen_string_literal: true

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    render locals: {
      keywords: pagy(KeywordsQuery.new(current_user).call)
    }
  end
end
