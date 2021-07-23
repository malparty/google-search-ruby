# frozen_string_literal: true

require 'rails_helper'

describe 'login', type: :system do
  context 'when an unauthenticated user reaches the app' do
    it 'redirects the user to the login page' do
      visit root_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context 'when user signs in' do
    context 'given valid credentials' do
      it 'logs the user in and displays a flash message' do
        sign_in_ui

        expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
      end
    end

    context 'given invalid credentials' do
      it 'refuses login and displays an error' do
        bad_user = Fabricate(:user)
        bad_user.password = 'bad'
        error_msg = I18n.t('devise.failure.invalid').to_s.gsub('%{authentication_keys}', 'Email')

        sign_in_ui bad_user

        expect(page).to have_content(error_msg)
      end
    end
  end

  context 'when the user signed in and reached the home page' do
    it 'does not redirect to the sign in page' do
      sign_in_system Fabricate(:user)
      visit root_path

      expect(page).to have_current_path(root_path)
    end
  end
end
