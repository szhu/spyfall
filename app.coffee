window.gameState =
  playing: false

  places: null
  numPlayers: null
  errors: []

  spy: null
  place: null
  currentPlayer: null


assert = (cond, msg) ->
  throw msg unless cond

readNumPlayers = ->
  input = $('#setup-numplayers').val().trim()
  gameState.numPlayers = parseInt(input)

  console.log "Number of players: #{gameState.numPlayers}"
  if isNaN(gameState.numPlayers)
    gameState.errors.push "Enter a valid number of players."
    throw "Enter a valid number of players."
  return

readPlaces = ->
  lines = $('#setup-places').val().split(/[\r\n]+/g)
  gameState.places = []
  for line in lines
    line = line.trim()
    continue if line.length == 0
    gameState.places.push line

  console.log "Places: #{gameState.places}"
  if gameState.places.length == 0
    gameState.errors.push "Enter at least one place!"
    throw "Enter at least one place!"
  return

startPlaying = ->
  $('#reveals').empty()
  for player in [0...gameState.numPlayers]
    $reveal = $('<button class="reveal"></button>')
    $reveal.text(player)
    $reveal.on 'mousedown', do (player) -> (e) ->
      e.preventDefault()
      $(this).addClass 'viewed'
      if player == gameState.spy
        $('#console').text("You are the spy!")
      else
        $('#console').text("Place: #{gameState.places[gameState.place]}")
    $reveal.on 'click mouseup', do (player) -> (e) ->
      e.preventDefault()
      $('#console').text('')
    $('#reveals').append $reveal
  gameState.playing = true

pickSpy = ->
  gameState.spy = _.random(gameState.numPlayers - 1)
  console.log "Spy is: Player #{gameState.spy}"

pickPlace = ->
  gameState.place = _.random(gameState.places.length - 1)
  console.log "Place is: #{gameState.places[gameState.place]} (##{gameState.place})"


autoload = (selector) ->
  $(selector).on 'change keyup keypress', ->
    localStorage[location.href + ' ' + selector] = $(selector).val()
  
  if localStorage[location.href + ' ' + selector]
    $(selector).val(localStorage[location.href + ' ' + selector])

$ ->
  H5F.setup $('.container')

  autoload('#setup-places')
  autoload('#setup-numplayers')
  autosize($('#setup-places'))

  $('#setup-start').click (e) ->
    valid = $('.container')[0].checkValidity?()
    if valid != false
      e.preventDefault()

      readNumPlayers()
      readPlaces()
      pickSpy()
      pickPlace()
      startPlaying()
