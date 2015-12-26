require './Account'
require './Paycheck'
require './Payer'
require 'date'

RSpec.describe Paycheck, "#initialize" do
  context "with no given data" do
    it "creates a default Paycheck object" do
      acct = Paycheck.new
      expect(acct.balance).to eq(0)
      expect(acct.name).to eq("NAME")
    end
  end
  context "with balance and name given" do
    it "creates an Paycheck object with the correct balance and name" do
      acct = Paycheck.new({balance: 500, name: "Bank"})
      expect(acct.balance).to eq(500)
      expect(acct.name).to eq("Bank")
    end
  end
end

RSpec.describe Paycheck, "#bill" do
  context "Day of month paycheck" do
    acct = Paycheck.new({day: Date.today.day,
                        amount: -1000})
    it "sends paycheck of 0 on non-pay day" do
      expect(acct.bill(Date.today + 1)).to eq(0)
    end
    it "sends a regular paycheck on the pay day" do
      expect(acct.bill(Date.today)).to eq(-1000)
    end
  end

  context "Weekly pay" do
    acct = Paycheck.new({weekly: true,
                         day: 5,
                         week: [2, 0],
                         amount: -1000})
    it "sends bill of zero on wrong week" do
      expect(acct.bill(Date.new(2016,1,8))).to eq(0)
    end
    it "sends bill on correct week" do
      expect(acct.bill(Date.new(2016,1,15))).to eq(-1000)
    end
  end
end
