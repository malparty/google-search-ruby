# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }

    context 'given a blank name' do
      it 'raises a RecordInvalid error' do
        expect { Fabricate(:keyword, name: " \n") }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'given a too long name' do
      it 'raises a RecordInvalid error' do
        too_long_name = FFaker::Lorem.characters(256)

        expect { Fabricate(:keyword, name: too_long_name) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'given a valid name' do
      it 'saves with success' do
        keyword = Fabricate(:keyword, name: FFaker::Lorem.characters(255))

        expect(keyword.save).to be(true)
      end
    end
  end
end
