require './Account'
require './Payer'
require 'date'

RSpec.describe Payer, '#initialize' do
  context "with no given data" do
    it "creates a default Payer object" do
      payer = Payer.new
      expect(payer.balance).to eq(0)
      expect(payer.today).to eq(Date.today)
    end
  end
  context "with date and balance given" do
    it "creates a Payer object with correct balance and date" do
      payer = Payer.new(today: (Date.today + 1), balance: 2000)
      expect(payer.balance).to eq(2000)
      expect(payer.today).to eq(Date.today + 1)
    end
  end
end

RSpec.describe Payer, "#day_calc" do
  before(:all) do
    @payers = []
    3.times {@payers << Payer.new(balance: 1000)}
    defaults = {rate: 0.01*365, min_rate: -0.02, min_floor: 100}
    @accts = [Account.new(defaults.merge({day: Date.today.day, balance: -1000})),
             Account.new(defaults.merge({day: Date.today.day + 1, balance: -1000})),
             Account.new(defaults.merge({day: Date.today.day, balance: -10000}))]
    @payers.each_with_index {|payer, index| payer.day_calc [@accts[index]]}
  end
  it "Compounds interest properly" do
    expect(@accts[1].balance).to eq(-1010)
  end
  it "Deducts from payer balance properly" do
    expect(@payers.map {|this| this.balance}).to eq([900, 1000, 800])
  end
  it "Reduces account balances properly" do
    expect(@accts.map {|this| this.balance}).to eq([-909,-1010,-9898])
  end
  it "advances the date" do
    expect(@payers.map {|this| this.today}).to eq([Date.today + 1, Date.today + 1, Date.today + 1])
  end
end

RSpec.describe Payer, "#run" do

  before(:all) do
    @results = [{Paycheck1: 0, CC: -1200.920547, Car: -5500.904109},
                {Paycheck1: 0, CC: -1203.3673180759445, Car: -5225.853680835735},
                {Paycheck1: 0, CC: -1206.74408517774, Car: -4950.401706077883}]
  end

  before(:each) do
    @payer = Payer.new(balance: 2000, today: Date.new(2016,1,1))
    @payer.reset
  end

  it "runs one day with correct results" do
    @payer.run(1)
    expect(@payer.accounts[0].balance).to be_within(0.0001).of(@results[0][:Paycheck1])
    expect(@payer.accounts[1].balance).to be_within(0.0001).of(@results[0][:CC])
    expect(@payer.accounts[2].balance).to be_within(0.0001).of(@results[0][:Car])
    expect(@payer.today).to eq(Date.new(2016,1,2))
  end

  it "runs 30 days with correct results" do
    @payer.run(30)
    expect(@payer.accounts[0].balance).to be_within(0.0001).of(@results[1][:Paycheck1])
    expect(@payer.accounts[1].balance).to be_within(0.0001).of(@results[1][:CC])
    expect(@payer.accounts[2].balance).to be_within(0.0001).of(@results[1][:Car])
    expect(@payer.today).to eq(Date.new(2016,1,31))
  end

  it "runs 60 days with correct results" do
    @payer.run(60)
    expect(@payer.accounts[0].balance).to be_within(0.0001).of(@results[2][:Paycheck1])
    expect(@payer.accounts[1].balance).to be_within(0.0001).of(@results[2][:CC])
    expect(@payer.accounts[2].balance).to be_within(0.0001).of(@results[2][:Car])
    expect(@payer.today).to eq(Date.new(2016,3,1))
    end
end

RSpec.describe Payer, "#AD HOC DB TEST" do
  before(:each) do
    @payer = Payer.new(balance: 2000)
    @payer.reset
  end
  it "DOES A THING WITHOUT ERRORRINGGING" do
    DataFetcher.create_balance_table("balances" , @payer)
    DataFetcher.write_balances("balances", @payer)
  end
  it "FILLS UP A TABLE" do
    100.times do
      @payer.run(1)
      DataFetcher.write_balances("balances", @payer)
    end
  end
end
