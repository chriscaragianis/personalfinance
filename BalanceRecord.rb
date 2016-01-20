class BalanceRecord
  attr_accessor :date, :balance, :accounts

  def set_defaults
    @date ||= Date.today
    @balance ||= 0
    @accounts ||= []
    @name ||= "NAME"
  end

  def initialize params = {}
    params.each { |key,value| instance_variable_set("@#{key}", value) }
    set_defaults
  end

  def <=> other
    self.date <=> other.date
  end

  def to_s
    "Day: #{@date}, Bal: #{@balance}, #{@accounts.map { |acct| acct.balance }}"
  end

end
