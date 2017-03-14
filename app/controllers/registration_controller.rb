class RegistrationController < Devise::RegistrationsController
  def after_inactive_sign_up_path_for(resource)
    registration_notice_path(token: resource.invite_code)
  end
end


