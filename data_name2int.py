#!/usr/bin/python3 -u

import sys,os,re
import fileinput
import sqlite3

i=1
game=''
players={}
teams={}

con = sqlite3.connect('mleague.sqlite3')
cur = con.cursor()
sql = "SELECT players.id, players.name, teams.id FROM players, teams WHERE players.team = teams.id ORDER BY players.id"
for row in cur.execute(sql):
    id,player,team=row[:3]
    players[player] = int(id)
    teams[player] = int(team)

for buf in sys.stdin:
    buf = re.sub('\r','',buf)
    buf = re.sub('\n','',buf)

    game,player,score = buf.split(',')[:3]
    print("%d,%s,%d,%d,%s" % (i,game,players[player],teams[player],score))
    i = i + 1
