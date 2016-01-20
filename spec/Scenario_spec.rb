require './Account'
require './Scenario'
require 'date'

#options hashes

day_calc_1 = {balance: -1000, day: Date.today.day, amount: 100, rate: 0.2*365}
day_calc_2 = {balance: -1100, day: Date.today.day, amount: 100, rate: 0.2*365}
balrec_1 = {balance: 500, date: Date.today}
balrec_2 = {balance: 400, date: Date.today + 1}
week_hash = {weekly: 1, week_offset: 0, week_period: 1, day: 5}
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
    @scene = Scenario.new
    acct_in = Account.new(day_calc_1)
    acct_out = Account.new(day_calc_2)
    @balrec_in = BalanceRecord.new(balrec_1.merge({accounts: [acct_in]}))
    @balrec_out = BalanceRecord.new(balrec_2.merge({accounts: [acct_out]}))
    @result = @scene.day_calc @balrec_in
  end

  it "Result has correct date" do
    expect(@result.date).to eq(@balrec_out.date)
  end

  it "Result has correct balance" do
    expect(@result.balance).to eq(@balrec_out.balance)
  end

  it "Result has correct account balance" do
    expect(@result.accounts[0].balance).to eq(@balrec_out.accounts[0].balance)
  end
end

RSpec.describe Scenario, "#run" do
  before(:all) do
    acct_1 = FixedAccount.new(week_hash.merge({amount: -100}))
    acct_2 = Account.new(balance: -200, day: 24, min_rate: -0.02, rate: 0.25)
    acct_3 = Account.new(balance: -400, day: 22, amount: 100, rate: 0.06)
    @scene = Scenario.new(vest_targets: [1,2], vest_level: 600, accounts: [acct_1, acct_2, acct_3])
    @scene.balances = [BalanceRecord.new(date: Date.new(2016,1,20), balance: 500, accounts: [acct_1, acct_2, acct_3])]
    @scene.run(Date.new(2016,1,20), Date.new(2016,2,19))
  end

  it "results in the right size balance array" do
    expect(@scene.balances.length).to eq(31)
  end

  it "has the right last day" do
    expect(@scene.balances.last.date).to eq(Date.today + 30)
  end

  it "has the right last balance" do
    expect(@scene.balances.last.balance).to be_within(0.0001).of(296.882920)
  end

  it "has the right account balances on day 16" do
    expect(@scene.balances[16].accounts[1].balance).to be_within(0.0001).of(-198.1590145175953)
    expect(@scene.balances[16].accounts[2].balance).to be_within(0.0001).of(-300.83944331)
  end

end

RSpec.describe Scenario, "#vest" do
  before(:all) do
    acct_1 = Account.new(balance: -200, day: Date.today.day, amount: 100, rate: 0.2*365)
    acct_2 = Account.new(balance: -200, day: Date.today.day, amount: 100, rate: 0.2*365)
    acct_3 = Account.new(balance: -400, day: Date.today.day, amount: 100, rate: 0.2*365)
    @scene = Scenario.new(vest_targets: [0,1,2])
    @scene.balances = [BalanceRecord.new(date: Date.today, balance: 500, accounts: [acct_1, acct_2, acct_3])]
    @scene.vest(0, 500)
  end

  it "removes the money from the balance" do
    expect(@scene.balances[0].balance).to eq(0)
  end

  it "applies to the first vest option" do
    expect(@scene.balances[0].accounts[0].balance).to eq(0)
  end

  it "applies to the second vest option" do
    expect(@scene.balances[0].accounts[1].balance).to eq(0)
  end

  it "applies to the third vest option" do
    expect(@scene.balances[0].accounts[2].balance).to eq(-300)
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
    result = @scene.run_balances(Date.today, 4, @accounts)
    expect(result.map { |row| row.map { |acct| acct.balance } }).to eq([[-1000], [-900], [-900], [-900]])
  end
end
