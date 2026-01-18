def war
  # プレイヤーは2名
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

  # カードを全て格納してシャッフルする
  deck = (card_spade + card_club + card_heart + card_dia).shuffle

  # 52個あるカードでループし、均等にプレーヤーに配る
  puts '戦争を開始します。'
  (deck.length).times do |i|
    players[i % players.length] << deck[i]
  end
  puts 'カードが配られました。'

  while true do

    # 先頭の手札を取り出す。
    p1 = player1.shift
    p2 = player2.shift
    
    puts '戦争！'
    
    puts "プレイヤー1のカードは#{p1}です。"
    puts "プレイヤー2のカードは#{p2}です。"
    
    # player1,player2で配列の0番目にあるカードを展開して強さを比べる、正規表現にて数字かアルファベットを取り出してそれをメソッドに送って判定させる
    if cardStrongs(p1) > cardStrongs(p2)
        puts 'プレイヤー1が勝ちました。'
        player1 << p2
        player1.shuffle
        puts '戦争を終了します。'
        exit
    elsif cardStrongs(p1) < cardStrongs(p2)
        puts 'プレイヤー2が勝ちました。'
        player2 << p1
        player2.shuffle
        puts '戦争を終了します。'
        exit
    else
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
