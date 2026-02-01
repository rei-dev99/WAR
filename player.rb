class Player
  attr_reader :name
  attr_accessor :cards, :hand

  def initialize(name)
    @name = name
    @cards = []
    @hand = nil
  end

  def print_players_card
    cards.each(&:print_card)
  end

  def play_card
    @hand = @cards.shift
  end

  def show_hand
    puts "#{@name}のカードは#{@hand.print_card}です。"
  end
end
