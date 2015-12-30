require './Calendar.rb'
require './Account.rb'
require './Payer.rb'

opts = {db_name: "pf_test", hostname: "localhost", username: <USERNAME>, password: <PASSWORD>}

RSpec.describe Calendar, "#load_account_data" do
  before(:all) do
    @calendar = Calendar.new(opts)
    @calendar.load_accounts
  end
  it "loads the accounts from the test db" do
    expect(@calendar.acct_data.count).to eq(3)
    expect(@calendar.acct_data[2][:balance]).to eq(-5500)
  end
end

RSpec.describe Calendar, "#load payer data" do
  before(:all) do
    @calendar = Calendar.new(opts)
    @calendar.load_payers
  end
  it "loads the payers from the test db" do
    expect(@calendar.payer_data.count).to eq(3)
    expect(@calendar.payer_data[2][:payer_name]).to eq("Payer3")
  end
end

RSpec.describe Calendar, "#create_payers" do
  before(:all) do
    @calendar = Calendar.new(opts)
    @calendar.reset
  end
  it "creates payer array" do
    expect(@calendar.payers.length).to eq(3)
    @calendar.payers.each do |payer|
      expect(payer.respond_to? :day_calc).to be true
    end
    expect(@calendar.payers[2].payer_name).to eq("Payer3")
  end
end

RSpec.describe Calendar, "#create_accounts" do
  before(:all) do
    @calendar = Calendar.new(opts)
    @calendar.reset
  end
  it "creates the account array" do
    expect(@calendar.accounts.length).to eq(3)
    @calendar.accounts.each do |acct|
      expect(acct.respond_to? :bill).to be true
    end
    expect(@calendar.accounts[2].acct_name).to eq("Car")
  end
end

RSpec.describe Calendar, "#run" do
  before(:each) do
    @calendar = Calendar.new(opts)
    @calendar.reset
  end
  it "runs one day with correct results" do
    @calendar.run(Date.new(2016,1,1), 1, @calendar.payers[0])
    expect(@calendar.payers[0].today).to eq(Date.new(2016,1,2))
    result = [@calendar.accounts[0].balance, -1200.920547, -5500.904109] #Don't care about Paycheck balance
    @calendar.accounts.each_with_index do |val, index|
      expect(val.balance).to be_within(0.000001).of(result[index])
    end
  end
  it "runs 30 days with correct results" do
    @calendar.run(Date.new(2016,1,1), 30, @calendar.payers[0])
    expect(@calendar.payers[0].today).to eq(Date.new(2016,1,31))
    result = [@calendar.accounts[0].balance, -1203.36731807594, -5225.90320710914] #Don't care about Paycheck balance
    @calendar.accounts.each_with_index do |val, index|
      expect(val.balance).to be_within(0.000001).of(result[index])
    end
  end
  it "runs 60 days with correct results" do
    @calendar.run(Date.new(2016,1,1), 60, @calendar.payers[0])
    expect(@calendar.payers[0].today).to eq(Date.new(2016,3,1))
    result = [@calendar.accounts[0].balance, -1206.74408517774, -4950.50099530694] #Don't care about Paycheck balance
    @calendar.accounts.each_with_index do |val, index|
      expect(val.balance).to be_within(0.000001).of(result[index])
    end
  end
end
