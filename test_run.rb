require_relative "./Payer"

@payer = Payer.new(balance: 20000, today: Date.new(2016,1,8), burn: 20)
@payer.reset
DataFetcher.create_balance_table("balances", @payer)
1000.times do
  @payer.run(1)
  DataFetcher.write_balances("balances", @payer)
  if (@payer.balance < 0) then
    puts "BROKEN!"
  end
end
sum = 0
@payer.accounts.each {|acct| sum += acct.balance}
sum += @payer.balance
puts sum
