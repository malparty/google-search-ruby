# frozen_string_literal: true

require 'rails_helper'

describe 'csv upload form', type: :system do
  describe 'keywords#index' do
    context 'when user reach the home page' do
      it 'displays the file upload form', authenticated_user: true do
        visit root_path

        expect(find('form.form-csv-upload')).to have_field('csv_upload_form_file', visible: :all)
      end
    end
  end

  describe 'keywords#create' do
    context 'given a valid csv file' do
      it 'redirects to the homepage', authenticated_user: true do
        submit_file 'valid.csv'

        expect(page).to have_current_path(keywords_path)
      end

      it 'displays an upload success message', authenticated_user: true do
        submit_file 'valid.csv'

        expect(find('.alert.alert-success')).to have_content(I18n.t('csv.upload_success'))
      end
    end

    context 'given a text file' do
      it 'displays the wrong_type error', authenticated_user: true do
        submit_file 'wrong_type.txt'

        expect(find('.alert.alert-danger')).to have_content(I18n.t('csv.validation.wrong_type'))
      end
    end

    context 'given a file with too many keywords' do
      it 'displays the wrong_count error', authenticated_user: true do
        submit_file 'too_many_keywords.csv'

        expect(find('.alert.alert-danger')).to have_content(I18n.t('csv.validation.wrong_count'))
      end
    end

    context 'given a file with a too long keyword' do
      it 'displays the bad_keyword_length error', authenticated_user: true do
        submit_file 'invalid_keywords.csv'

        expect(find('.alert.alert-danger')).to have_content(I18n.t('csv.validation.bad_keyword_length'))
      end
    end
  end
end
