# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CSVUploadForm, type: :form do
  # TODO: refactor as helper to get the valid/blank/big/unreadable files
  context 'given a valid file of 8 keywords' do
    it 'can save all records' do
      file = file_fixture('csv/valid.csv')

      expect(described_class.new(Fabricate(:user)).save({ file: file })).to be(true)
    end

    it 'adds 8 keywords in database' do
      file = file_fixture('csv/valid.csv')

      expect{ described_class.new(Fabricate(:user)).save({ file: file }) }.to change(Keyword, :count).by(8)
    end
  end

  # context 'given too many keywords' do

  # end

  # context 'given a blank csv file' do

  # end

  # context  'given an unreadable file' do

  # end
end
