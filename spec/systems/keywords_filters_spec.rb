# frozen_string_literal: true

require 'rails_helper'

describe 'keywords filters', type: :system do
  context 'given no filters' do
    it 'shows the matched keywords count' do
      user = Fabricate(:user)

      Fabricate.times(5, :keyword, user: user)

      sign_in user

      visit root_path

      expect(find('.match-counts--keywords')).to have_content(5)
    end

    it 'shows the matched result_links count' do
      keyword = Fabricate(:keyword)

      Fabricate.times(5, :result_link, keyword: keyword)

      sign_in keyword.user

      visit root_path

      expect(find('.match-counts--urls')).to have_content(5)
    end

    it 'has a filter form', authenticated_user: true do
      visit root_path

      expect(page).to have_selector('.form-filters')
    end

    it 'has a keyword_pattern input', authenticated_user: true do
      visit root_path

      expect(find('.form-filters')).to have_selector('input[name=keyword_pattern]')
    end

    it 'has a url_pattern input', authenticated_user: true do
      visit root_path

      expect(find('.form-filters')).to have_selector('input[name=url_pattern]')
    end

    it 'has all the link_types checkboxes', authenticated_user: true do
      visit root_path

      expect(find('.form-filters')).to have_selector('input[type=checkbox][name=link_types\[\]]', count: ResultLink.link_types.length)
    end

    it 'has a submit button', authenticated_user: true do
      visit root_path

      expect(find('.form-filters button[type=submit]')).to have_content(I18n.t('filters.submit_btn'))
    end
  end

  context 'given a keyword_pattern param' do
    it 'displays the matched keywords' do
      user = Fabricate(:user)

      matched_keyword = Fabricate(:keyword, user: user, name: 'Construction')
      Fabricate(:keyword, user: user, name: 'castor')

      submit_keyword_filters(user, { keyword_pattern: '^co' })

      expect(find('.list-keyword')).to have_content(matched_keyword.name)
    end

    it 'does NOT display the unmatched keywords' do
      user = Fabricate(:user)

      Fabricate(:keyword, user: user, name: 'Construction')
      unmatched_keyword = Fabricate(:keyword, user: user, name: 'castor')

      submit_keyword_filters(user, { keyword_pattern: '^co' })

      expect(find('.list-keyword')).not_to have_content(unmatched_keyword.name)
    end
  end

  context 'given a url_pattern param' do
    it 'displays the matched keywords' do
      matched_keyword = Fabricate(:keyword, name: 'Construction')

      Fabricate(:result_link, keyword: matched_keyword, url: 'www3.new-web.world')
      Fabricate(:keyword_parsed_with_links, user: matched_keyword.user, name: 'castor')

      submit_keyword_filters(matched_keyword.user, { url_pattern: '^www3.' })

      expect(find('.list-keyword')).to have_content(matched_keyword.name)
    end

    it 'does NOT display the unmatched keywords' do
      unmatched_keyword = Fabricate(:keyword, name: 'Construction')

      Fabricate(:result_link, keyword: unmatched_keyword, url: 'www3.new-web.world')
      Fabricate(:keyword_parsed_with_links, user: unmatched_keyword.user, name: 'castor')

      submit_keyword_filters(unmatched_keyword.user, { url_pattern: '^http' })

      expect(find('.list-keyword')).not_to have_content(unmatched_keyword.name)
    end
  end

  context 'given a link_types param' do
    it 'displays the matched keywords' do
      user = Fabricate(:user)

      matched_keyword = Fabricate(:result_link, keyword: Fabricate(:keyword_parsed, user: user), link_type: :ads_top).keyword
      Fabricate(:result_link, keyword: Fabricate(:keyword_parsed, user: user), link_type: :non_ads)

      submit_keyword_filters(user, { link_types: [ResultLink.link_types[:ads_top]] })

      expect(find('.list-keyword')).to have_content(matched_keyword.name)
    end

    it 'does NOT display the unmatched keywords' do
      user = Fabricate(:user)

      Fabricate(:result_link, keyword: Fabricate(:keyword_parsed, user: user), link_type: :ads_top)
      unmatched_keyword = Fabricate(:result_link, keyword: Fabricate(:keyword_parsed, user: user), link_type: :non_ads).keyword

      submit_keyword_filters(user, { link_types: [ResultLink.link_types[:ads_top]] })

      expect(find('.list-keyword')).not_to have_content(unmatched_keyword.name)
    end
  end

  context 'given filters with no match' do
    it 'shows the keywords.empty_list message' do
      user = Fabricate(:user)

      Fabricate(:keyword, user: user, name: 'hello')
      Fabricate(:keyword, user: user, name: 'world')

      submit_keyword_filters(user, { keyword_pattern: 'no_match' })

      expect(find('.list-keyword')).to have_content(I18n.t('keywords.empty_list'))
    end
  end
end
