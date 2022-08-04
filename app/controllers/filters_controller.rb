# frozen_string_literal: true

class FiltersController < ApplicationController
  def index
    render locals: {
      keywords_count: current_user.keywords.count,
      filter: Filter.from_params(index_params)
    }
  end

  private

  def index_params
    params.permit(Filter::QUERY_PARAMS)
  end
end
