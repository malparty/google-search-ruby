# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CSVUploadForm, type: :form do
  describe '#save' do
    context 'given a valid file of 8 keywords' do
      it { expect { save_csv_file 'valid.csv' }.to change(Keyword, :count).by(8) }

      it 'can save' do
        _, saved = save_csv_file 'valid.csv'

        expect(saved).to be(true)
      end

      it 'parses the keyword containing a comma symbol' do
        save_csv_file 'valid.csv'

        expect(Keyword.where(name: 'dien may xanh, the gio di dong').count).to eq(1)
      end
    end

    context 'given too many keywords' do
      it 'returns a wrong_count error' do
        form, = save_csv_file 'too_many_keywords.csv'

        expect(form.errors.full_messages).to include(I18n.t('csv.validation.wrong_count'))
      end
    end

    context 'given a non csv file' do
      it 'returns a wrong_type error' do
        form, = save_csv_file 'wrong_type.txt'

        expect(form.errors.full_messages).to include(I18n.t('csv.validation.wrong_type'))
      end
    end

    context 'given a too long keyword' do
      it 'returns a bad_keyword_length error' do
        form, = save_csv_file 'invalid_keywords.csv'

        expect(form.errors.full_messages.to_s).to include(I18n.t('csv.validation.bad_keyword_length'))
      end

      it 'does not save any keyword' do
        expect { save_csv_file 'invalid_keywords.csv' }.to change(Keyword, :count).by(0)
      end
    end

    context 'given a blank and 5 valid keywords' do
      it 'ignores the blank keyword' do
        expect { save_csv_file 'blank_keyword.csv' }.to change(Keyword, :count).by(5)
      end
    end
  end
end
