#!/usr/bin/python3 -u

import sys,os,re
import fileinput
player=''
year=0
month=0
day=0
kaisen=0
flag_point=0

for buf in sys.stdin:
    buf = re.sub('\r','',buf)
    buf = re.sub('\n','',buf)

    if flag_point==1:
        buf = re.sub(' ','',buf)
        buf = re.sub('\t','',buf)
        buf = re.sub('▲','-',buf)
        buf = buf.replace('pt','',1)
        buf = re.sub('\(.*\)','',buf)
        point=buf

        if year>=2021:
            print("%04d%02d%02d%02d,%s,%s" % (year,month,day,kaisen,player,point))
        flag_point=0
        continue 

    buf_search=re.search('<div class=\"p-gamesResult__date\">(\d+)\/(\d+)<',buf)
    if buf_search:
        month=int(buf_search.group(1))
        day=int(buf_search.group(2))
        if month>=10:
            year=2021
        else:
            year=2022
        continue 

    buf_search=re.search('<div class=\"p-gamesResult__number\">[^0-9]+([0-9])[^0-9]+',buf)
    if buf_search:
        kaisen=int(buf_search.group(1))

    buf_search=re.search('<div class=\"p-gamesResult__name\">(.+)<\/div>',buf)
    if buf_search:
        player=buf_search.group(1)
        continue 

    if re.search('<div class=\"p-gamesResult__point\">',buf):
        flag_point=1
        continue 
