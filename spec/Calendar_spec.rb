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
    @results = [{Paycheck1: 0, CC: -1200.920547, Car: -5500.904109},
                {Paycheck1: 0, CC: -1203.3673180759445, Car: -5225.9032071091415},
                {Paycheck1: 0, CC: -1206.74408517774, Car: -4950.50099530694}]
  end

  before(:each) do
    @calendar = Calendar.new
    @calendar.reset
  end

  it "runs one day with correct results" do
    result = @calendar.run(1, @calendar.payers[0])
    @results[0].each_pair do |name, balance|
      expect(result[name]).to be_within(0.001).of(balance)
    end
    expect(@calendar.payers[0].today).to eq(Date.new(2016,1,2))
  end

  it "runs 30 days with correct results" do
    result = @calendar.run(30, @calendar.payers[0])
    @results[1].each_pair do |name, balance|
      expect(result[name]).to be_within(0.000001).of(balance)
    end
    expect(@calendar.payers[0].today).to eq(Date.new(2016,1,31))
  end

  it "runs 60 days with correct results" do
    result = @calendar.run(60, @calendar.payers[0])
    @results[2].each_pair do |name, balance|
      expect(result[name]).to be_within(0.000001).of(balance)
    end
    expect(@calendar.payers[0].today).to eq(Date.new(2016,3,1))
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

RSpec.describe Calendar, "#AD HOC DB TEST" do
  it "DOES A THING WITHOUT ERRORRINGGING" do
    @calendar = Calendar.new
    @calendar.reset
    DataFetcher.create_balance_table("balances" , @calendar.accounts)
    DataFetcher.write_balances("balances", @calendar.accounts)
  end
end
