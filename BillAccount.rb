class BillAccount < Account

  def set_defaults
    @day ||= 1
    @name ||= "NAME"
    @amount ||= 0
  end

  def bill (date)
    (date.day == @day) ? @amount : 0
  end

end
