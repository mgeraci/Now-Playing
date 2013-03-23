# set pagination settings on session
page_size = 20
Session.set "number_of_visible_songs", page_size

# create a collection to store songs
Songs = new Meteor.Collection "songs"

Template.hello.greeting = ->
  "See what's playing"

Template.song_list.songs = ->
  Songs.find({}, sort: {time: -1}, limit: Session.get "number_of_visible_songs")
  .map (row)->
    {
      time: decodeURIComponent row.time
      artist: decodeURIComponent row.artist
      album: decodeURIComponent row.album
      title: decodeURIComponent row.title
    }

Template.song_list.events =
  "click #more": (e)->
    e.preventDefault()
    count = Session.get("number_of_visible_songs") + page_size
    Session.set "number_of_visible_songs", count
