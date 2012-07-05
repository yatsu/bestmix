class FacebookUser
  attr_accessor :id, :name, :first_name, :last_name, :username, :gender

  def initialize(hash = {})
    @hash = hash
  end

  def id
    @hash[:id.to_s]
  end

  def name
    @hash[:name.to_s]
  end

  def first_name
    @hash[:first_name.to_s]
  end

  def last_name
    @hash[:last_name.to_s]
  end

  def username
    @hash[:username.to_s]
  end

  def gender
    @hash[:gender.to_s]
  end

  def inspect
    @hash.inspect
  end
end