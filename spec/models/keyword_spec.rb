# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }

    context 'given a valid name' do
      it 'saves with success' do
        keyword = Fabricate(:keyword, name: FFaker::Lorem.characters(255))

        expect(keyword.save).to be(true)
      end
    end
  end
end
