require './Account'
require './FixedAccount'
require './Scenario'
require 'date'

RSpec.describe FixedAccount, "#initialize" do
  context "with no given data" do
    it "creates a default FixedAccount object" do
      acct = FixedAccount.new
      expect(acct.balance).to eq(0)
      expect(acct.acct_name).to eq("NAME")
    end
  end
  context "with balance and name given" do
    it "creates an FixedAccount object with the correct balance and name" do
      acct = FixedAccount.new({balance: 500, acct_name: "Bank"})
      expect(acct.balance).to eq(500)
      expect(acct.acct_name).to eq("Bank")
    end
  end
end

RSpec.describe FixedAccount, "#bill" do
  context "Day of month FixedAccount" do
    acct = FixedAccount.new({day: Date.today.day,
                        amount: -1000})
    it "sends FixedAccount of 0 on non-pay day" do
      expect(acct.bill(Date.today + 1)).to eq(0)
    end
    it "sends a regular FixedAccount on the pay day" do
      expect(acct.bill(Date.today)).to eq(-1000)
    end
  end

  context "Weekly pay" do
    acct = FixedAccount.new({weekly: 1,
                         day: 5,
                         week_period: 2,
                         week_offset: 0,
                         amount: -1000})
    it "sends bill of zero on wrong week" do
      expect(acct.bill(Date.new(2016,1,8))).to eq(0)
    end
    it "sends bill on correct week" do
      expect(acct.bill(Date.new(2016,1,15))).to eq(-1000)
    end
  end
end
