# ExMon
---
## Introduction
This project was build following the Udemys "Elixir e Phoenix do zero! Crie sua primeira API Phoenix" course, and was implemented to fix the Elixir concepts.

This project consists on a minigame inpired by Pokemon battle system (hence the name ExMon). Check the game rules below.

## Game rules
- A player must be created with the following parameters:
    - Name (must be a `string`)
    - Attack with random power (must be an `atom`)
        - Deals (10 - 35) damage
    - Attack with medium power (must be an `atom`)
        - Deals (18 - 25) damage
    - Heal movement (must be an `atom`)
        - Heals (18 - 25) life points 
- When starting the game, a computer player will be made automatically
- The player can choose one of the 3 movements each round
- The game ends when one of the players reaches 0 life points

## How to run the game
After cloning this repository locally, run `mix deps.get` to install the dependencies, then run `iex -S mix` to start the cli, and the following commands to start the game:
```sh
# To create the player
# Ex: player = ExMon.create_player("Zero", :saber, :buster, :heal)
$ player = ExMon.create_player(<name>, <random_attack>, <medium_attack>, <heal_move>)

#To start the game
$ ExMon.start_game(player)
```

After that the game status will be printed on the console. To make a move on your turn, use the commando `ExMon.make_move(<movement>)`

## Challenges
After finishing the implementation, the course teacher gave 3 challenges to implement on the game:
1. Cover all the application with tests
2. The first player to make a move must be choosen randomly
3. The chance to the computer heal himself must be higher when hist life is below 40 life points.

All of the 3 challeges were implemented and can be found in the source code!
