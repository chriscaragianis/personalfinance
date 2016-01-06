require 'mysql2'
require 'date'
require './DataFetcher'

class Calendar
  attr_accessor :accounts, :payers

  def set_defaults
    @accounts ||= []
    @payers ||= []
  end

  def initialize(params = {})
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
  end

  def reset
    @accounts = DataFetcher.fetch_accounts
    @payers = DataFetcher.fetch_payers
  end

  def run(duration, payer)
    duration.times { payer.day_calc @accounts }
    balance_hash
  end

  def balance_hash
    result = Hash.new()
    @accounts.each {|acct| result[acct.acct_name.to_sym] = acct.balance}
    result
  end
end
