class StaticPagesController < ApplicationController
  layout :choose_home_page

  def about
  end

  def help
  end

  def contact
  end

  def home
  end

  private
    
    # 根据登陆状态显示首页
    def choose_home_page
      # signed_in? ? 'application' : 'home_page'
      'home_page'
    end
end
