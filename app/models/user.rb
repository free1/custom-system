class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :authentication_keys => [:login]

  attr_accessor :login

  # 用户头像
  mount_uploader :avatar, AvatarUploader

  # 第三方登录
  has_many :authentications

  validates :username, uniqueness: { :case_sensitive => false },
                       format: {:with => /\A\w+\z/, :message => '只允许数字、大小写字母和下划线'},
                       length: {:in => 3..20}, presence: true

  # 判断用户是否在线
  def user_on_line
    self.update_attribute(:on_line, 1)
  end
  def user_not_on_line
    self.update_attribute(:on_line, 0)
  end

  class << self
    # 使用用户名或邮箱登录
    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

    # 使用第三方登录
    def find_for_github_oauth(auth, signed_in_resource=nil)
      user = Authentication.find_by_provider_and_uid(auth[:provider], auth[:uid]).try(:user)
      unless user
        user = User.new do |user|
          user.username = auth[:info][:nickname]
          user.email = auth[:info][:email]
          user.password = Devise.friendly_token[0,20]
          user.authentications.build do |authentication|
            authentication.provider = auth[:provider]
            authentication.uid = auth[:uid]
            authentication.save!
          end
          user.save!
        end
      end
      user
    end
  end

  # 更新资料时去掉密码验证
  def update_with_password(params={})
    if !params[:current_password].blank? or !params[:password].blank? or !params[:password_confirmation].blank?
      super
    else
      params.delete(:current_password)
      self.update_without_password(params)
    end
  end
end
