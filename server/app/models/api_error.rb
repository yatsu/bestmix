class ApiError
  attr_accessor :error, :error_description, :messages

  def initialize(error, error_description, messages)
    @error = error
    @error_description = error_description
    @messages = messages
  end
end
