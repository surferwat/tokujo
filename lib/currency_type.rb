class CurrencyType
  VALUES = {
    USD: 0,
    JPY: 1
  }.freeze

  def self.values
    VALUES
  end
end