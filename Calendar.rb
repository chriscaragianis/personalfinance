require 'mysql2'
require 'date'

class Calendar
  attr_accessor :acct_data, :accounts, :payer_data, :payers

  def set_defaults
    @acct_data ||= []
    @accounts ||= []
    @payer_data ||= []
    @payers ||= []
  end

  def initialize(params = {})
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
    @client = Mysql2::Client.new(:host => "#{@host}", :username => "#{@username}", :password => "#{@password}")
    @client.query("USE #{@db_name}")
  end

  def load_accounts
    result = @client.query("SELECT * from accounts", :symbolize_keys => true);
    result.each do |row|
      @acct_data << row
    end
  end

  def load_payers
    result = @client.query("SELECT * from payers", :symbolize_keys => true)
    result.each do |row|
      @payer_data << row
    end
  end

  def create_accounts
    @acct_data.each do |row|
      @accounts << Account.new(row)
    end
  end

  def create_payers
    @payer_data.each do |row|
      @payers << Payer.new(row.merge({today: row[:today].to_date}))
    end
  end

  def reset
    load_accounts
    load_payers
    create_accounts
    create_payers
  end

  def run(first_day, duration, payer)
    duration.times { payer.day_calc @accounts }
  end
end
