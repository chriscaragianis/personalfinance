require 'date'
require './Account'
require './Payer'

us = Payer.new(2000);
accts = [Account.new(0.01, 1000, Date.today, us),
         Account.new(0.01, 1000, Date.today + 1, us),
         Account.new(0.01, 1000, Date.today + 2, us)]
puts us
us.day_calc accts
puts us
us.day_calc accts
puts us
us.day_calc accts
puts us
us.day_calc accts
puts us
