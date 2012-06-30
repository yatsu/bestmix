class ApiError
  attr_accessor :error, :error_description, :messages

  def self.json(error, error_description, messages)
    self.new(error, error_description, messages).to_json
  end

  def initialize(error, error_description, messages)
    @error = error
    @error_description = error_description
    @messages = messages
  end
end
