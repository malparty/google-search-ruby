# frozen_string_literal: true

require 'rails_helper'

describe 'login', type: :system do
  context 'when unlogged user reach the app' do
    it 'should redirect him to the login page' do
      visit root_path
      expect(find('h2')).to have_content('Log in')
      expect(find('form')).to have_field('user_email')
      expect(find('form')).to have_field('user_password')
    end
  end

  context 'when valid credentials' do
    it 'should log the user in and display a flash message' do
      sign_in
      expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
    end
  end

  context 'when invalid credentials' do
    it 'should refuse login and display an error' do
      bad_user = Fabricate(:user)
      bad_user.password = 'bad'
      sign_in bad_user
      error_msg = I18n.t('devise.failure.invalid').to_s.gsub('%{authentication_keys}', 'Email')
      expect(page).to have_content(error_msg)
    end
  end
end
