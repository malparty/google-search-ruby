# frozen_string_literal: true

class FiltersController < ApplicationController
  def index
    render locals: {
      keywords_count: current_user.keywords.count
    }
  end
end
