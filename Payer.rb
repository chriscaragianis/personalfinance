require_relative './DataFetcher'

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


  def day_calc accounts, today
    accounts.each do |acct|
      pay acct, acct.bill(today)
      acct.compound
    end
    accounts
  end

  def day_balances accounts, today
    day_calc(accounts, today).map {|acct| acct.balance}
  end

  def vest accounts, acct_index, vest_level
    (@balance > vest_level) ? pay(accounts[acct_index], vest_level) : nil
    accounts
  end

  def run(accounts, day, ctd, good_path)
    if (ctd > 0) then
      return [[day_balances(accounts, today)] << run(day_calc(accounts), day + 1, ctd - 1, true), true]
    else
      result = run(day_calc(accounts))
      
    end
  end

  def reset
    @accounts = DataFetcher.fetch_accounts
  end
end
