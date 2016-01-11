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
    @payer = Payer.new(balance: 2000)
    @accounts = [Account.new(balance:-1000,
                             rate: 0.10*365,
                             day: Date.today.day + 1,
                             amount: 300)]
  end
  it "compounds interest" do
    expect(@payer.day_calc(@accounts, Date.today)[0].balance).to eq(-1100)
  end
  it "pays bills" do
    expect(@payer.day_calc(@accounts, Date.today + 1)[0].balance).to eq(-880)
  end
end

RSpec.describe Payer, "#vest" do
  before(:all) do
    @payer = Payer.new(balance: 2000)
    @accounts = [Account.new(balance:-1000,
                             rate: 0.10*365,
                             day: Date.today.day + 1,
                             amount: 300)]
  end
  it "does not make a vestiture payment when level is not exceeded" do
    result = @payer.vest(@accounts, 0, 2001)
    expect(@payer.balance).to eq(2000)
    expect(result[0].balance).to eq(-1000)
  end
  it "makes a vestiture payment when level is exceeded" do
    result = @payer.vest(@accounts, 0, 1700)
    expect(@payer.balance).to eq(300)
    expect(result[0].balance).to eq(700)
  end
end

RSpec.describe Payer, "#run" do
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
