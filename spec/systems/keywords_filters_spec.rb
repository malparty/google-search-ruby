# frozen_string_literal: true

require 'rails_helper'

describe 'keywords filters', type: :system do
  context 'given no filters' do
    it 'shows the matched keywords count' do
      user = Fabricate(:user)

      Fabricate.times(5, :keyword, user: user)

      sign_in user

      visit root_path

      expect(find('.match-count--keyword')).to have_content(5)
    end

    it 'shows the matched result_links count' do
      keyword = Fabricate(:keyword)

      Fabricate.times(5, :result_link, keyword: keyword)

      sign_in keyword.user

      visit root_path

      expect(find('.match-count--url')).to have_content(5)
    end

    it 'has a filter form', authenticated_user: true do
      visit root_path

      expect(page).to have_selector('.form-filter')
    end

    it 'has a keyword_pattern input', authenticated_user: true do
      visit root_path

      expect(find('.form-filter')).to have_selector('input[name=filter\[keyword_pattern\]]')
    end

    it 'has a url_pattern input', authenticated_user: true do
      visit root_path

      expect(find('.form-filter')).to have_selector('input[name=filter\[url_pattern\]]')
    end

    it 'has all the link_types checkboxes', authenticated_user: true do
      visit root_path

      expect(find('.form-filter')).to have_selector('input[type=checkbox][name=filter\[link_types\]\[\]]', count: ResultLink.link_types.length)
    end

    it 'has a submit button', authenticated_user: true do
      visit root_path

      expect(find('.form-filter button[type=submit]')).to have_content(I18n.t('filters.submit_btn'))
    end

    it 'does NOT have any error message', authenticated_user: true do
      visit root_path

      expect(find('.list-keyword')).not_to have_selector('.alert-danger')
    end
  end

  context 'given a keyword_pattern param' do
    it 'shows the matched keywords' do
      user = Fabricate(:user)

      matched_keyword = Fabricate(:keyword, user: user, name: 'construction')
      Fabricate(:keyword, user: user, name: 'castor')

      submit_keyword_filters(user, { keyword_pattern: 'co' })

      expect(find('.list-keyword')).to have_content(matched_keyword.name)
    end

    it 'does NOT show the unmatched keywords' do
      user = Fabricate(:user)

      Fabricate(:keyword, user: user, name: 'construction')
      unmatched_keyword = Fabricate(:keyword, user: user, name: 'castor')

      submit_keyword_filters(user, { keyword_pattern: 'co' })

      expect(find('.list-keyword')).not_to have_content(unmatched_keyword.name)
    end

    it 'does NOT have any error message' do
      user = Fabricate(:user)

      Fabricate(:keyword, user: user, name: 'construction')
      Fabricate(:keyword, user: user, name: 'castor')

      submit_keyword_filters(user, { keyword_pattern: 'co' })

      expect(find('.list-keyword')).not_to have_selector('.alert-danger')
    end
  end

  context 'given an url_pattern param' do
    it 'shows the matched keywords' do
      matched_keyword = Fabricate(:keyword, name: 'Construction')

      Fabricate(:result_link, keyword: matched_keyword, url: 'www3.new-web.world')
      Fabricate(:keyword_parsed_with_links, user: matched_keyword.user, name: 'castor')

      submit_keyword_filters(matched_keyword.user, { url_pattern: '^www3' })

      expect(find('.list-keyword')).to have_content(matched_keyword.name)
    end

    it 'does NOT show the unmatched keywords' do
      unmatched_keyword = Fabricate(:keyword, name: 'Construction')

      Fabricate(:result_link, keyword: unmatched_keyword, url: 'www3.new-web.world')
      Fabricate(:keyword_parsed_with_links, user: unmatched_keyword.user, name: 'castor')

      submit_keyword_filters(unmatched_keyword.user, { url_pattern: '^http' })

      expect(find('.list-keyword')).not_to have_content(unmatched_keyword.name)
    end
  end

  context 'given a link_types param' do
    it 'shows the matched keywords' do
      user = Fabricate(:user)

      matched_keyword = Fabricate(:result_link, keyword: Fabricate(:keyword_parsed, user: user), link_type: :ads_top).keyword
      Fabricate(:result_link, keyword: Fabricate(:keyword_parsed, user: user), link_type: :non_ads)

      submit_keyword_filters(user, { link_types: [ResultLink.link_types[:ads_top]] })

      expect(find('.list-keyword')).to have_content(matched_keyword.name)
    end

    it 'does NOT show the unmatched keywords' do
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

  context 'given invalid keyword_pattern' do
    it 'does NOT show any keyword' do
      keyword = Fabricate(:keyword, name: 'construction')

      submit_keyword_filters(keyword.user, { keyword_pattern: '?' })

      expect(find('.list-keyword')).not_to have_content(keyword.name)
    end

    it 'shows a danger alert with the "Keyword pattern is invalid" message' do
      keyword = Fabricate(:keyword, name: 'construction')

      submit_keyword_filters(keyword.user, { keyword_pattern: '?' })

      expect(find('.list-keyword')).to have_content('Keyword pattern is invalid')
    end
  end

  context 'given invalid url_pattern' do
    it 'does NOT show any keyword' do
      result_link = Fabricate(:result_link_with_keyword)

      submit_keyword_filters(result_link.keyword.user, { url_pattern: '?' })

      expect(find('.list-keyword')).not_to have_content(result_link.keyword.name)
    end

    it 'shows a danger alert with the "Url pattern is invalid" message' do
      result_link = Fabricate(:result_link_with_keyword)

      submit_keyword_filters(result_link.keyword.user, { url_pattern: '?' })

      expect(find('.list-keyword')).to have_content('Url pattern is invalid')
    end
  end

  context 'given a URL with filter params' do
    it 'shows the matched keyword' do
      matched_keyword = Fabricate(:keyword, name: 'hello')
      Fabricate(:keyword, name: 'world', user: matched_keyword.user)

      sign_in matched_keyword.user

      visit root_path(filter: { keyword_pattern: '^hel' })

      expect(find('.list-keyword')).to have_content(matched_keyword.name)
    end

    it 'does NOT show the unmatched keyword' do
      unmatched_keyword = Fabricate(:keyword, name: 'hello')
      Fabricate(:keyword, name: 'world', user: unmatched_keyword.user)

      sign_in unmatched_keyword.user

      visit root_path(filter: { keyword_pattern: '^wor' })

      expect(find('.list-keyword')).not_to have_content(unmatched_keyword.name)
    end

    it 'fills keyword_pattern in', authenticated_user: true do
      visit root_path(filter: { keyword_pattern: '^hel' })

      expect(find('.form-filter')).to have_field('filter[keyword_pattern]', with: '^hel')
    end

    it 'fills url_pattern in', authenticated_user: true do
      visit root_path(filter: { url_pattern: '^https' })

      expect(find('.form-filter')).to have_field('filter[url_pattern]', with: '^https')
    end

    it 'fills link_types in', authenticated_user: true do
      visit root_path(filter: { link_types: %w[1] })

      expect(find('.form-filter #filter_link_types_1')).to be_checked
    end
  end
end
