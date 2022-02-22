require "test_helper"

class DecksControllerTest < ActionDispatch::IntegrationTest
  test "should open an existing deck" do
    deck = Deck.create(shuffled: false)
    get deck_url(deck), as: :json

    resp = JSON.parse(response.body)

    assert_response :success
    assert_equal deck.uuid, resp["deck_id"]
    assert_equal deck.shuffled, resp["shuffled"]
    assert_equal deck.remaining, resp["remaining"]

    resp["cards"].each do |card|
      refute_nil card["value"]
      refute_nil card["suit"]
      refute_nil card["code"]
    end
  end

  test "should return not found if the deck does not exist" do
    get deck_url("non-existing-deck"), as: :json

    resp = JSON.parse(response.body)

    assert_response :not_found
    assert_equal "Deck not found", resp["message"]
  end

  test "should create a new unshuffled deck when not passing shuffled param" do
    assert_difference "Deck.count", 1 do
      post decks_url, params: {}, as: :json
    end

    deck = Deck.last
    resp = JSON.parse(response.body)

    assert_response :created
    assert_equal 52, deck.cards.count
    assert_equal 52, deck.remaining
    refute deck.shuffled

    assert_equal ["deck_id", "shuffled", "remaining"], resp.keys
    assert_equal deck.uuid, resp["deck_id"]
    assert_equal deck.shuffled, resp["shuffled"]
    assert_equal deck.remaining, resp["remaining"]
  end

  test "should create a new unshuffled deck when passing falsey shuffled param" do
    assert_difference "Deck.count", 1 do
      post decks_url, params: {
        shuffled: false
      }, as: :json
    end

    deck = Deck.last
    resp = JSON.parse(response.body)

    assert_response :created
    assert_equal 52, deck.cards.count
    assert_equal 52, deck.remaining
    refute deck.shuffled

    assert_equal ["deck_id", "shuffled", "remaining"], resp.keys
    assert_equal deck.uuid, resp["deck_id"]
    assert_equal deck.shuffled, resp["shuffled"]
    assert_equal deck.remaining, resp["remaining"]
  end

  test "should create a new shuffled deck when passing truthy shuffled param" do
    assert_difference "Deck.count", 1 do
      post decks_url, params: {
        shuffled: true
      }, as: :json
    end

    deck = Deck.last
    resp = JSON.parse(response.body)

    assert_response :created
    assert_equal 52, deck.cards.count
    assert_equal 52, deck.remaining
    assert deck.shuffled

    assert_equal ["deck_id", "shuffled", "remaining"], resp.keys
    assert_equal deck.uuid, resp["deck_id"]
    assert_equal deck.shuffled, resp["shuffled"]
    assert_equal deck.remaining, resp["remaining"]
  end

  test "should create a new unshuffled deck only with selected cards" do
    assert_difference "Deck.count", 1 do
      post decks_url(cards: "AS,KD,AC,2C,KH"), as: :json
    end

    deck = Deck.last
    resp = JSON.parse(response.body)

    assert_response :created
    assert_equal 5, deck.cards.count
    assert_equal 5, deck.remaining
    refute deck.shuffled

    assert_equal ["deck_id", "shuffled", "remaining"], resp.keys
    assert_equal deck.uuid, resp["deck_id"]
    assert_equal deck.shuffled, resp["shuffled"]
    assert_equal deck.remaining, resp["remaining"]
  end

  test "should create a new shuffled deck only with selected cards" do
    assert_difference "Deck.count", 1 do
      post decks_url(cards: "AS,KD,AC,2C,KH"), params: {
        shuffled: true
      }, as: :json
    end

    deck = Deck.last
    resp = JSON.parse(response.body)

    assert_response :created
    assert_equal 5, deck.cards.count
    assert_equal 5, deck.remaining
    assert deck.shuffled

    assert_equal ["deck_id", "shuffled", "remaining"], resp.keys
    assert_equal deck.uuid, resp["deck_id"]
    assert_equal deck.shuffled, resp["shuffled"]
    assert_equal deck.remaining, resp["remaining"]
  end

  test "should draw number of cards from a given deck" do
    deck = Deck.create(shuffled: false)

    get deck_draw_url(deck, 1), as: :json

    assert_response :success
    resp = JSON.parse(response.body)

    assert_equal ["cards"], resp.keys
    assert_equal "KH", resp["cards"][0]["code"]
    assert_equal "QH", deck.cards.last.code
  end

  test "should not be able to draw more cards than there are in the deck" do
    deck = Deck.create(shuffled: false)

    get deck_draw_url(deck, 53), as: :json

    assert_response :bad_request
    resp = JSON.parse(response.body)

    assert_equal "Not enough cards in the deck. Please check the number of cards remaining and modify the count parameter.", resp["message"]
  end
end
