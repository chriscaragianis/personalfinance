require 'date'
require 'json'
require './Account'
require './Payer'

def get_accounts
  accts = []
  Dir.new('accounts').each do |fname|
    if fname.include? "json" then
      accts << Account.new(JSON.parse(File.open("./accounts/#{fname}", "rb").read))
    end
  end
    accts
end

us = Payer.new({balance: 2000});
accts = get_accounts

def sum_balance accts
  (accts.map {|this| this.balance}).reduce(:+)
end

5.times do
  us.day_calc accts
  puts "#{us.balance}, #{sum_balance accts}"
  puts us.to_s
end
