# frozen_string_literal: true

module KeywordFiltersHelpers
  module System
    def submit_keyword_filters(user, params = {})
      sign_in user

      visit root_path

      fill_in :filter_keyword_pattern, with: params[:keyword_pattern]
      fill_in :filter_url_pattern, with: params[:url_pattern]

      params[:link_types]&.each { |link_type| check "filter_link_types_#{link_type}" }

      click_button I18n.t('filters.submit_btn')
    end
  end
end
