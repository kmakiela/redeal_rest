# Redeal library exposed with REST API using Phoenix

## Used components:
* `redeal` - deal generator written in python - [repo](https://github.com/anntzer/redeal)
* `phoenix` - web framework written in elixir - [repo](https://github.com/phoenixframework/phoenix)
* `rabbitmq` - message broker used for communication. Deatils [here](https://www.rabbitmq.com/)

## Running
To run, you need to have `redeal`, `phoenix` and `rabbitmq` installed. After that, simply use 
```
./run
```

To clean up all running processes use
```
./clean
```

## API
There are endpoints available for openings on 1- and 2- level
* **deal/random** - random deal
* **deal/1nt** - standard 1nt, 15-17 balanced
* **deal/1s** - standard 1s, 12+ PC, 5+ S
* **deal/1h** - standard 1h, 12+ PC, 5+ H
* **deal/1d** - standard 1d, 12+ PC, 5+ D
* **deal/2c** - custom 2c, 5+4+ in majors, weak
* **deal/2d** - multi, 6 card major, weak
* **deal/2h** - Muiderberg, 5+ H 4+ minor, weak
* **deal/2s** - Muiderberg, 5+ S 4+ minor, weak
