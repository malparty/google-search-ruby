# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filter, type: :model do
  describe 'Validations' do
    context 'given valid keyword_pattern and url_pattern' do
      it 'is valid' do
        filter = described_class.new keyword_pattern: '^[0-9]*$', url_pattern: '^[htps]'

        expect(filter).to be_valid
      end
    end

    context 'given valid link_types' do
      it 'is valid' do
        filter = described_class.new link_types: [ResultLink.link_types[:ads_top], ResultLink.link_types[:non_ads]]

        expect(filter).to be_valid
      end
    end

    context 'given a filter from_params' do
      it 'is a Filter object' do
        params = { keyword_pattern: 'keyword', url_pattern: '^https://', link_types: ['', ResultLink.link_types[:ads_top].to_s] }

        filter = described_class.from_params params

        expect(filter.class).to eq(described_class)
      end

      it 'is valid' do
        params = { keyword_pattern: 'keyword', url_pattern: '^https://', link_types: ['', 'ads_top'] }

        filter = described_class.from_params params

        expect(filter).to be_valid
      end
    end

    context 'given a filter from_params with empty params' do
      it 'is a Filter object' do
        filter = described_class.from_params({})

        expect(filter.class).to eq(described_class)
      end

      it 'is valid' do
        filter = described_class.from_params({})

        expect(filter).to be_valid
      end
    end

    context 'given no attribute' do
      it 'is valid' do
        filter = described_class.new

        expect(filter).to be_valid
      end
    end

    context 'given a bad keyword_pattern' do
      it 'is not valid' do
        filter = described_class.new keyword_pattern: '?'

        expect(filter).not_to be_valid
      end

      it 'has an error message' do
        filter = described_class.new keyword_pattern: '?'

        filter.validate

        expect(filter.errors.full_messages).to be_present
      end
    end

    context 'given a bad url_pattern' do
      it 'is not valid' do
        filter = described_class.new url_pattern: '?'

        expect(filter).not_to be_valid
      end

      it 'has an error message' do
        filter = described_class.new url_pattern: '?'

        filter.validate

        expect(filter.errors.full_messages).to be_present
      end
    end

    context 'given a bad link_types attribute' do
      it 'is not valid' do
        filter = described_class.new(link_types: [-1, ResultLink.link_types[:ads_top]])

        expect(filter).not_to be_valid
      end

      it 'has an error message' do
        filter = described_class.new(link_types: [-1, ResultLink.link_types[:ads_top]])

        filter.validate

        expect(filter.errors.full_messages).to be_present
      end
    end
  end

  describe '#result_link_filter_exist?' do
    context 'given no params' do
      it 'returns false' do
        filter = described_class.new

        expect(filter.result_link_filter_exist?).to be(false)
      end
    end

    context 'given an url_pattern param' do
      it 'returns true' do
        filter = described_class.new({ url_pattern: '^https' })

        expect(filter.result_link_filter_exist?).to be(true)
      end
    end

    context 'given a link_types param' do
      it 'returns true' do
        filter = described_class.new({ link_types: [ResultLink.link_types[:ads_top]] })

        expect(filter.result_link_filter_exist?).to be(true)
      end
    end

    context 'given both url_pattern and link_types params' do
      it 'returns true' do
        filter = described_class.new({ url_pattern: '^https', link_types: [ResultLink.link_types[:ads_top]] })

        expect(filter.result_link_filter_exist?).to be(true)
      end
    end
  end

  describe 'PATTERN_REGEXP' do
    context 'given valid string' do
      it { expect('simple'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('^startWith'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('endWith$'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('[a-z]{5}'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('[a-z]{5,}'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('[a-z]{5,4}'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('[a-z]?'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('[a-z]*'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('[a-z]+'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('^(abc){5}$'.match described_class::PATTERN_REGEXP).not_to be_nil }
      it { expect('^(a|b){5}$'.match described_class::PATTERN_REGEXP).not_to be_nil }
    end

    context 'given an invalid string' do
      it { expect('?'.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect('*'.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect('+'.match described_class::PATTERN_REGEXP).to be_nil }

      it { expect('['.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect('[as'.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect('^[as'.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect('^as]'.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect(']'.match described_class::PATTERN_REGEXP).to be_nil }

      it { expect('('.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect('(as'.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect('^(as'.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect('^as)'.match described_class::PATTERN_REGEXP).to be_nil }
      it { expect(')'.match described_class::PATTERN_REGEXP).to be_nil }
    end
  end
end
