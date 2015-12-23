require './CreditAccount'
require './Payer'
require 'date'

RSpec.describe CreditAccount, '#initialize' do
  context "with no given data" do
    it "creates a default CreditAccount object" do
      acct = CreditAccount.new
      expect(acct.balance).to eq(0)
      expect(acct.name).to eq("NAME")
    end
  end
  context "with balance and name given" do
    it "creates an CreditAccount object with the correct balance and name" do
      acct = CreditAccount.new({balance: 500, name: "Bank"})
      expect(acct.balance).to eq(500)
      expect(acct.name).to eq("Bank")
    end
  end
end

RSpec.describe CreditAccount, "#compound" do
  context "with rate of 0" do
    it "does not modify balance with rate of 0" do
      acct = CreditAccount.new({balance: 500, rate: 0})
      acct.compound
      expect(acct.balance).to eq(500)
    end
  end
  context "with nonzero rate" do
    it "properly modifies the balance" do
      acct1 = CreditAccount.new({balance: 500, rate: 0.1})
      acct1.compound
      expect(acct1.balance).to eq(550)
      acct2 = CreditAccount.new({balance: 500, rate: -0.1})
      acct2.compound
      expect(acct2.balance).to eq(450)
    end
  end
end

RSpec.describe CreditAccount, "#bill" do
  acct = CreditAccount.new({day: Date.today.day,
                      min_floor: -100,
                      min_rate: 0.05,
                      balance: -1000})
  context "on a non-bill day" do
    it "sends bill of 0" do
      expect(acct.bill(Date.today + 1)).to eq(0)
    end
  end
  context "on a bill day" do
    it "sends min_floor if bigger" do
      expect(acct.bill(Date.today)).to eq(100)
    end
    it "sends min_rate if bigger" do
      acct.balance = -10000
      expect(acct.bill(Date.today)).to eq(500)
    end
  end
end
