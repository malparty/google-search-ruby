# frozen_string_literal: true

module AuthenticationHelper
  def sign_in(user = nil)
    user ||= Fabricate(:user)

    visit root_path

    fill_in 'user_email',    with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
  end

  def sign_up(email, password, password_confirm = nil)
    user = Fabricate(:user)
    visit new_user_registration_path
    fill_in 'user_firstname', with: user.firstname
    fill_in 'user_lastname', with: user.lastname
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password_confirm || password
    click_button 'Sign up'
  end
end
