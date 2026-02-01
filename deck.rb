class Deck
  attr_reader :deck

  def initialize
    suits = ['♠︎', '♣︎', '❤︎', '♦︎']
    values = %w[2 3 4 5 6 7 8 9 10 J Q K A]

    new_deck = []

    suits.each do |s|
      values.each_with_index do |v, i|
        new_deck.push(Card.new(s, v, i + 2))
      end
    end

    new_deck.shuffle!

    @cards = new_deck
  end

  def print_deck
    @cards.each(&:print_card)
  end

  def size
    @cards.size
  end

  def distribution(players)
    @cards.length.times do |i|
      players[i % players.length].cards << @cards[i]
    end
  end
end
