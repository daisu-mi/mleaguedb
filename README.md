# mleaguedb
* Mリーグの公式サイト https://m-league.jp/games からデータを読み取って、対戦成績用のデータベースを作るやつ
** データベースを作るまでが目的なので、それ以降はご自分でどうぞ
** 簡単な動かし方は make_database.sh をご参照ください。(最初のディレクトリの設定を適宜変更してください）
## プレイヤー名・チーム名テーブルの作成
* `sqlite3 mleague.sqlite3 ".read players.sql"`
* `sqlite3 mleague.sqlite3 ".read teams.sql"`
## オフィシャルサイトからのデータ取得
* `wget -O scores.html "https://m-league.jp/games/"`
## スコアの読み取り
* `python3 data_parse.py < scores.html`
* (または)
* `perl data_parse.pl < scores.html`
## スコアを読み取っての整形
* `python3 data_parse.py < scores.html | python3 data_name2int.py > scores.csv`
* (または)
* `perl data_parse.pl < scores.html | perl data_name2int.pl > scores.csv`
## スコアテーブルの作成
* `sqlite3 mleague.sqlite3 ".read scores.sql"`
## 以上です
### テーブルに値を投入してこのコードの役割は終わりです
### テーブルの活用の例として、古いコードですけれど taisen.pl を追加しておきますね
* `perl taisen.pl` 
* などで、対戦結果の集計などができます
