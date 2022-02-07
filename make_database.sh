#!/bin/sh
#
# ディレクトリの移動
#
cd /usr/home/daisuke/ml2
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
perl data_parse.pl < scores.html | perl data_name2int.pl > scores.csv

#
# スコアテーブルの作成
#
sqlite3 mleague.sqlite3 ".read scores.sql"
