require './Account'
class CreditAccount < Account

  def set_defaults
    @rate ||= 0
    @balance ||= 0
    @day ||= 1
    @min_floor ||= 0
    @min_rate ||= 0
    @name ||= "NAME"
  end

  def compound
    @balance += @balance * @rate
  end

  def bill (date)
    (date.day == @day) ? [@min_floor.abs, (@min_rate * @balance).abs].max : 0
  end

  def to_s
    "#{@name}: (Rate: #{@rate}, Balance: #{@balance}, Date: #{@day})"
  end
end
