# frozen_string_literal: true

require 'rails_helper'

describe 'signup', type: :system do
  context 'when an unauthenticated user reaches the sign up page' do
    it 'displays the email field' do
      visit new_user_registration_path

      expect(find('form')).to have_field('user_email')
    end

    it 'displays the password field ' do
      visit new_user_registration_path

      expect(find('form')).to have_field('user_password')
    end

    it 'displays the password confirmation field ' do
      visit new_user_registration_path

      expect(find('form')).to have_field('user_password_confirmation')
    end
  end

  context 'when an unauthenticated user signs up with good data' do
    it 'creates an account and logs the user in' do
      sign_up_ui 'good@email.com', 'password123'

      expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
    end
  end

  context 'when an unauthenticated user signs up with bad email' do
    it 'stays on the same page' do
      sign_up_ui 'bad_email', 'password123'

      expect(page).to have_current_path new_user_registration_path
    end
  end

  context 'when an unauthenticated user signs up with a too short password' do
    it 'displays an error message' do
      sign_up_ui 'good@email.com', '123'

      expect(page).to have_selector('#error_explanation li')
    end
  end

  context 'when an unauthenticated user signs up with bad password confirmation' do
    it 'displays an error message' do
      sign_up_ui 'good@email.com', 'complex123password', 'differentPassword123'

      expect(page).to have_selector('#error_explanation li')
    end
  end

  context 'when an authenticated user reaches the sign up page' do
    it 'redirects him to the root_page' do
      sign_in(Fabricate(:user))
      visit new_user_registration_path

      expect(page).to have_current_path(root_path)
    end
  end
end
