class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 允许使用用户名或邮箱登录
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
    # devise所需要的参数
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:username, :email, :password, :password_confirmation, :remember_me)
      end
      devise_parameter_sanitizer.for(:sign_in) do |u|
        u.permit(:username, :email, :password, :remember_me)
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:username, :email, :avatar, :by, :current_password, :password, :password_confirmation)
      end
    end
end
