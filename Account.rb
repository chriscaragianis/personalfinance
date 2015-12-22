class Account
  attr_accessor :balance

  def set_defaults
    @rate ||= 0
    @balance ||= 0
    @day ||= 1
    @payer ||= Payer.new({balance: @balance, today: Date.today})
    @min_floor ||= 0
    @min_rate ||= 0
    @name ||= "NAME"
  end

  def initialize(params = {})
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
  end

  def compound
    @balance += @balance * @rate
  end

  def bill (date)
    (date.day == @day) ? [@min_floor, @min_rate * @balance].max : 0
  end

  def to_s
    "#{@name}: (Rate: #{@rate}, Balance: #{@balance}, Date: #{@day})"
  end
end
