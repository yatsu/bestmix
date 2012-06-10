class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :tasks, :dependent => :destroy

  has_many :access_grants, :dependent => :destroy, :class_name => "Doorkeeper::AccessGrant", :foreign_key => "resource_owner_id"
  has_many :access_tokens, :dependent => :destroy, :class_name => "Doorkeeper::AccessToken", :foreign_key => "resource_owner_id"
end
