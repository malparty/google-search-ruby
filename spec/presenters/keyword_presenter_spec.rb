# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordPresenter, type: :presenter do
  describe '#result_link_types' do
    it 'returns a list grouped by link_types' do
      presenter = described_class.new(Fabricate(:keyword_parsed_with_links))

      expect(presenter.result_link_types.map { |link_type| link_type[0] }).to all(be_in(ResultLink.link_types.keys))
    end

    it 'returns a list with all result_links' do
      presenter = described_class.new(Fabricate(:keyword_parsed_with_links))

      result_links_list = presenter.result_link_types.map { |link_type| link_type[1] }.flatten.count

      expect(result_links_list).to eq(presenter.keyword.result_links.length)
    end
  end

  describe '#created_at_date' do
    it 'returns a formatted date' do
      presenter = described_class.new(Fabricate(:keyword_parsed_with_links, created_at: Time.zone.local(2021, 6, 1)))

      expect(presenter.created_at_date).to eq('2021-06-01')
    end
  end

  describe '#created_at_time' do
    it 'returns a formatted time' do
      presenter = described_class.new(Fabricate(:keyword_parsed_with_links, created_at: Time.zone.local(2021, 6, 1, 22, 45, 15)))

      expect(presenter.created_at_time).to eq('22:45:15')
    end
  end

  describe '#url_title' do
    it 'returns domains only for a basic url' do
      presenter = described_class.new(Fabricate(:keyword))

      expect(presenter.url_title('https://my-domain.com/a_path?some_variable=null')).to eq('my-domain.com')
    end

    it 'returns the sub domain and domain for a sub-domain url' do
      presenter = described_class.new(Fabricate(:keyword))

      expect(presenter.url_title('https://sub-domain.my-domain.com/a_path?some_variable=null')).to eq('sub-domain.my-domain.com')
    end

    it 'does not return www' do
      presenter = described_class.new(Fabricate(:keyword))

      expect(presenter.url_title('https://www.sub-domain.my-domain.com/a_path?some_variable=null')).to eq('sub-domain.my-domain.com')
    end

    it 'returns google.com for relative urls' do
      presenter = described_class.new(Fabricate(:keyword))

      expect(presenter.url_title('/a_path?some_variable=null')).to eq('google.com')
    end
  end

  describe '#ads_top_count' do
    it 'returns the keyword ads_top_count' do
      presenter = described_class.new(Fabricate(:keyword_parsed_with_links))

      expect(presenter.ads_top_count).to eq(presenter.keyword.ads_top_count)
    end

    it 'returns 0 when ads_top_count is nil' do
      presenter = described_class.new(Fabricate(:keyword))

      expect(presenter.ads_top_count).to be_zero
    end
  end

  describe '#ads_page_count' do
    it 'returns the keyword ads_page_count' do
      presenter = described_class.new(Fabricate(:keyword_parsed_with_links))

      expect(presenter.ads_page_count).to eq(presenter.keyword.ads_page_count)
    end

    it 'returns 0 when ads_page_count is nil' do
      presenter = described_class.new(Fabricate(:keyword))

      expect(presenter.ads_page_count).to be_zero
    end
  end

  describe '#non_ads_result_count' do
    it 'returns the keyword non_ads_result_count' do
      presenter = described_class.new(Fabricate(:keyword_parsed_with_links))

      expect(presenter.non_ads_result_count).to eq(presenter.keyword.non_ads_result_count)
    end

    it 'returns 0 when non_ads_result_count is nil' do
      presenter = described_class.new(Fabricate(:keyword))

      expect(presenter.non_ads_result_count).to be_zero
    end
  end

  describe '#total_link_count' do
    it 'returns the keyword total_link_count' do
      presenter = described_class.new(Fabricate(:keyword_parsed_with_links))

      expect(presenter.total_link_count).to eq(presenter.keyword.total_link_count)
    end

    it 'returns 0 when total_link_count is nil' do
      presenter = described_class.new(Fabricate(:keyword))

      expect(presenter.total_link_count).to be_zero
    end
  end
end
