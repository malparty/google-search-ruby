module AuthenticationHelper
  def sign_in(user = nil)
    user ||= Fabricate(:user)

    visit root_path

    fill_in 'user_email',    with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
  end
end
