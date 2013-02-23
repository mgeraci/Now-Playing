# create a collection to store songs
Songs = new Meteor.Collection "songs"

if Meteor.isClient
  Template.hello.greeting = ->
    "See what's playing"

  Template.song_list.songs = ->
    Songs.find()

if Meteor.isServer
  Meteor.startup ->
    #Songs.remove({})

    # code to run on server at startup
    params = getUrlVars "whatever?artist=Wilco&title=Side With The Seeds&album=Sky%20Blue%20Sky"
    console.log params.artist, params.title, params.album

    if Songs.find().count() == 0
      console.log 'we are empty'
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
    route.get '/foo', (req, res) ->
      Fiber () ->
        params = getUrlVars(req.originalUrl)
        name = params.name
        #return Songs.insert({name: name, score: 0})
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
