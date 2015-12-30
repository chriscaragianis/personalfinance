class Payer
  attr_accessor :balance, :today, :payer_name

  def set_defaults
    @today ||= Date.today
    @balance ||= 0
    @burn ||= 0
    @payer_name ||= "NAME"
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
    acct.balance += amount
  end


  def day_calc accounts
    accounts.each do |acct|
      acct.compound
      pay acct, acct.bill(@today)
    end
    deduct @burn
    @today += 1
  end
end
