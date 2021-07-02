# frozen_string_literal: true

require 'rails_helper'

describe 'csv upload form', type: :system do
  describe 'keywords#index' do
    context 'when user reach the home page' do
      it 'displays the file upload form' do
        sign_in Fabricate(:user)

        visit root_path

        expect(find('form.form-csv-upload')).to have_field('csv_upload_form_file', visible: :all)
      end
    end
  end

  describe 'keywords#create' do
    context 'given a valid csv file' do
      it 'redirects to the homepage' do
        submit_file 'valid.csv'

        expect(page).to have_current_path(keywords_path)
      end

      it 'displays an upload success message' do
        submit_file 'valid.csv'

        expect(find('.alert.alert-success')).to have_content(I18n.t('csv.upload_success'))
      end
    end

    context 'given a text file' do
      it 'displays the wrong_type error' do
        submit_file 'wrong_type.txt'

        expect(find('.alert.alert-danger')).to have_content(I18n.t('csv.validation.wrong_type'))
      end
    end

    context 'given a file with too many keywords' do
      it 'displays the wrong_count error' do
        submit_file 'too_many_keywords.csv'

        expect(find('.alert.alert-danger')).to have_content(I18n.t('csv.validation.wrong_count'))
      end
    end

    context 'given a file with invalid keywords' do
      it 'displays some keyword errors' do
        submit_file 'invalid_keywords.csv'

        expect(find('.alert.alert-danger')).to have_content('Keyword')
      end
    end
  end
end
