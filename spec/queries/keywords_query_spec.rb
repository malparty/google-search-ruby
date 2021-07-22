# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsQuery, type: :query do
  context 'given no param' do
    context 'given a user with no keywords' do
      it 'returns an empty collection' do
        result = described_class.new(Fabricate(:user)).call

        expect(result.keywords).to be_empty
      end
    end

    context 'given a user with 3 keywords' do
      it 'returns exactly 3 keywords' do
        user = Fabricate(:user)
        Fabricate.times(3, :keyword, user: user)

        result = described_class.new(user).call

        expect(result.keywords.length).to eq(3)
      end

      it 'orders the result by name ascending' do
        user = Fabricate(:user)

        %w[World awesome Pool].each { |name| Fabricate(:keyword, user: user, name: name) }

        result = described_class.new(user).call

        expect(result.keywords.map(&:name)).to eq(%w[awesome Pool World])
      end
    end

    context 'given many users with keywords' do
      it 'returns only keywords from the initialized user' do
        users = Fabricate.times(2, :user)
        Fabricate.times(10, :keyword, user: users[0])
        Fabricate.times(15, :keyword, user: users[1])

        result = described_class.new(users[0]).call

        expect(result.keywords.map(&:user_id)).to all(eq(users[0].id))
      end

      it 'only counts url matches from the initialized user' do
        users = Fabricate.times(2, :user)
        Fabricate.times(10, :keyword_parsed_with_links, user: users[0])
        Fabricate.times(15, :keyword_parsed_with_links, user: users[1])

        result = described_class.new(users[0]).call({ url_pattern: '.*' })

        expect(result.url_match_count).to eq(users[0].keywords.sum { |keyword| keyword.result_links.count })
      end
    end
  end

  context 'given a keyword_pattern' do
    context 'given a name as keyword_pattern' do
      it 'returns only keywords matching exactly that name' do
        user = Fabricate(:user)

        %w[World awesome Pool].each { |name| Fabricate(:keyword, user: user, name: name) }

        result = described_class.new(user).call({ keyword_pattern: 'awesome' })

        expect(result.keywords.map(&:name)).to eq(%w[awesome])
      end

      it 'matches results in a case insensitive way' do
        user = Fabricate(:user)

        %w[World awesome Pool].each { |name| Fabricate(:keyword, user: user, name: name) }

        result = described_class.new(user).call({ keyword_pattern: 'pooL' })

        expect(result.keywords.map(&:name)).to eq(%w[Pool])
      end
    end

    context 'given an expression as keyword_pattern' do
      it 'returns only keywords matching the given pattern' do
        user = Fabricate(:user)

        %w[World awesome Pool Zipline Zoo].each { |name| Fabricate(:keyword, user: user, name: name) }

        result = described_class.new(user).call({ keyword_pattern: '.*o.*' })

        expect(result.keywords.map(&:name)).to eq(%w[awesome Pool World Zoo])
      end
    end
  end

  context 'given a url_pattern' do
    context 'given a simple url_pattern' do
      it 'returns only keywords having any result_link with that url' do
        keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[4]

        keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

        result = described_class.new(keyword.user).call({ url_pattern: 'https://beautiful-table.com/zaxs' })

        expect(result.keywords.map(&:name)).to eq([keyword.name])
      end
    end

    context 'given an expression as url_pattern' do
      it 'returns only keywords having any result_link whose url matches that pattern' do
        keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[4]

        keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

        result = described_class.new(keyword.user).call({ url_pattern: '[htps]+:\/{2}[a-z-]+.com\/zaxs' })

        expect(result.keywords.map(&:name)).to eq([keyword.name])
      end

      it 'counts the right url matches' do
        keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[4]

        keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

        result = described_class.new(keyword.user).call({ url_pattern: '[htps]+:\/{2}[a-z-]+.com\/zaxs' })

        expect(result.url_match_count).to eq(1)
      end
    end
  end

  context 'given both url and keyword patterns' do
    it 'returns exactly the right keywords' do
      keyword = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user))[3]

      keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs')

      keyword.update(name: 'world')

      result = described_class.new(keyword.user).call({ keyword_pattern: 'WOR.+', url_pattern: '[htps]+:\/{2}[a-z-]+.com\/zaxs' })

      expect(result.keywords.map(&:name)).to eq([keyword.name])
    end

    it 'can return more than one result' do
      keywords = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user), name: 'world')

      keywords.take(2).each { |keyword| keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs') }

      result = described_class.new(keywords[0].user).call({ keyword_pattern: 'WOR.+', url_pattern: '[htps]+:\/{2}[a-z-]+.com\/zaxs' })

      expect(result.keywords.map(&:name)).to eq(%w[world world])
    end

    it 'counts the right url matches' do
      keywords = Fabricate.times(10, :keyword_parsed_with_links, user: Fabricate(:user), name: 'world')

      keywords.take(2).each { |keyword| keyword.result_links[0].update(url: 'https://beautiful-table.com/zaxs') }

      result = described_class.new(keywords[0].user).call({ keyword_pattern: 'WOR.+', url_pattern: '[htps]+:\/{2}[a-z-]+.com\/zaxs' })

      expect(result.url_match_count).to eq(2)
    end
  end

  context 'given a unique link_type' do
    it 'counts only url with this link_type' do
      user = Fabricate(:user)

      Fabricate.times(5, :keyword_parsed, user: user).each { |keyword| Fabricate(:result_link, keyword: keyword, link_type: :ads_top) }
      Fabricate.times(10, :keyword_parsed, user: user).each { |keyword| Fabricate(:result_link, keyword: keyword, link_type: :non_ads) }

      result = described_class.new(user).call({ link_types: [:ads_top] })

      expect(result.url_match_count).to eq(5)
    end

    it 'returns only keywords having at least 1 result_link matching the link_type' do
      user = Fabricate(:user)

      Fabricate.times(5, :keyword_parsed, user: user).each { |keyword| Fabricate(:result_link, keyword: keyword, link_type: :ads_top) }
      Fabricate.times(10, :keyword_parsed, user: user).each { |keyword| Fabricate(:result_link, keyword: keyword, link_type: :non_ads) }

      result = described_class.new(user).call({ link_types: [:ads_top] })

      expect(result.keywords.length).to eq(5)
    end
  end

  context 'given 2 link_types' do
    it 'counts url with these link_types' do
      keyword = Fabricate(:keyword_parsed)

      Fabricate.times(10, :result_link_with_keyword, keyword: keyword, link_type: %i[ads_top non_ads].sample)

      result = described_class.new(keyword.user).call({ link_types: %i[ads_top non_ads] })

      expect(result.url_match_count).to eq(10)
    end

    it 'does not counts url with a different link_type' do
      keyword = Fabricate(:keyword_parsed)

      Fabricate.times(10, :result_link_with_keyword, keyword: keyword, link_type: %i[ads_top non_ads].sample)
      Fabricate.times(5, :result_link_with_keyword, keyword: keyword, link_type: :ads_page)

      result = described_class.new(keyword.user).call({ link_types: %i[ads_top non_ads] })

      expect(result.url_match_count).to eq(10)
    end

    it 'returns only the keyword having at least 1 result_link matching the link_type' do
      keyword = Fabricate(:keyword_parsed)

      Fabricate.times(5, :result_link_with_keyword, keyword: keyword, link_type: %i[ads_top non_ads].sample)
      Fabricate.times(5, :result_link_with_keyword, keyword: Fabricate(:keyword_parsed), link_type: :ads_page)

      result = described_class.new(keyword.user).call({ link_types: %i[ads_top non_ads] })

      expect(result.keywords.length).to eq(1)
    end
  end
end
