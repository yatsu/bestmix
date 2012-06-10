class Task < ActiveRecord::Base
  attr_accessible :name, :public

  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 255 }

  scope :pub, where(:public => true)

  scope :my, lambda { |user|
    where(:user_id => user.id)
  }
end
