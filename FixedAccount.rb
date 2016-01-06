class FixedAccount < Account

  def amount
    @amount
  end

  def compound
    @balance = 0
  end

end
