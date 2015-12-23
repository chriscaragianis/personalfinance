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
    defaults = {rate: 0.01, min_rate: 0.02, min_floor: -100}
    @accts = [CreditAccount.new(defaults.merge({day: Date.today.day, balance: -1000})),
             CreditAccount.new(defaults.merge({day: Date.today.day + 1, balance: -1000})),
             CreditAccount.new(defaults.merge({day: Date.today.day, balance: -10000}))]
    @payers.each_with_index {|payer, index| payer.day_calc [@accts[index]]}
  end
  it "Compounds interest properly" do
    expect(@accts[1].balance).to eq(-1010)
  end
  it "Deducts from payer balance properly" do
    expect(@payers.map {|this| this.balance}).to eq([900, 1000, 798])
  end
  it "Reduces account balances properly" do
    expect(@accts.map {|this| this.balance}).to eq([-910,-1010,-9898])
  end
  it "advances the date" do
    expect(@payers.map {|this| this.today}).to eq([Date.today + 1, Date.today + 1, Date.today + 1])
  end
end
