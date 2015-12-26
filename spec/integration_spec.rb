require './Account'
require './Paycheck'
require './Payer'
require 'date'

RSpec.describe 'Test Run' do
  context "60 days with a cc, a car payment and a paycheck" do
    before(:all) do
      @payer = Payer.new(balance: 2000, today: Date.new(2016,1,1), burn: 60)
      @accts = [Account.new(name: "Car", balance: -5500, min_floor: 300, day: 4, rate: 0.06/365),
                Account.new(name: "CC", balance: -1200, min_rate: -0.02, day: 16, rate: 0.28/365),
                Paycheck.new(name: "Paycheck", amount: -2800, weekly: true, week: [2, 0], day: 5)]

    end
    it "#Accounts correct after 1 days" do
      1.times {@payer.day_calc @accts}
      result = [-5500.9041, -1200.921, 0]
      @accts.each_with_index do |val, index|
        expect(val.balance).to be_within(0.001).of(result[index])
      end
    end
    it "#Payer balance correct after 1 days" do
      expect(@payer.balance).to eq(1940)
    end
    it "#Accounts correct after 30 days" do
      29.times {@payer.day_calc @accts}
      result = [-5225.903, -1203.367, 0]
      @accts.each_with_index do |val, index|
        expect(val.balance).to be_within(0.001).of(result[index])
      end
    end
    it "#Payer balance correct after 30 days" do
      expect(@payer.balance).to be_within(0.025).of(5475.685)
    end
    it "#Accounts correct after 60 days" do
      30.times {@payer.day_calc @accts}
      result = [-4950.501, -1206.744, 0]
      @accts.each_with_index do |val, index|
        expect(val.balance).to be_within(0.001).of(result[index])
      end
    end
    it "#Payer balance correct after 60 days" do
      expect(@payer.balance).to be_within(0.025).of(8951.321)
    end
  end
end
