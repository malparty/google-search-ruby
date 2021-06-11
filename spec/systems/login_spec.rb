# frozen_string_literal: true

require 'rails_helper'

describe 'login', type: :system do
  context 'when non logged user reach the app' do
    it 'redirect the user to the login page' do
      visit root_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context 'when valid credentials' do
    it 'log the user in and display a flash message' do
      sign_in

      expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
    end
  end

  context 'when invalid credentials' do
    it 'refuse login and display an error' do
      bad_user = Fabricate(:user)
      bad_user.password = 'bad'
      error_msg = I18n.t('devise.failure.invalid').to_s.gsub('%{authentication_keys}', 'Email')

      sign_in bad_user

      expect(page).to have_content(error_msg)
    end
  end
end
