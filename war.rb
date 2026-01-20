def war
  player1 = []
  player2 = []
  players = [player1, player2]

  # 親を決める
  parent = "player" + (rand(players.length) + 1).to_s

  # カードを52枚用意
  card_spade = ["スペードの2","スペードの3","スペードの4","スペードの5","スペードの6","スペードの7","スペードの8","スペードの9","スペードの10","スペードのJ","スペードのQ","スペードのK","スペードのA"]
  card_club = ["クラブの2","クラブの3","クラブの4","クラブの5","クラブの6","クラブの7","クラブの8","クラブの9","クラブの10","クラブのJ","クラブのQ","クラブのK","クラブのA"]
  card_heart = ["ハートの2","ハートの3","ハートの4","ハートの5","ハートの6","ハートの7","ハートの8","ハートの9","ハートの10","ハートのJ","ハートのQ","ハートのK","ハートのA"]
  card_dia = ["ダイヤの2","ダイヤの3","ダイヤの4","ダイヤの5","ダイヤの6","ダイヤの7","ダイヤの8","ダイヤの9","ダイヤの10","ダイヤのJ","ダイヤのQ","ダイヤのK","ダイヤのA"]

  # カードの全てを格納してシャッフルする
  deck = (card_spade + card_club + card_heart + card_dia).shuffle

  puts '戦争を開始します。'
  # 52個あるカードでループし、均等にプレーヤーに配る
  (deck.length).times do |i|
    players[i % players.length] << deck[i]
  end
  puts 'カードが配られました。'

  # 引き分け時にカードを保持する
  draw = []

  while true do
    # 終了判定！
    if player1.empty? || player2.empty?
      p1_total = player1.length
      p2_total = player2.length

      winner = ''
      if player1.empty?
        puts 'プレイヤー1の手札がなくなりました。'
        p2_total += draw.length
        winner = 'プレイヤー2が1位、プレイヤー1が2位です。'
      elsif player2.empty?
        puts 'プレイヤー2の手札がなくなりました。'
        p1_total += draw.length
        winner = 'プレイヤー1が1位、プレイヤー2が2位です。'
      end
      puts "プレイヤー1の手札の枚数は#{p1_total}枚です。プレイヤー2の手札の枚数は#{p2_total}枚です。"
      puts winner

      puts '戦争を終了します。'
      exit
    end

    # 先頭の手札を取り出す
    p1 = player1.shift
    p2 = player2.shift

    puts '戦争！'

    puts "プレイヤー1のカードは#{p1}です。"
    puts "プレイヤー2のカードは#{p2}です。"

    # player1,player2で配列の0番目にあるカードを展開して強さを比べる
    if cardStrongs(p1) > cardStrongs(p2)
      puts "プレイヤー1が勝ちました。プレイヤー1はカードを#{players.length + draw.length}枚もらいました。"
      player1 << p1 << p2
      player1.concat(draw)
      draw.clear
    elsif cardStrongs(p1) < cardStrongs(p2)
      puts "プレイヤー2が勝ちました。プレイヤー2はカードを#{players.length + draw.length}枚もらいました。"
      player2 << p1 << p2
      player2.concat(draw)
      draw.clear
    else
      draw << p1 << p2
      puts '引き分けです。'
    end
  end
end

# カードの得点取得
def cardStrongs(card)
    strongs = {
        "2" => 2,
        "3" => 3,
        "4" => 4,
        "5" => 5,
        "6" => 6,
        "7" => 7,
        "8" => 8,
        "9" => 9,
        "10" => 10,
        "J" => 11,
        "Q" => 12,
        "K" => 13,
        "A" => 14
    }

    # カードから数字とアルファベットを取得
    matches = card.scan(/[A-Z0-9]/)
    # ハッシュから得点を取得
    score = strongs[matches.join]
    score
end

war
