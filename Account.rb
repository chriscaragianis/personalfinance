class Account
  attr_accessor :balance
  
  def initialize(rate, balance, date, payer)
    @rate = rate
    @balance = balance
    @date = date
    @min = 0
    @payer = payer
  end

  def compound
    @balance += @balance * @rate;
    @min = @balance / 50
  end

  def bill (date = Date.today)
    (date == @date) ? @min : 0
  end

  def to_s
    "Rate: #{@rate}, Balance: #{@balance}, Date: #{@date}"
  end
end
