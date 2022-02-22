# Deck REST API on Rails

Deck REST API written in Go.

## Setup

1. Clone the repo

```shell
git clone git@github.com:rgenchev/deck-api-go.git
```

2. Get all dependencies

```shell
bundle install
```

3. Create DBs

```shell
rails db:setup
```

3. Start the app

```shell
rails s
```

## Usage

Here are the available endpoints:

### Create a new deck

#### Full deck

* create a full unshuffled deck

```shell
curl --request POST \
  --url http://localhost:8080/decks \
  --header 'Content-Type: application/json' \
  --data '{}'
```

Response:
```
{
  "deck_id": "4c997730-337b-4355-9915-a6822be9ef69",
  "shuffled": false,
  "remaining": 52
}
```

* create a full shuffled deck

```shell
curl --request POST \
  --url http://localhost:8080/decks \
  --header 'Content-Type: application/json' \
  --data '{
	"shuffled": true
}'
```

Response:
```
{
  "deck_id": "a103873e-49c8-4f8e-b2b5-2f875818dc70",
  "shuffled": true,
  "remaining": 52
}
```

#### Partial deck

* create a partial unshuffled deck (e.g.: Let's say you need a deck with the following cards: "AS,KD,AC,2C,KH")

```shell
curl --request POST \
  --url 'http://localhost:8080/decks?cards=AS%2CKD%2CAC%2C2C%2CKH' \
  --header 'Content-Type: application/json' \
  --data '{}'
```

Response:
```
{
  "deck_id": "86c28785-1768-40d8-875a-079b336dec7b",
  "shuffled": false,
  "remaining": 5
}
```

* create a partial shuffled deck

```shell
curl --request POST \
  --url 'http://localhost:8080/decks?cards=AS%2CKD%2CAC%2C2C%2CKH' \
  --header 'Content-Type: application/json' \
  --data '{
	"shuffled": true
}'
```

Response:
```
{
  "deck_id": "7e95acfe-eec3-4e69-aeb7-0c472b47a5bf",
  "shuffled": true,
  "remaining": 5
}
```

### Open an existing deck

```shell
curl --request GET \
  --url http://localhost:8080/decks/{:uuid}
```

Example:
```shell
curl --request GET \
  --url http://localhost:8080/decks/86c28785-1768-40d8-875a-079b336dec7b
```

Response:
```
{
  "deck_id": "86c28785-1768-40d8-875a-079b336dec7b",
  "shuffled": false,
  "remaining": 5,
  "cards": [
    {
      "value": "ACE",
      "suit": "SPADES",
      "code": "AS"
    },
    {
      "value": "KING",
      "suit": "DIAMONDS",
      "code": "KD"
    },
    {
      "value": "ACE",
      "suit": "CLUBS",
      "code": "AC"
    },
    {
      "value": "2",
      "suit": "CLUBS",
      "code": "2C"
    },
    {
      "value": "KING",
      "suit": "HEARTS",
      "code": "KH"
    }
  ]
}
```

### Draw a card from a deck

When you draw a card from a deck, the `remaining` field is updated.

```shell
curl --request GET \
  --url http://localhost:8080/decks/{:uuid}/draw/{:drawn_cards_count}
```

Example:
```shell
curl --request GET \
  --url http://localhost:8080/decks/86c28785-1768-40d8-875a-079b336dec7b/draw/1
```

Response:
```
{
  "cards": [
    {
      "value": "KING",
      "suit": "HEARTS",
      "code": "KH"
    }
  ]
}
```

## Run the tests

```shell
rails test
```

