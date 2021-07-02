# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # Override user hard-delete (from Devise) with user soft-delete
  def destroy
    resource.discard

    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    set_flash_message :notice, :destroyed

    yield resource if block_given?

    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  end
end
