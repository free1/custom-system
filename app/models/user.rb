class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :authentication_keys => [:login]

  attr_accessor :login

  # 第三方登录
  has_many :authentications

  validates :username, uniqueness: { :case_sensitive => false }

  # 使用用户名或邮箱登录
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # 使用第三方登录
  def self.find_for_github_oauth(auth, signed_in_resource=nil)
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
