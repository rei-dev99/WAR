class Card
  attr_reader :suit, :value, :int_value

  def initialize(suit, value, int_value)
    @suit = suit
    @value = value
    @int_value = int_value
  end

  def print_card
    "#{@suit}#{@value}(#{@int_value})"
  end
end
