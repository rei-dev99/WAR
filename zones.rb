class Zones
  attr_reader :draw

  def initialize
    @draw = []
  end

  def clear
    @draw.clear
  end

  def size
    @draw.size
  end

  def collect(cards)
    @draw.concat(cards)
  end
end
