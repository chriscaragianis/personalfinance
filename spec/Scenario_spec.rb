require './Account'
require './Scenario'
require 'date'

RSpec.describe Scenario, '#initialize' do
  context "with no given data" do
    it "creates a default Scenario object" do
      scenario = Scenario.new
      expect(scenario.balance).to eq(0)
      expect(scenario.today).to eq(Date.today)
    end
  end
  context "with date and balance given" do
    it "creates a Scenario object with correct balance and date" do
      scenario = Scenario.new(today: (Date.today + 1), balance: 2000)
      expect(scenario.balance).to eq(2000)
      expect(scenario.today).to eq(Date.today + 1)
    end
  end
end

RSpec.describe Scenario, "#day_calc" do
  before(:all) do
    @scenario = Scenario.new(balance: 2000)
    @accounts = [Account.new(balance:-1000,
                             rate: 0.10*365,
                             day: Date.today.day + 1,
                             amount: 300)]
  end
  it "compounds interest" do
    expect(@scenario.day_calc(@accounts, Date.today)[0].balance).to eq(-1100)
  end
  it "pays bills" do
    expect(@scenario.day_calc(@accounts, Date.today + 1)[0].balance).to eq(-880)
  end
end

RSpec.describe Scenario, "#vest" do
  before(:all) do
    @scenario = Scenario.new(balance: 2000)
    @accounts = [Account.new(balance:-1000,
                             rate: 0.10*365,
                             day: Date.today.day + 1,
                             amount: 300)]
  end
  it "does not make a vestiture payment when level is not exceeded" do
    result = @scenario.vest(@accounts, 0, 2001)
    expect(@scenario.balance).to eq(2000)
    expect(result[0].balance).to eq(-1000)
  end
  it "makes a vestiture payment when level is exceeded" do
    result = @scenario.vest(@accounts, 0, 1700)
    expect(@scenario.balance).to eq(300)
    expect(result[0].balance).to eq(700)
  end
end

RSpec.describe Scenario, "#AD HOC DB TEST" do
  before(:each) do
    @scenario = Scenario.new(balance: 2000)
    @scenario.reset
  end
  it "DOES A THING WITHOUT ERRORRINGGING" do
    DataFetcher.create_balance_table("balances" , @scenario)
    DataFetcher.write_balances("balances", @scenario)
  end
  it "FILLS UP A TABLE" do
    100.times do
      @scenario.run(1)
      DataFetcher.write_balances("balances", @scenario)
    end
  end
end

RSpec.describe Scenario, "CHEK IT" do
  before (:all) do
    @accounts = [Account.new(balance: -1000, day: Date.today.day + 1, amount: 100)]
    @scene = Scenario.new(balance: 1000, accounts: @accounts)
  end
  it "does a thing" do
    result = @scene.run_balances(Date.today, 4)
    expect(result.map { |row| row.map { |acct| acct.balance } }).to eq([[-1000], [-900], [-900], [-900]])
  end
end
