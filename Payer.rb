require './DataFetcher'

class Payer
  attr_accessor :balance, :today, :payer_name, :accounts

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
      pay acct, acct.bill(@today)
      acct.compound
    end
    deduct @burn
    @today += 1
  end

  def run(duration)
    duration.times { day_calc @accounts }
  end

  def reset
    @accounts = DataFetcher.fetch_accounts
  end
end
