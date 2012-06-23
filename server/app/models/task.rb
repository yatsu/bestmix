class Task < ActiveRecord::Base
  attr_accessible :name, :public

  belongs_to :user

  validates :name, :presence => true, :length => { :minimum => 3, :maximum => 255 }

  scope :pub, where(:public => true).order("updated_at DESC")

  scope :my, lambda { |user|
    where(:user_id => user.id).order("updated_at DESC")
  }
end
