json.deck_id @deck.uuid
json.shuffled @deck.shuffled
json.remaining @deck.remaining
json.cards @deck.cards, :value, :suit, :code
