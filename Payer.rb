class Payer
  def initialize balance, today = Date.today
    @balance = balance
    @today = today
  end

  def deduct amount
    @balance -= amount
  end

  def pay acct, amount
    deduct amount
    acct.balance -= amount
  end


  def day_calc accounts
    accounts.each do |acct|
      acct.compound
      pay acct, acct.bill
      puts acct.to_s
    end
    @today += 1
  end

  def to_s
    "MONEY HAVE: #{@balance} ON: #{@today.to_s}"
  end
end
