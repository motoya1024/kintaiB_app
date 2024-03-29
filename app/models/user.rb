class User < ApplicationRecord
   has_many :timecards, dependent: :destroy 
   accepts_nested_attributes_for :timecards

   attr_accessor :remember_token, :activation_token, :reset_token
   before_save   :downcase_email
   before_create :create_activation_digest
 

   before_save { self.email = email.downcase }
   validates :name, presence: true, length: { maximum: 50 }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
   validates :email, presence:   true, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
   validates :department, presence: true, length: { maximum: 50 }
   has_secure_password
   validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
   
   validates :specifed_time, presence: true, on: :informationupdate
   validates :basic_time, presence: true, on: :informationupdate
   
    # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
   # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
   # アカウントを有効にする
  def activate
   update_columns(activated: true, activated_at: Time.zone.now)
  end

  
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
    #update_attribute(:reset_digest,  User.digest(reset_token))
    #update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  
  private
  
  # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
