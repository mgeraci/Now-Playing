# create a collection to store songs
Songs = new Meteor.Collection "songs"

if Meteor.isClient
  Template.hello.greeting = ->
    "See what's playing"

  Template.song_list.songs = ->
    Songs.find {}, sort: {time: -1}

if Meteor.isServer
  # import the FileSystem API and get the secret key
  fs = __meteor_bootstrap__.require('fs')
  secret = fs.readFileSync("secret.txt").toString()

  Meteor.startup ->
    #Songs.remove({})

    # code to run on server at startup
    if Songs.find().count() == 0
      console.log 'we are empty'

      # seed a test song
      params = getUrlVars "whatever?artist=Wilco&title=Side With The Seeds&album=Sky%20Blue%20Sky"
      Songs.insert
        artist: params.artist
        album: params.album
        title: params.title
        time: (new Date()).getTime()

  # define a custom router and path for adding data to the db
  fibers = __meteor_bootstrap__.require("fibers")
  connect = __meteor_bootstrap__.require('connect')
  app = __meteor_bootstrap__.app

  router = connect.middleware.router (route) ->
    route.get '/add_song', (req, res) ->
      Fiber () ->
        console.log 'we hit this route'
        console.log req

        # get the parameters from the request
        params = getUrlVars(req.originalUrl)

        # don't do anything if the request is the same
        # as the most recent entry
        last_song = Songs.findOne {}, sort: {time: -1}
        return if last_song.artist == params.artist && last_song.album == params.album && last_song.title == params.title

        Songs.insert
          artist: params.artist
          album: params.album
          title: params.title
          time: (new Date()).getTime()
      .run()
      res.writeHead(200)
      res.end()

  app.use(router)

# return a hash or parameters from a url
getUrlVars = (req) ->
  vars = []
  hashes = req.slice(req.indexOf('?') + 1).split('&')

  for h in hashes
    hash = h.split('=')
    vars.push(hash[0])
    vars[hash[0]] = hash[1].replace(/%20/g, ' ').replace(/\+/g, ' ')

  vars
