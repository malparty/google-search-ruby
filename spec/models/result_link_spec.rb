# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResultLink, type: :model do
  describe 'link_types' do
    context 'given valid attributes to a non_ads result_link' do
      it 'adds a non_ads link' do
        expect { Fabricate(:result_link, link_type: :non_ads) }.to change(described_class.non_ads, :count).by(1)
      end

      it 'does not change top_ad count' do
        expect { Fabricate(:result_link, link_type: :non_ads) }.to change(described_class.ads_top, :count).by(0)
      end

      it 'returns a non-ad link' do
        result_link = Fabricate(:result_link, link_type: :non_ads)
        expect(result_link).to be_non_ads
      end
    end
  end

  describe 'presence validations' do
    context 'given no link_type' do
      it 'raises a NotNullViolation error' do
        expect { Fabricate(:result_link, link_type: nil) }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    context 'given a blank url' do
      it 'raises a RecordInvalid error' do
        expect { Fabricate(:result_link, url: '   ') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'given no keyword' do
      it 'raises a RecordInvalid error' do
        expect { Fabricate(:result_link, keyword: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
