class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 允许使用用户名或邮箱登录
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u| 
        u.permit(:username, :email, :password, :password_confirmation, :remember_me) 
      end
      devise_parameter_sanitizer.for(:sign_in) do |u| 
        u.permit(:username, :email, :password, :remember_me) 
      end
    end
end
