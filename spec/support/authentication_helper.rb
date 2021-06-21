# frozen_string_literal: true

module DeviseHelpers
  module RequestHelpers
    # def sign_in_user(user)
    #   request.env['devise.mapping'] = Devise.mappings[:user]
    #   sign_in(user)
    # end
  end

  module SystemHelpers
    def sign_in_ui(user = nil)
      user ||= Fabricate(:user)

      visit root_path

      fill_in 'user_email',    with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log in'
    end

    def sign_in(user)
      login_as user, scope: :user
    end

    def sign_up_ui(email, password, password_confirm = nil)
      user = Fabricate(:user)

      visit new_user_registration_path

      fill_in 'user_first_name', with: user.first_name
      fill_in 'user_last_name', with: user.last_name
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password_confirm || password

      click_button 'Sign up'
    end
  end
end
