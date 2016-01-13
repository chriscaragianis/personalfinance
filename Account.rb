class Account
  attr_accessor :balance, :acct_name

  def set_defaults
    @rate ||= 0
    @balance ||= 0
    @min_floor ||= 0
    @min_rate ||= 0
    @acct_name ||= "NAME"
    @weekly ||= false
    @week_offset ||= 0
    @week_period ||= 0
    @day ||= 0
    @amount ||= 0
  end

  def acct_copy
    Account.new(amount: @amount, balance: @balance, day: @day)
  end

  def compound
    @balance += @balance * @rate/365
  end

  def amount
    if (@balance.abs <= @min_floor) then
      return @balance.abs
    else
      (@amount == 0) ? [@min_rate * @balance, @min_floor].max : @amount
    end
  end

  def initialize(params = {})
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
  end

  def bill (date)
    (@weekly == 1) ? weekly_bill(date) : monthly_bill(date)
  end

  def weekly_bill (date)
    (date.cweek % @week_period == @week_offset && date.cwday == @day) ? amount : 0
  end

  def monthly_bill (date)
    (date.day == @day) ? amount : 0
  end

  def to_s
    return "Name: #{@name}, Balance: #{@balance}"
  end
end
