require_relative './DataFetcher'

class Scenario
  attr_accessor :balance, :today, :Scenario_name, :accounts

  def set_defaults
    @today ||= Date.today
    @balance ||= 0
    @burn ||= 0
    @Scenario_name ||= "NAME"
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

  def day_balances today
    day_calc(accounts, today).map {|acct| acct.balance}
  end

  def vest accounts, acct_index, vest_level
    (@balance > vest_level) ? pay(accounts[acct_index], vest_level) : nil
    accounts
  end

  def run(start_day, finish_day)
    result = []
    (finish - start).times do |i|
      result[i] = day_calc(start_day + i)
    end
    result
  end

  def get_balances
    @accounts.map { |acct| acct.balance }
  end

  def merge_balances
  end


  def reset
    @accounts = DataFetcher.fetch_accounts
  end

  def run_balances(start_date, length)
    result = []
    result[0] = day_calc(@accounts, start_date).map { |acct| acct.acct_copy }
    (length - 1).times do |i|
      result << day_calc(result[i], start_date + i).map { |acct| acct.acct_copy }
    end
    result
  end

end
