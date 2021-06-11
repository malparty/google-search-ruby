# frozen_string_literal: true

require 'rails_helper'

describe 'signup', type: :system do
  context 'when non logged user reach the sign up page' do
    it 'displays email field' do
      visit new_user_registration_path
      expect(find('form')).to have_field('user_email')
    end

    it 'displays password field ' do
      visit new_user_registration_path
      expect(find('form')).to have_field('user_password')
    end

    it 'displays password confirmation field ' do
      visit new_user_registration_path
      expect(find('form')).to have_field('user_password_confirmation')
    end
  end

  context 'when non logged user sign up with good data' do
    it 'create an account and log the user in' do
      sign_up 'good@email.com', 'password123'

      expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
    end
  end

  context 'when an non logged user sign up with bad email' do
    it 'stays on the same page' do
      sign_up 'bad_email', 'password123'

      expect(page).to have_current_path new_user_registration_path
    end
  end

  context 'when an non logged user sign up with too short password' do
    it 'display an error message' do
      sign_up 'good@email.com', '123'

      expect(page).to have_selector('#error_explanation li')
    end
  end

  context 'when an non logged user sign up with bad password confirmation' do
    it 'display an error message' do
      sign_up 'good@email.com', 'complex123password', 'differentPassword123'

      expect(page).to have_selector('#error_explanation li')
    end
  end

  context 'when a logged user reach the sign up page' do
    it 'redirect him to the root_page' do
      sign_in
      visit new_user_registration_path

      expect(page).to have_current_path(root_path)
    end
  end
end
