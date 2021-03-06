window.gameState =
  playing: false

  places: null
  numPlayers: null
  errors: []

  spy: null
  place: null


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
  for player in [1..gameState.numPlayers]
    $reveal = $('<button class="reveal"></button>')
    $reveal.text(player)
    $reveal.on 'mousedown', do (player) -> (e) ->
      e.preventDefault()
      $(this).addClass 'viewed'
      if player == gameState.spy
        $('#console').text("You are the spy!\nYou need to figure out where the secret location is.")
      else
        $('#console').text(
          "You are not a spy.\nSecret location: #{gameState.places[gameState.place]}\n" +
          "The spy does not know this location.\n" +
          "You need to figure out who the spy is."
        )
    $reveal.on 'click mouseup', do (player) -> (e) ->
      e.preventDefault()
      $('#console').text('')
    $('#reveals').append $reveal
  gameState.playing = true
  $('#setup-start').text('Restart!')
  $('#console').text(
    "A random location and spy have been chosen!\n" +
    "Each player should now click a card to reveal their role."
  )

pickSpy = ->
  gameState.spy = _.random(1, gameState.numPlayers)
  console.log "Spy is: Player #{gameState.spy}"

pickPlace = ->
  gameState.place = _.random(gameState.places.length - 1)
  console.log "Place is: #{gameState.places[gameState.place]} (##{gameState.place})"


autoload = (selector) ->
  $(selector).on 'change keyup keypress', ->
    localStorage[location.href + ' ' + selector] = $(selector).val()
  
  if localStorage[location.href + ' ' + selector]
    $(selector).val(localStorage[location.href + ' ' + selector])
  else
    resetPlaces()

resetPlaces = ->
  $('#setup-places').val [
    'Lower Sproul'
    'Upper Sproul'
    'Sather Gate'
    'Main Stacks'
    'Underhill'
    'The lower floor of MLK'
    'Zellerbach Hall'
    'A fridge in Ida Sproul Hall'
    'Soda Hall basement'
    'Berkeley Community Theatre'
    'Dwinelle Hall bathrooms'
    'Crossroads'
    'Hearst Parking Structure'
    'Berkeley Rose Garden'
    'Nations in San Pablo'
    'The Campanile'
    'San Jose'
    "People's Park"
    ].join('\n')

  evt = document.createEvent('Event')
  evt.initEvent('autosize:update', true, false)
  $('#setup-places')[0].dispatchEvent(evt)

$ ->
  H5F.setup $('.container')

  autoload('#setup-places')
  autoload('#setup-numplayers')
  autosize($('#setup-places'))

  $('#setup-reset-places').click resetPlaces

  $('#setup-start').click (e) ->
    valid = $('.container')[0].checkValidity?()
    if valid != false
      e.preventDefault()

      readNumPlayers()
      readPlaces()
      pickSpy()
      pickPlace()
      startPlaying()
