class Account
  attr_accessor :balance, :acct_name, :rate, :min_floor

  def set_defaults
    @rate ||= 0
    @balance ||= 0
    @min_floor ||= 0
    @min_rate ||= 0
    @acct_name ||= "NAME"
    @weekly ||= 0
    @week_offset ||= 0
    @week_period ||= 0
    @day ||= 0
  end

  def acct_copy
    Account.new(fixed_amount: @fixed_amount, balance: @balance, day: @day, min_floor: @min_floor,
                min_rate: @min_rate, weekly: @weekly, week_offset: @week_offset,
                week_period: @week_period, rate: @rate, carry_balance: @carry_balance)
  end

  def compound
    if (!carry_balance)
      @balance += @balance * @rate/365
    else
      @balance = 0
    end
  end

  def amount
    if (@balance.abs <= @min_floor) then
      return @balance.abs
    else
      (@fixed_amount == 0) ? [@min_rate * @balance, @min_floor].max : @amount
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
