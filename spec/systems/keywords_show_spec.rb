# frozen_string_literal: true

require 'rails_helper'

describe 'keywords#show', type: :system do
  context 'given a valid id' do
    it 'shows the keyword name' do
      user = sign_in_system Fabricate(:user)

      keyword = Fabricate(:keyword_parsed_with_links, user: user)

      visit keyword_path({ id: keyword.id })

      expect(find('.keyword-card--title')).to have_content(keyword.name)
    end

    it 'shows the keyword status' do
      user = sign_in_system Fabricate(:user)

      keyword = Fabricate(:keyword_parsed_with_links, user: user)

      visit keyword_path({ id: keyword.id })

      expect(find('.keyword-card--status')).to have_content(I18n.t("keywords.status.#{keyword.status}"))
    end

    it 'shows all the result_links' do
      user = sign_in_system Fabricate(:user)

      keyword = Fabricate(:keyword_parsed_with_links, user: user)

      visit keyword_path({ id: keyword.id })

      expect(find('.keyword-card')).to have_selector('.keyword-card--result-link', count: keyword.result_links.length)
    end
  end

  context 'given an invalid id' do
    it 'renders a custom 404 message', authenticated_user: true do
      visit keyword_path({ id: 0 })

      expect(page).to have_content(I18n.t('not_found.text')).and(have_content(I18n.t('not_found.title')))
    end
  end
end
