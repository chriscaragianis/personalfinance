require './Calendar.rb'
require './Account.rb'
require './Payer.rb'

RSpec.describe Calendar, "#load_account_data" do
  before(:all) do
    @calendar = Calendar.new(payer_bal: 2000)
    @calendar.reset
  end
  it "loads the accounts from the test db" do
    expect(@calendar.accounts.length).to eq(3)
    expect(@calendar.accounts[2].balance).to eq(-5500)
  end
end

RSpec.describe Calendar, "#run" do

  before(:all) do
    @results = [{Paycheck1: 0, CC: -1200.920547, Car: -5500.904109},
                {Paycheck1: 0, CC: -1203.3673180759445, Car: -5225.853680835735},
                {Paycheck1: 0, CC: -1206.74408517774, Car: -4950.401706077883}]
  end

  before(:each) do
    @calendar = Calendar.new(payer_bal: 2000, start_date: Date.new(2016,1,1))
    @calendar.reset
  end

  it "runs one day with correct results" do
    result = @calendar.run(1)
    @results[0].each_pair do |name, balance|
      expect(result[name]).to be_within(0.001).of(balance)
    end
    expect(@calendar.payer.today).to eq(Date.new(2016,1,2))
  end

  it "runs 30 days with correct results" do
    result = @calendar.run(30)
    @results[1].each_pair do |name, balance|
      expect(result[name]).to be_within(0.000001).of(balance)
    end
    expect(@calendar.payer.today).to eq(Date.new(2016,1,31))
  end

  it "runs 60 days with correct results" do
    result = @calendar.run(60)
    @results[2].each_pair do |name, balance|
      expect(result[name]).to be_within(0.000001).of(balance)
    end
    expect(@calendar.payer.today).to eq(Date.new(2016,3,1))
  end
end

RSpec.describe Calendar, "#balance_hash" do
  before(:each) do
    @calendar = Calendar.new(payer_bal: 2000)
    @calendar.reset
  end
  it "returns a hash of balances" do
    result = {Paycheck1: 0, CC: -1200, Car: -5500}
    expect(@calendar.balance_hash).to eq(result)
  end
end

RSpec.describe Calendar, "#AD HOC DB TEST" do
  before(:each) do
    @calendar = Calendar.new(payer_bal: 2000)
    @calendar.reset
  end
  it "DOES A THING WITHOUT ERRORRINGGING" do
    DataFetcher.create_balance_table("balances" , @calendar)
    DataFetcher.write_balances("balances", @calendar)
  end
  it "FILLS UP A TABLE" do
    100.times do
      @calendar.run(1)
      DataFetcher.write_balances("balances", @calendar)
    end
  end
end
