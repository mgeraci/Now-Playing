# set pagination settings on session
page_size = 20
Session.set "number_of_visible_songs", page_size

# create a collection to store songs
Songs = new Meteor.Collection "songs"

Template.hello.greeting = ->
  "See what's playing"

Template.song_list.songs = ->
  Songs.find {}, sort: {time: -1}, limit: Session.get "number_of_visible_songs"

Template.song_list.events =
  "click #more": (e)->
    count = Session.get("number_of_visible_songs") + page_size
    Session.set "number_of_visible_songs", count
