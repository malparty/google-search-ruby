# frozen_string_literal: true

require 'rails_helper'

describe 'keywords list', type: :system do
  context 'given no keywords' do
    it 'shows the empty_list message' do
      sign_in Fabricate(:user)

      visit root_path

      expect(find('.list-keyword')).to have_content(I18n.t('keywords.empty_list'))
    end

    it 'does not show the pagination nav' do
      sign_in Fabricate(:user)

      visit root_path

      expect(find('.list-keyword')).not_to have_selector('.pagination')
    end

    it 'does not show any keyword' do
      sign_in Fabricate(:user)

      visit root_path

      expect(find('.list-keyword')).not_to have_selector('.list-keyword-item')
    end
  end

  context 'given more keywords than what a page can contain' do
    it 'shows exactly 1 page of keywords' do
      user = sign_in Fabricate(:user)

      Fabricate.times(Pagy::VARS[:items] + 1, :keyword, user: user)

      visit root_path

      expect(page).to have_selector('.list-keyword-item', count: Pagy::VARS[:items])
    end

    it 'shows an enabled pagination nav next button' do
      user = sign_in Fabricate(:user)

      Fabricate.times(Pagy::VARS[:items] + 1, :keyword, user: user)

      visit root_path

      expect(find('.list-keyword')).to have_selector('li.page-item.next:not(.disabled)', count: 1)
    end
  end

  context 'given exactly 1 full page of keywords' do
    it 'shows exactly the max number of keywords one page can contain' do
      user = sign_in Fabricate(:user)

      Fabricate.times(Pagy::VARS[:items], :keyword, user: user)

      visit root_path

      expect(page).to have_selector('.list-keyword-item', count: Pagy::VARS[:items])
    end

    it 'shows a disabled pagination nav next button' do
      user = sign_in Fabricate(:user)

      Fabricate.times(Pagy::VARS[:items], :keyword, user: user)

      visit root_path

      expect(find('.list-keyword')).to have_selector('li.page-item.next.disabled', count: 1)
    end
  end
end
