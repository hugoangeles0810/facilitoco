# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string           default(""), not null
#  name                   :string
#  last_name              :string
#  bio                    :text
#  uid                    :string
#  provider               :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  cover_file_name        :string
#  cover_content_type     :string
#  cover_file_size        :integer
#  cover_updated_at       :datetime
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  validates :username, presence: true, uniqueness: true, length: {in: 5..30}
  validate :validate_username_regex

  has_many :posts
  has_attached_file :avatar, styles: { thumb: "100x100", medium: "300x300"}, default_url: "/images/:style/missing.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  has_attached_file :cover, styles: { thumb: "400x300", medium: "800x600"}, default_url: "/images/:style/missing_cover.jpg"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/

  def self.from_omniauth(auth)
  	where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
  		if auth[:info]
  			#user.email = auth[:info][:email]
  			user.name = auth[:info][:name]	
  		end

  		user.password = Devise.friendly_token[0, 20]

  	end
  end

  private
    def validate_username_regex
      unless username =~ /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_]*\z/
        errors.add(:username,"El username debe iniciar con una letra")
        errors.add(:username,"El username sólo puede contener _,letras y números")
      end
    end
end
