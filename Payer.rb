class Payer
  attr_accessor :balance, :today

  def set_defaults
    @today ||= Date.today
    @balance ||= 0
  end

  def initialize params = {}
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
  end

  def deduct amount
    @balance -= amount
  end

  def pay acct, amount
    deduct amount
    acct.balance -= amount
  end


  def day_calc accounts
    accounts.each do |acct|
      acct.compound
      pay acct, acct.bill(@today)
    end
    @today += 1
  end

  def to_s
    "MONEY HAVE: #{@balance} ON: #{@today.to_s}"
  end
end
