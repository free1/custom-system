class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def User.new_remember_token
          SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
          Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
    
    def ensure_private_token!
      self.update_private_token = User.encrypt(User.new_remember_token)
    end

end
