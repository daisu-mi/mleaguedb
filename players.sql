#
# 選手名テーブルの作成
#
DROP TABLE IF EXISTS players;
CREATE TABLE players (id int, name text, team int);
.mode csv
.import players.csv players
