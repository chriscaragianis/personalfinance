require_relative './DataFetcher'
require_relative './BalanceRecord'

class Scenario
  attr_accessor :balance, :today, :Scenario_name, :accounts, :balances

  def set_defaults
    @balance ||= 0
    @accounts ||= []
    @balances ||= [BalanceRecord.new()]
    @Scenario_name ||= "NAME"
    @today ||= Date.today
    @vest_level ||= 0
    @vest_targets ||= []
  end

  def initialize params = {}
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
  end

  def day_calc bal_rec
    accounts = []
    balance = bal_rec.balance
    bal_rec.accounts.each do |val|
      new_account = val.acct_copy
      new_account.compound
      new_account.balance += new_account.bill(bal_rec.date)
      balance -= new_account.bill(bal_rec.date)
      accounts << new_account
    end
    BalanceRecord.new(date: bal_rec.date + 1, balance: balance, accounts: accounts)
  end

  def run(start_day, finish_day)
    bookmark = [0, finish_day]
    vest = 0
    if start_day >= finish_day then
      return
    end
    @balances.sort! #Usually does not need to be done, check outside method
    start_index = @balances.index { |balrec| balrec.date == start_day } || 0
    (finish_day - start_day).to_i.times do |i|
      @balances[start_index + i + 1] = day_calc @balances[start_index + i]
      if (i == 0 || @balances[start_index + i].balance < @vest_level) && @balances[start_index + i + 1].balance > @vest_level then
        bookmark = [i + 1, @balances[start_index + i + 1].date]
        vest = @vest_level
      end
    end
    vest(start_index + bookmark[0], vest)
    run(bookmark[1], finish_day)
  end

  def vest index, amount
    if (@vest_targets == []) then
      return
    end
    @balances[index].balance -= amount
    @balances[index].accounts[@vest_targets[0]].balance += amount
    if (@balances[index].accounts[@vest_targets[0]].balance >= 0) then
      left = @balances[index].accounts[@vest_targets[0]].balance
      @balances[index].balance += left
      @balances[index].accounts[@vest_targets[0]].balance = 0
      @vest_targets.shift ? vest(index, left) : return
    end
  end

  def reset
    @accounts = DataFetcher.fetch_accounts
    @balances[0] = BalanceRecord.new(date: @today, balance: @balance, accounts: @accounts)
  end

end
