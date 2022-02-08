#!/bin/sh
#
# ディレクトリの設定（適宜変更してください）
#
#cd /anywhere/mleaguedb
#
# プレイヤー名・チーム名テーブルの作成
#
sqlite3 mleague.sqlite3 ".read players.sql"
sqlite3 mleague.sqlite3 ".read teams.sql"

#
# ウェブからのデータ取得
#
wget -O scores.html "https://m-league.jp/games/"

#
# スコアのパース
#
python3 data_parse.py < scores.html | python3 data_name2int.py > scores.csv
#perl data_parse.pl < scores.html | perl data_name2int.pl > scores.csv

#
# スコアテーブルの作成
#
sqlite3 mleague.sqlite3 ".read scores.sql"
