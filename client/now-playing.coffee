# create a collection to store songs
Songs = new Meteor.Collection "songs"

Template.hello.greeting = ->
  "See what's playing"

Template.song_list.songs = ->
  Songs.find {}, sort: {time: -1}
