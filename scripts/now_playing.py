#!/usr/bin/env python

import httplib, urllib, sys
from pylms.server import Server
from pylms.player import Player

print u"\u03A9"

# get the secret key
f = open('/Users/mgeraci/Web/Now-Playing/secretkey.txt', 'r')
secret = f.readline().strip()

# set the domain (pass test in as an arg to get localhost)
domain = "now-playing.meteor.com"

if len(sys.argv[1:]) > 0:
  if sys.argv[1:][0] == 'test':
    domain = "127.0.0.1:3000"

# connect to the squeezebox
sc = Server(hostname="192.168.1.111", port=9090)
sc.connect()
sq = sc.get_player("00:04:20:07:98:43")

print "Logged in: %s" % sc.logged_in
print "Version: %s" % sc.get_version()

if sq.get_mode() == 'play':
  artist = sq.get_track_artist()
  album = sq.get_track_album()
  title = sq.get_track_title()

  print "%s - %s - %s" % (artist, album, title)
  print ""

  params = urllib.urlencode({'artist': artist, 'album': album, 'title': title, 'secret': secret})
  conn = httplib.HTTPConnection(domain)
  url = "/add_song?%s" % (params)

  print "posting..."
  conn.request('GET', url)
  response = conn.getresponse()

  print response.status, response.reason

  conn.close()
elif sq.get_mode() == 'stop':
  print "Nothing's playing"
