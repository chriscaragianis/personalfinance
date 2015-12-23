class PayAccount < Account

  def set_defaults
    @weeks ||= 0
    @amount ||= 0
    @min_floor ||= 0
    @min_rate ||= 0
    @balance ||= 0
  end

  def bill (date)
    (date.cweek % 2 == 0 && date.cwday == 5) ? @min_floor : 0
  end
end
