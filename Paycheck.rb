class Paycheck < Account
  def weekly_bill (date)
    @balance = 0
    (date.cweek % @week[0] == @week[1] && date.cwday == @day) ? @amount : 0
  end

  def monthly_bill (date)
    @balance = 0
    (date.day == @day) ? @amount : 0
  end

end
