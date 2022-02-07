# mleaguedb
* obtain mleague score from official website and store it to a sqlite3 database.
* see make_database.sh 
## プレイヤー名・チーム名テーブルの作成
* `sqlite3 mleague.sqlite3 ".read players.sql"`
* `sqlite3 mleague.sqlite3 ".read teams.sql"`
## オフィシャルサイトからのデータ取得
* `wget -O scores.html "https://m-league.jp/games/"`
## スコアの読み取り
* `perl data_parse.pl < scores.html`
## スコアを読み取っての整形
* `perl data_parse.pl < scores.html | perl data_name2int.pl > scores.csv`
## スコアテーブルの作成
* `sqlite3 mleague.sqlite3 ".read scores.sql"`
## 以上がこのコードの内容。
## 例として
* `perl taisen.pl` 
* などで、対戦結果の集計などができる。
