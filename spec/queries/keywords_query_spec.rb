# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsQuery, type: :query do
  context 'given no param' do
    context 'given a user with no keywords' do
      it 'returns an empty collection' do
        query = described_class.new(Fabricate(:user).keywords)

        expect(query.keywords_filtered).to be_empty
      end
    end

    context 'given a user with 3 keywords' do
      it 'returns exactly 3 keywords' do
        user = Fabricate(:user)
        Fabricate.times(3, :keyword, user: user)

        query = described_class.new(user.keywords)

        expect(query.keywords_filtered.length).to eq(3)
      end

      it 'orders the query by name ascending' do
        user = Fabricate(:user)

        %w[World awesome Pool].each { |name| Fabricate(:keyword, user: user, name: name) }

        query = described_class.new(user.keywords)

        expect(query.keywords_filtered.map(&:name)).to eq(%w[awesome Pool World])
      end
    end

    context 'given many users with keywords' do
      it 'returns only keywords from the authenticated user' do
        users = Fabricate.times(2, :user)
        Fabricate.times(10, :keyword, user: users[0])
        Fabricate.times(15, :keyword, user: users[1])

        query = described_class.new(users[0].keywords)

        expect(query.keywords_filtered.map(&:user_id)).to all(eq(users[0].id))
      end

      it 'counts only the URL matches for the authenticated user' do
        users = Fabricate.times(2, :user)
        Fabricate.times(10, :keyword_parsed_with_links, user: users[0])
        Fabricate.times(15, :keyword_parsed_with_links, user: users[1])

        query = described_class.new(users[0].keywords, { url_pattern: '.*' })

        expect(query.url_match_count).to eq(users[0].keywords.sum { |keyword| keyword.result_links.count })
      end
    end
  end

  context 'given a keyword_pattern' do
    context 'given a name as keyword_pattern' do
      it 'returns only keywords matching exactly that name' do
        user = Fabricate(:user)

        %w[World awesome Pool].each { |name| Fabricate(:keyword, user: user, name: name) }

        query = described_class.new(user.keywords, { keyword_pattern: 'awesome' })

        expect(query.keywords_filtered.map(&:name)).to eq(%w[awesome])
      end

      it 'matches queries in a case insensitive way' do
        user = Fabricate(:user)

        %w[World awesome Pool].each { |name| Fabricate(:keyword, user: user, name: name) }

        query = described_class.new(user.keywords, { keyword_pattern: 'pooL' })

        expect(query.keywords_filtered.map(&:name)).to eq(%w[Pool])
      end
    end

    context 'given an expression as keyword_pattern' do
      it 'returns only keywords matching the given pattern' do
        user = Fabricate(:user)

        %w[World awesome Pool Zipline Zoo].each { |name| Fabricate(:keyword, user: user, name: name) }

        query = described_class.new(user.keywords, { keyword_pattern: 'o{2}' })

        expect(query.keywords_filtered.map(&:name)).to eq(%w[Pool Zoo])
      end
    end
  end

  context 'given a url_pattern' do
    context 'given a simple url_pattern' do
      it 'returns only keywords having any result_link with that url' do
        keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[4]

        keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

        query = described_class.new(keyword.user.keywords, { url_pattern: 'https://beautiful-table.com/zaxs' })

        expect(query.keywords_filtered.map(&:name)).to eq([keyword.name])
      end
    end

    context 'given an expression as url_pattern' do
      it 'returns only keywords having any result_link whose URL matches that pattern' do
        keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[4]

        keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

        query = described_class.new(keyword.user.keywords, { url_pattern: '.com\/zaxs$' })

        expect(query.keywords_filtered.map(&:name)).to eq([keyword.name])
      end

      it 'counts the right URL matches' do
        keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[4]

        keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

        query = described_class.new(keyword.user.keywords, { url_pattern: '.com\/zaxs$' })

        expect(query.url_match_count).to eq(1)
      end

      it 'has no error' do
        keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[4]

        keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

        query = described_class.new(keyword.user.keywords, { url_pattern: '.com\/zaxs$' })

        expect(query.filter.error_message).to be_blank
      end
    end
  end

  context 'given both URL and keyword patterns' do
    it 'returns exactly the right keywords' do
      keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[3]

      keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

      keyword.update(name: 'world')

      query = described_class.new(keyword.user.keywords, { keyword_pattern: 'WOR.+', url_pattern: '.com\/zaxs$' })

      expect(query.keywords_filtered.map(&:name)).to eq([keyword.name])
    end

    it 'can return more than one result' do
      keywords = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user), name: 'world')

      keywords.take(2).each { |keyword| keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs') }

      query = described_class.new(keywords[0].user.keywords, { keyword_pattern: 'WOR.+', url_pattern: '.com\/zaxs$' })

      expect(query.keywords_filtered.map(&:name)).to eq(%w[world world])
    end

    it 'counts the right URL matches' do
      keywords = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user), name: 'world')

      keywords.take(2).each { |keyword| keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs') }

      query = described_class.new(keywords[0].user.keywords, { keyword_pattern: 'WOR.+', url_pattern: '.com\/zaxs$' })

      expect(query.url_match_count).to eq(2)
    end
  end

  context 'given a unique link_type' do
    it 'counts only URLs with this link_type' do
      user = Fabricate(:user)

      Fabricate.times(5, :keyword_parsed, user: user).each { |keyword| Fabricate(:result_link, keyword: keyword, link_type: :ads_top) }
      Fabricate.times(10, :keyword_parsed, user: user).each { |keyword| Fabricate(:result_link, keyword: keyword, link_type: :non_ads) }

      query = described_class.new(user.keywords, { link_types: [ResultLink.link_types[:ads_top].to_s] })

      expect(query.url_match_count).to eq(5)
    end

    it 'returns only keywords having at least 1 result_link matching the link_type' do
      user = Fabricate(:user)

      Fabricate.times(5, :keyword_parsed, user: user).each { |keyword| Fabricate(:result_link, keyword: keyword, link_type: :ads_top) }
      Fabricate.times(10, :keyword_parsed, user: user).each { |keyword| Fabricate(:result_link, keyword: keyword, link_type: :non_ads) }

      query = described_class.new(user.keywords, { link_types: [ResultLink.link_types[:ads_top].to_s] })

      expect(query.keywords_filtered.length).to eq(5)
    end
  end

  context 'given 2 link_types' do
    it 'counts url with these link_types' do
      keyword = Fabricate(:keyword_parsed)

      Fabricate.times(10, :result_link_with_keyword, keyword: keyword, link_type: %i[ads_top non_ads].sample)

      query = described_class.new(keyword.user.keywords, { link_types: [ResultLink.link_types[:ads_top].to_s, ResultLink.link_types[:non_ads].to_s] })

      expect(query.url_match_count).to eq(10)
    end

    it 'does not count URL with a different link_type' do
      keyword = Fabricate(:keyword_parsed)

      Fabricate.times(10, :result_link_with_keyword, keyword: keyword, link_type: %i[ads_top non_ads].sample)
      Fabricate.times(5, :result_link_with_keyword, keyword: keyword, link_type: :ads_page)

      query = described_class.new(keyword.user.keywords, { link_types: [ResultLink.link_types[:ads_top].to_s, ResultLink.link_types[:non_ads].to_s] })

      expect(query.url_match_count).to eq(10)
    end

    it 'returns only the keyword having at least 1 result_link matching the link_type' do
      keyword = Fabricate(:keyword_parsed)

      Fabricate.times(5, :result_link_with_keyword, keyword: keyword, link_type: %i[ads_top non_ads].sample)
      Fabricate.times(5, :result_link_with_keyword, keyword: Fabricate(:keyword_parsed), link_type: :ads_page)

      query = described_class.new(keyword.user.keywords, { link_types: [ResultLink.link_types[:ads_top].to_s, ResultLink.link_types[:non_ads].to_s] })

      expect(query.keywords_filtered.length).to eq(1)
    end
  end

  context 'given a bad regular expression as param' do
    it 'returns an empty list of keywords' do
      user = Fabricate(:user)

      Fabricate.times(10, :keyword, user: user)

      query = described_class.new(user.keywords, { url_pattern: '?', keyword_pattern: '?' })

      expect(query.keywords_filtered.length).to be_zero
    end

    it 'returns 0 as url_match_count' do
      user = Fabricate(:user)

      Fabricate.times(10, :keyword, user: user)

      query = described_class.new(user.keywords, { url_pattern: '?', keyword_pattern: '?' })

      expect(query.url_match_count).to be_zero
    end

    it 'has an error message' do
      user = Fabricate(:user)

      Fabricate.times(10, :keyword, user: user)

      query = described_class.new(user.keywords, { url_pattern: '?', keyword_pattern: '?' })

      query.keywords_filtered

      expect(query.filter.error_message).to be_present
    end
  end
end
