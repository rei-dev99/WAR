class Player
  attr_reader :name
  attr_accessor :cards, :hands

  def initialize(name)
    @name = name
    @cards = []
    @hands = nil
  end

  def print_players_card
    cards.each(&:print_card)
  end

  def play_card
    @hands = @cards.shift
  end

  def show_hand
    puts "#{@name}のカードは#{@hands.print_card}です。"
  end
end

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

class Deck
  attr_reader :deck

  def initialize(player_count)
    @deck = generate_deck(player_count)
  end

  def generate_deck(player_count)
    suits =
      case player_count
      when 2 then ['♠︎']
      when 3 then ['♠︎', '♣︎']
      when 4 then ['♠︎', '♣︎', '❤︎']
      when 5 then ['♠︎', '♣︎', '❤︎', '♦︎']
      else        ['♠︎']
      end
    values = %w[2 3 4 5 6 7 8 9 10 J Q K A]

    new_deck = []
    suits.each do |s|
      values.each_with_index do |v, i|
        new_deck.push(Card.new(s, v, i + 2))
      end
    end
    new_deck
  end

  def printDeck
    @deck.each(&:print_card)
  end

  def shuffle
    @deck.shuffle!
  end

  def size
    @deck.size
  end

  def distribution(players)
    @deck.length.times do |i|
      players[i % players.length].cards << @deck[i]
    end
  end
end

class War
  attr_accessor :players

  def initialize
    @start = false
    @players = []
    @parent = nil
    @show_cards = {}
    @ranking = []
  end

  def setting
    puts '戦争を開始します。'

    count = nil

    loop do
      print 'プレイヤーの人数を入力してください（2〜5）: '
      count = gets.to_i

      if (2..5).include?(count)
        @start = true
        break
      else
        puts '入力を間違えているのでやり直してください。'
      end
    end
    count.times do |i|
      print "プレイヤー#{i + 1}の名前を入力してください: "
      name = gets.chomp
      @players << Player.new(name)
    end
    @parent = @players.sample
  end

  def check_round(round)
    if round > 50
      puts '', "ラウンドが50を超えたので終了します。\n持ってるカードの枚数、脱落順の順位となります。", ''

      sorted_players = @players.sort_by { |player| player.cards.length }
      all_players = sorted_players.reverse + @ranking.reverse

      rank = 1
      all_players.each do |player|
        puts "#{rank}位：#{player.name}はカードを#{player.cards.length}枚持っています。"
        rank += 1
      end

      exit
    end
  end

  def check_loser
    losers = @players.select { |player| player.cards.empty? }
    losers.each do |loser|
      puts "#{loser.name}はカードがなくなり脱退しました。"
      @ranking << loser
      @players.delete(loser)
    end
  end

  def start
    setting
    deck = Deck.new(@players.length)
    deck.shuffle
    deck.distribution(@players)

    puts '', "カードは合計で#{deck.size}枚です。"
    @players.each do |player|
      puts "#{player.name}のカードは#{player.cards.length}枚です。"
    end

    draw = Zones.new

    round = 0
    loop do
      round += 1

      check_round(round)

      if @players.length == 1
        @ranking << @players[0]
        puts '', '戦争を終了します。順位は以下の通りです。', ''
        @ranking.reverse.each_with_index do |player, i|
          puts "#{i + 1}位：#{player.name}\n手札の枚数は#{player.cards.length}枚です。", ''
        end
        exit
      end

      @players.each(&:play_card)

      puts '', '戦争！'

      @show_cards.clear

      @players.each do |player|
        player.show_hand
        @show_cards[player] = player.hands.int_value
      end

      max_value = @show_cards.values.max
      max_count = @show_cards.values.count(max_value)
      table_cards = @players.map(&:hands)

      if max_count == 1
        winner = @show_cards.key(max_value)
        puts "#{winner.name}が勝ちました。#{winner.name}はカードを#{@players.length + draw.size}枚もらいました。"
        winner.cards.concat(table_cards)
        winner.cards.concat(draw.draw)
        draw.clear
      else
        draw.collect(table_cards)
        puts '引き分けです。'
      end
      check_loser
    end
  end
end

war = War.new
war.start
