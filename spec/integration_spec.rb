require './CreditAccount'
require './BillAccount'
require './PayAccount'
require './Payer'
require 'date'

RSpec.describe 'Test Run' do
  context "60 days with a cc, a car payment and a paycheck" do
    before(:all) do
      @payer = Payer.new(balance: 2000)
      @accts = [CreditAccount.new(balance: 5500, min_floor: 300, day: 4, rate: 0.06/365),
                CreditAccount.new(balance: 1200, min_rate: 0.02, day: 16, rate: 0.25/365),
                PayAccount.new(min_floor: -2800, weeks: 2, day: 5)]

    end
    it "#Accounts correct after 30 days" do
      30.times {@payer.day_calc @accts}
      expect(@accts.map {|this| this.balance}).to eq([5226.713, 1202.445, 0])
    end
    it "#Payer balance correct after 30 days" do
      expect(@payer.balance).to eq(5415.722)
    end
    it "#Accounts correct after 60 days" do
      30.times {@payer.day_calc @accts}
      expect(@accts.map {|this| this.balance}).to eq([4949.588, 1205.819, 0])
    end
    it "#Payer balance correct after 60 days" do
      expect(@payer.balance).to eq(8711.358)
    end
  end
end
