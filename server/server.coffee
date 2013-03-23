# create a collection to store songs
Songs = new Meteor.Collection "songs"

# import the FileSystem API and get the secret key
secret = "" # init so we don't get a later if there's no key found

fs = __meteor_bootstrap__.require('fs')
path = __meteor_bootstrap__.require('path')
base = path.resolve('.')
isBundle = fs.existsSync(base + '/bundle')
path = base + (if isBundle then '/bundle/static' else '/public') + "/secretkey.txt"

if fs.existsSync path
  secret = fs.readFileSync(path)?.toString()?.replace(/\n/g, '')

console.log "secret: #{secret}"

Meteor.startup ->
  #Songs.remove({})

  # add a test song if there's nothing in the db
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
      # get the parameters from the request
      params = getUrlVars(req.originalUrl)

      # check secret key
      return if params.secret.toString() != secret.toString()

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
    vars[hash[0]] = hash[1]?.replace(/%20/g, ' ')?.replace(/\+/g, ' ')

  vars
