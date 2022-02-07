#
# チーム名テーブルの作成
#
DROP TABLE IF EXISTS teams;
CREATE TABLE teams (id int, name text);
.mode csv
.import teams.csv teams
