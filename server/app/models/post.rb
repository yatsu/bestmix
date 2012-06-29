class Post < ActiveRecord::Base
  attr_accessible :content, :published_at, :title

  belongs_to :user

  validates :title, :presence => true, :length => { :minimum => 3, :maximum => 255 }

  scope :published, where("published_at IS NOT NULL").order("published_at DESC")

  scope :my, lambda { |user|
    where(:user_id => user.id).order("updated_at DESC")
  }

  scope :accessible, lambda { |user|
    where("user_id = ? OR published_at IS NOT NULL", user.id)
  }

  def published
    published_at != nil
  end
end
