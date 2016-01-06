require './Account'
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

  def self.create_balance_table(table_name, calendar)
    client = Mysql2::Client.new(:host => "#{@@host}", :username => "#{@@username}", :password => "#{@@password}")
    client.query("USE #{@@db_name}")
    columns = ""
    calendar.accounts.each do |acct|
      columns << "#{acct.acct_name} FLOAT(14),"
    end
    columns << "payer FLOAT(14)"
    client.query("CREATE TABLE IF NOT EXISTS #{table_name} (#{columns})")
  end

  def self.write_balances (table_name, calendar)
    client = Mysql2::Client.new(:host => "#{@@host}", :username => "#{@@username}", :password => "#{@@password}")
    client.query("USE #{@@db_name}")
    values = ""
    calendar.accounts.each do |acct|
      values << "#{acct.balance},"
    end
    values << "#{calendar.payer.balance}"
    client.query("INSERT INTO #{table_name} VALUES (#{values})")
  end
end
