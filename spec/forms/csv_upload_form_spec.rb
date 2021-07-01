# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CSVUploadForm, type: :form do
  describe '#save' do
    context 'given a valid file of 8 keywords' do
      it { expect { save_csv_file 'valid.csv' }.to change(Keyword, :count).by(8) }

      it 'can save' do
        _, _, saved = save_csv_file 'valid.csv'

        expect(saved).to be(true)
      end

      it 'parses the keyword containing a comma symbol' do
        form, = save_csv_file 'valid.csv'

        expect(form.keywords.map(&:name)).to include('dien may xanh, the gio di dong')
      end
    end

    context 'given too many keywords' do
      it 'returns a wrong_count error' do
        form, = save_csv_file 'too_many_keywords.csv'

        expect(form.errors.full_messages).to include(I18n.t('csv.validation.wrong_count'))
      end
    end

    context 'given a blank csv file' do
      it 'returns a blank error' do
        form, = save_csv_file 'blank.csv'

        expect(form.errors.full_messages).to include(I18n.t('csv.validation.blank'))
      end
    end

    context 'given a non csv file' do
      it 'returns a wrong_type error' do
        form, = save_csv_file 'wrong_type.txt'

        expect(form.errors.full_messages).to include(I18n.t('csv.validation.wrong_type'))
      end
    end

    context 'given 2 invalid keywords' do
      it 'returns 2 keyword errors' do
        form, = save_csv_file 'invalid_keywords.csv'

        expect(form.errors.errors.count { |e| e.attribute == :keyword }).to eq(2)
      end
    end
  end
end
