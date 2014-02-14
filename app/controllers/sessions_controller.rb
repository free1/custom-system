class SessionsController < Devise::SessionsController

  def new
    super
  end

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    current_user.user_on_line
    redirect_to root_path
  end

  def destroy
    current_user.user_not_on_line
    super
  end
end