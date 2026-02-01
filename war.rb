require './player'
require './card'
require './zones'
require './deck'

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

    count = nil

    loop do
      print 'プレイヤーの人数を入力してください（2〜5）: '
      count = gets.to_i

      if (2..5).include?(count)
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

    deck = Deck.new
    deck.distribution(@players)

    puts '', "カードは合計で#{deck.size}枚です。"
    @players.each do |player|
      puts "#{player.name}のカードは#{player.cards.length}枚です。"
    end

    draw = Zones.new

    round = 0

    loop do
      round += 1

      # check_round(round)

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
        @show_cards[player] = player.hand.int_value
      end

      max_value = @show_cards.values.max
      max_count = @show_cards.values.count(max_value)
      table_cards = @players.map(&:hand)

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
