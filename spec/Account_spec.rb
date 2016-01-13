require './Account'
require './Scenario'
require 'date'

RSpec.describe Account, "#initialize" do
  context "with no given data" do
    it "creates a default Account object" do
      acct = Account.new
      expect(acct.balance).to eq(0)
      expect(acct.acct_name).to eq("NAME")
    end
  end
  context "with balance and name given" do
    it "creates an Account object with the correct balance and name" do
      acct = Account.new({balance: 500, acct_name: "Bank"})
      expect(acct.balance).to eq(500)
      expect(acct.acct_name).to eq("Bank")
    end
  end
end

RSpec.describe Account, "#compound" do
  context "with rate of 0" do
    it "does not modify balance with rate of 0" do
      acct = Account.new({balance: -500, rate: 0})
      acct.compound
      expect(acct.balance).to eq(-500)
    end
  end
  context "with nonzero rate" do
    it "properly modifies the balance" do
      acct1 = Account.new({balance: -500, rate: 0.1})
      acct1.compound
    end
  end
end

RSpec.describe Account, "#bill" do
  context "Day of month bill" do
    acct = Account.new({day: Date.today.day,
                        min_floor: 100,
                        min_rate: -0.05,
                        balance: -1000})
    it "sends bill of 0 on non-bill day" do
      expect(acct.bill(Date.today + 1)).to eq(0)
    end
    it "sends a min bill on the bill day" do
      expect(acct.bill(Date.today)).to eq(100)
      acct.balance = -10000
      expect(acct.bill(Date.today)).to eq(500)
    end
  end

  context "Weekly bill" do
    acct = Account.new({weekly: 1,
                        day: 5,
                        week_period: 2,
                        week_offset: 1,
                        min_floor: 100,
                        min_rate: -0.05,
                        balance: -1000})
    it "sends bill of zero on wrong week" do
      expect(acct.bill(Date.new(2016,1,15))).to eq(0)
    end
    it "sends bill on correct week" do
      expect(acct.bill(Date.new(2016,1,22))).to eq(100)
    end
  end
end
