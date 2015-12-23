class Account
  attr_accessor :balance, :name

  def set_defaults
    @balance ||= 0
    @name ||= "NAME"
  end

  def initialize(params = {})
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
  end

  def bill (date)
  end
end
