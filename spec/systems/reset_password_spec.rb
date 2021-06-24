# frozen_string_literal: true

require 'rails_helper'

describe 'reset_password', type: :system do
  context 'when an unauthenticated user reaches the sign in page' do
    it 'displays the forgot your password button' do
      visit new_user_session_path

      click_link I18n.t('auth.forgot_password')

      expect(page).to have_current_path(new_user_password_path)
    end
  end

  context 'when user reset password' do
    it 'shows a paranoid flash message' do
      visit new_user_password_path

      fill_in :user_email, with: FFaker::Internet.email

      click_button I18n.t('auth.btn_reset_password')

      expect(page).to have_content(I18n.t('devise.passwords.send_paranoid_instructions'))
    end
  end
end
