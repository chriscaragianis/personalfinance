require_relative './Account'
require 'mysql2'
require_relative './FixedAccount'
class DataFetcher
  @@host = "HOST"
  @@username = "USER"
  @@db_name = "DB_NAME"
  @@password = "PASSWORD"

  def self.get_array_from_table table
    data = []
    client = Mysql2::Client.new(:host => "#{@@host}", :username => "#{@@username}", :password => "#{@@password}")
    client.query("USE #{@@db_name}")
    result = client.query("SELECT * from #{table}", :symbolize_keys => true);
    result.each do |row|
      data << row
    end
    client.close
    data
  end

  def self.fetch_accounts
    acct_data = []
    accounts = []
    get_array_from_table("accounts").each do |row|
      (row[:carry_balance] == 1) ? accounts << Account.new(row) : accounts << FixedAccount.new(row)
    end
    accounts
  end

  def self.create_balance_table(table_name, scenario)
    client = Mysql2::Client.new(:host => "#{@@host}", :username => "#{@@username}", :password => "#{@@password}")
    client.query("USE #{@@db_name}")
    columns = ""
    scenario.accounts.each do |acct|
      columns << "#{acct.acct_name} FLOAT(14),"
    end
    columns << "scenario FLOAT(14), scenario_date VARCHAR(20)"
    client.query("CREATE TABLE IF NOT EXISTS #{table_name} (#{columns})")
    client.close
  end

  def self.write_balances (table_name,scenario)
    client = Mysql2::Client.new(:host => "#{@@host}", :username => "#{@@username}", :password => "#{@@password}")
    client.query("USE #{@@db_name}")
    values = ""
    scenario.accounts.each do |acct|
      values << "#{acct.balance},"
    end
    values << "#{scenario.balance}, \"#{scenario.today.to_s}\""
    client.query("INSERT INTO #{table_name} VALUES (#{values})")
    client.close
  end
end
