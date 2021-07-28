# frozen_string_literal: true

require 'rails_helper'

describe 'search progress notification', type: :system do
  context 'given a broadcast with 10 pending keywords' do
    it 'shows a search-progress notification' do
      user = sign_in_system Fabricate(:user)

      fabricate_keywords_to user, pending: 10

      perform_search_progress_job user.id

      expect(page).to have_selector('.card-search-progress')
    end

    it 'shows 10 keywords left' do
      user = sign_in_system Fabricate(:user)

      fabricate_keywords_to user, pending: 10

      perform_search_progress_job user.id

      expect(find('.card-search-progress--keywords-left')).to have_content("10 #{I18n.t('keywords.keywords_left')}")
    end

    it 'shows a 0% parsed progress bar' do
      user = sign_in_system Fabricate(:user)

      fabricate_keywords_to user, pending: 10

      perform_search_progress_job user.id

      expect(page).to have_selector('.card-search-progress--progress-bar-parsed[style="width: 0%"]', visible: :all)
    end

    it 'shows a 0% failed progress bar' do
      user = sign_in_system Fabricate(:user)

      fabricate_keywords_to user, pending: 10

      perform_search_progress_job user.id

      expect(page).to have_selector('.card-search-progress--progress-bar-failed[style="width: 0%"]', visible: :all)
    end
  end

  context 'given a broadcast with 5 parsed and 1 failed and 4 pending keywords' do
    it 'shows 4 keywords left' do
      user = sign_in_system Fabricate(:user)

      fabricate_keywords_to user, parsed: 5, failed: 1, pending: 4

      perform_search_progress_job user.id

      expect(find('.card-search-progress--keywords-left')).to have_content("4 #{I18n.t('keywords.keywords_left')}")
    end

    it 'shows a 50% parsed progress bar' do
      user = sign_in_system Fabricate(:user)

      fabricate_keywords_to user, parsed: 5, failed: 1, pending: 4

      perform_search_progress_job user.id

      expect(page).to have_selector('.card-search-progress--progress-bar-parsed[style="width: 50%"]', visible: :all)
    end

    it 'shows a 10% failed progress bar' do
      user = sign_in_system Fabricate(:user)

      fabricate_keywords_to user, parsed: 5, failed: 1, pending: 4

      perform_search_progress_job user.id

      expect(page).to have_selector('.card-search-progress--progress-bar-failed[style="width: 10%"]', visible: :all)
    end
  end

  context 'when a notification is sent to another user', authenticated_user: true do
    it 'does not display a search-progress notification' do
      another_user = Fabricate(:user)

      fabricate_keywords_to another_user, parsed: 1, failed: 1, pending: 1

      perform_search_progress_job another_user.id

      expect(page).not_to have_selector('.card-search-progress')
    end
  end
end
