class Post < ActiveRecord::Base
  attr_accessible :content, :published_at, :title, :publish

  attr_accessor :publish

  belongs_to :user

  validates :title, :presence => true, :length => { :minimum => 3, :maximum => 255 }
  validates :content, :length => { :minimum => 0, :maximum => 10000 }

  before_save :set_published_at

  scope :published, where("published_at IS NOT NULL")

  scope :alive, where("deleted_at IS NULL")

  scope :my, lambda { |user|
    where(:user_id => user.id).order("updated_at DESC")
  }

  scope :accessible, lambda { |user|
    where("user_id = ? OR published_at IS NOT NULL", user.id)
  }

  def published
    published_at != nil
  end

  def deleted
    deleted_at != nil
  end

  private

  def set_published_at
    if (publish == true || publish == "true" || publish == "1") && published_at.nil?
      self.published_at = Time.now
    elsif (publish != true && publish != "true" && publish != "1") && published_at
      self.published_at = nil
    end
  end
end
