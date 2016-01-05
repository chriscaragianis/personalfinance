require './Account'
class DataFetcher
  @@host = "HOST"
  @@username = "USERNAME"
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
      accounts << Account.new(row)
    end
    accounts
  end

  def self.fetch_payers
    payer_data = []
    payers = []
    get_array_from_table("payers").each do |row|
      payers << Payer.new(row)
    end
    payers
  end
end
