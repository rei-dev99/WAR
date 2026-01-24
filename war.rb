class Player
  attr_reader :name
  attr_accessor :cards, :hands

  def initialize(name)
    @name = name
    @cards = []
    @hands = nil
  end

  def printPlayersCard
    cards.each do |c|
      c.printCard
    end
  end

  def play_card
    @hands = @cards.shift
  end

  def show_hand
    puts "#{@name}のカードは#{@hands.printCard}です。"
  end
end

class Card
  attr_reader :suit ,:value ,:intValue

  def initialize(suit, value, intValue)
    @suit = suit
    @value = value
    @intValue = intValue
  end

  def printCard
    "#{@suit}#{@value}(#{@intValue})"
  end
end

class Zones
  attr_accessor :draw

  def initialize
    @draw = []
  end

  def clear
    @draw.clear
  end

  def length
    @draw.length
  end

  def collect(cards)
    @draw.concat(cards)
  end
end

class Deck
  attr_reader :deck

  def initialize(player_count)
    @deck = self.generateDeck(player_count)
  end

  def generateDeck(player_count)
    suits =
      case player_count
      when 2 then ['♠︎']
      when 3 then ['♠︎', '♣︎']
      when 4 then ['♠︎', '♣︎', '❤︎']
      when 5 then ['♠︎', '♣︎', '❤︎', '♦︎']
      else        ['♠︎']
      end
    values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

    newDeck = []
    suits.each do |s|
      values.each_with_index do |v, i|
        newDeck.push(Card.new(s, v, i+2))
      end
    end
    newDeck
  end

  def printDeck
    @deck.each do |card|
      card.printCard
    end
  end

  def shuffleDeck
    @deck.shuffle!
  end

  def distribution(players)
    (@deck.length).times do |i|
      players[i % players.length].cards << @deck[i]
    end
  end
end

class War
  attr_accessor :players

  def initialize
    @players = []
    @parent = nil
    @show_cards = {}
    @ranking = []
  end

  def setting
    puts '戦争を開始します。'
    print "プレイヤーの人数を入力してください（2〜5）: "
    count = gets.to_i
    count.times do |i|
      print "プレイヤー#{i+1}の名前を入力してください: "
      name = gets.chomp
      @players << Player.new(name)
    end
    @parent = @players.sample
  end

  def start
    setting
    deck = Deck.new(@players.length)
    deck.shuffleDeck
    deck.distribution(@players)
    puts 'カードが配られました。'
    draw = Zones.new

    round = 0
    while true do
      round = round + 1
      if round > 50
        puts ""
        puts "ラウンドが50を超えたので終了します。\n持ってるカードの枚数、脱落順の順位となります。\n"
        rank = 1
        @players.each do |player|
          puts "#{rank}位：#{player.name}は#{player.cards.length}枚持っています。"
          rank += 1
        end
        @ranking.reverse.each do |player|
          puts "#{rank}位：#{player.name}は#{player.cards.length}枚持っています。"
          rank += 1
        end
        exit
      end

      # 終了判定
      if @players.length == 1
        @ranking << @players[0]
        puts "戦争を終了します。\n順位は以下の通りです。"
        @ranking.reverse.each_with_index do |player, i|
          puts "#{i + 1}位：#{player.name}\n手札の枚数は#{player.cards.length}枚です。"
          puts ""
        end
        exit
      end

      @players.each do |player|
        player.play_card
      end

      puts '戦争！'

      # カードをハッシュに格納する
      @show_cards.clear
      @players.each do |player|
        player.show_hand
        @show_cards[player] = player.hands.intValue
      end

      # 最大値を格納して取得
      max_value = @show_cards.values.max
      max_count = @show_cards.values.count(max_value)
      # ハッシュのキーを配列にして場にある手札を格納
      table_cards = @players.map(&:hands)
      puts max_value
      puts max_count

      # 勝者はカードを全てもらう
      if max_count == 1
        winner = @show_cards.key(max_value)
        puts "#{winner.name}が勝ちました。#{winner.name}はカードを#{@players.length + draw.length}枚もらいました。"
        # 勝利したプレイヤーにカードを渡す
        winner.cards.concat(table_cards)
        winner.cards.concat(draw.draw)
        draw.clear
      else
        # ドローに全てのカードを入れる
        draw.collect(table_cards)
        puts '引き分けです。'
      end

      # カードがなくなったら@rankingに移動
      losers =  @players.select { |player| player.cards.empty? }
      losers.each do |loser|
        puts "#{loser.name}はカードがなくなり脱退しました。"
        @ranking << loser
        @players.delete(loser)
      end

    end
  end
end

war = War.new
war.start
