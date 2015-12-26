class Account
  attr_accessor :balance, :name

  def set_defaults
    @rate ||= 0
    @balance ||= 0
    @min_floor ||= 0
    @min_rate ||= 0
    @name ||= "NAME"
    @weekly ||= false
    @day ||= 0
  end

  def compound
    @balance += @balance * @rate
  end

  def initialize(params = {})
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
  end

  def bill (date)
    (@weekly) ? weekly_bill(date) : monthly_bill(date)
  end

  def weekly_bill (date)
    (date.cweek % @week[0] == @week[1] && date.cwday == @day) ? [@min_rate * @balance, @min_floor].max : 0
  end

  def monthly_bill (date)
    (date.day == @day) ? [@min_rate * @balance, @min_floor].max : 0
  end

end
