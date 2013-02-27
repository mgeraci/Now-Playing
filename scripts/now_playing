#! /usr/bin/env ruby

require 'net/http'
require 'uri'

def clean_string(s)
  return URI.encode s.gsub(/\n/, '')
end

# get secret key for posting to server
f = File.open('/Users/mgeraci/Web/Now-Playing/secretkey.txt', 'r')
while line = f.gets
  secret = line
end
f.close
secret = clean_string secret

# get info from itunes if playing
if `osascript -e 'tell application "iTunes" to get player state'`.gsub(/\s/, '') == 'playing'
  artist = clean_string `osascript -e 'tell application "iTunes" to get artist of current track'`
  album = clean_string `osascript -e 'tell application "iTunes" to get album of current track'`
  title = clean_string `osascript -e 'tell application "iTunes" to get name of current track'`

  puts artist
  puts album
  puts title
  puts secret

  # assemble the url
  if ARGV.to_s == "test"
    domain = "http://127.0.0.1:3000"
  else
    domain = "http://now-playing.meteor.com"
  end
  path = "add_song"
  path = "#{path}?secret=#{secret}&artist=#{artist}&album=#{album}&title=#{title}"
  url = URI.parse "#{domain}/#{path}"

  puts "\nsending the update!"
  Net::HTTP.get_response url
else
  puts 'Nothing is on!'
end
