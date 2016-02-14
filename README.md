Spyfall
-------

Spyfall is a multi-player in-person game in which each player is either:

 - a spy and has to find a secret location, or
 - a civilian and is given the location.

The civilians must work together to determine who the spy is.


This project is inspired by a similar project, [https://github.com/evanbrumley/spyfall](https://github.com/evanbrumley/spyfall), which in turn was inspired by [an actual game you can buy](http://international.hobbyworld.ru/catalog/25-spyfall/). This project is endorsed by neither.


This repo contains a variant of the game, with these changes:

 - Custom locations
 - No roles except civilian and spy
 - Offline gameplay (once the page loads)
 - Single-device gameplay (pass the computer/phone around)
 - One thing well: This project automates only the aspect of the game that is impossible to do manually, i.e. pick a random location and give it to all but one player.

To serve app files yourself, `cd` into it and `python -m SimpleHTTPServer`.
