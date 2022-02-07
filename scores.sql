#
# スコアテーブルの作成
#
DROP TABLE IF EXISTS scores;
CREATE TABLE scores (id int, game int, player int, team int, score real);
.mode csv
.import scores.csv scores
