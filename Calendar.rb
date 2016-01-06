require 'mysql2'
require 'date'
require './DataFetcher'

class Calendar
  attr_accessor :accounts, :payer

  def set_defaults
    @accounts ||= []
  end

  def initialize(params = {})
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
    @payer = Payer.new(balance: @payer_bal, today: @start_date)
  end

  def reset
    @accounts = DataFetcher.fetch_accounts
  end

  def run(duration)
    duration.times { payer.day_calc @accounts }
    balance_hash
  end

  def balance_hash
    result = Hash.new()
    @accounts.each {|acct| result[acct.acct_name.to_sym] = acct.balance}
    result
  end
end
