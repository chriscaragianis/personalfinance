require './Calendar.rb'
require './Account.rb'
require './Payer.rb'

RSpec.describe Calendar, "#load_account_data" do
  before(:all) do
    @calendar = Calendar.new
    @calendar.reset
  end
  it "loads the accounts from the test db" do
    expect(@calendar.accounts.length).to eq(3)
    expect(@calendar.accounts[2].balance).to eq(-5500)
  end
end

RSpec.describe Calendar, "#load payer data" do
  before(:all) do
    @calendar = Calendar.new
    @calendar.reset
  end
  it "loads the payers from the test db" do
    expect(@calendar.payers.length).to eq(3)
    expect(@calendar.payers[2].payer_name).to eq("Payer3")
  end
end

RSpec.describe Calendar, "#run" do
  before(:all) do
    @result1 = [{Paycheck1: 0, CC: -1200.920547, Car: -5500.904109}]
    @result2 = [@result1[0],
               {Paycheck1: 0, CC: -1201.84180206418, Car: -5501.80836779884}]
  end
  before(:each) do
    @calendar = Calendar.new
    @calendar.reset
  end
  it "runs one day with correct results" do
    result = @calendar.run(1, @calendar.payers[0])
    @result1[0].each_pair do |name, balance|
      expect(result[0][name]).to be_within(0.001).of(balance)
    end
    expect(@calendar.payers[0].today).to eq(Date.new(2016,1,2))
  end
  it "runs 30 days with correct results" do
    @calendar.run(30, @calendar.payers[0])
    expect(@calendar.payers[0].today).to eq(Date.new(2016,1,31))
    result = [@calendar.accounts[0].balance, -1203.36731807594, -5225.90320710914] #Don't care about Paycheck balance
    @calendar.accounts.each_with_index do |val, index|
      expect(val.balance).to be_within(0.000001).of(result[index])
    end
  end
  it "runs 60 days with correct results" do
    @calendar.run(60, @calendar.payers[0])
    expect(@calendar.payers[0].today).to eq(Date.new(2016,3,1))
    result = [@calendar.accounts[0].balance, -1206.74408517774, -4950.50099530694] #Don't care about Paycheck balance
    @calendar.accounts.each_with_index do |val, index|
      expect(val.balance).to be_within(0.000001).of(result[index])
    end
  end
end

RSpec.describe Calendar, "#balance_hash" do
  before(:each) do
    @calendar = Calendar.new
    @calendar.reset
  end
  it "returns a hash of balances" do
    result = {Paycheck1: 0, CC: -1200, Car: -5500}
    expect(@calendar.balance_hash).to eq(result)
  end
end
