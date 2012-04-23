class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable, :database_authenticatable
  #       :recoverable, :rememberable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  # field :reset_password_token,   :type => String
  # field :reset_password_sent_at, :type => Time

  ## Rememberable
  # field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  field :facebook_data
  field :facebook_token
  field :facebook_valid, :default => false

  def to_s
    name
  end

  def profile_url
    facebook_data["link"] || ""
  end

  def name
    facebook_data["name"] || ""
  end

  def facebook
    @graph ||= Koala::Facebook::API.new(self.facebook_token)
  end

  def validate_facebook!
    # Check if they have alteast 5 friends
    # and 5 posts

    begin
      if friends_count > 5 and posts_count > 5
        self.facebook_valid = true
        self.save()
      end
    rescue Koala::Facebook::APIError => e
      puts "#{self.email} = #{e}"
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = self.where(:email => data.email).first
      user
    else
      user = self.create!(
        :email => data.email, 
        :password => Devise.friendly_token[0,20]) 
    end

    user.facebook_data = data
    user.facebook_token = access_token["credentials"]["token"]
    user.save

    if not user.facebook_valid
      user.validate_facebook!
    end

    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end

  private

  def friends_count
    facebook.get_connection("me", "friends").count
  end

  def posts_count
    facebook.get_connection("me", "posts").count
  end

end
