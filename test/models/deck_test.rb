require "test_helper"

class DeckTest < ActiveSupport::TestCase
  test "should generate unshuffled cards for a deck marked as unshuffled" do
    deck = Deck.create(
      shuffled: false
    )

    assert_equal ["ACE", "2", "3", "4", "5", "6", "7", "8", "9", "10", "JACK", "QUEEN", "KING"], deck.cards.pluck(:value).uniq
    assert_equal 52, deck.cards.count
  end

  test "should generate shuffled cards for a deck marked as shuffled" do
    deck = Deck.create(
      shuffled: true
    )

    refute_equal ["ACE", "2", "3", "4", "5", "6", "7", "8", "9", "10", "JACK", "QUEEN", "KING"], deck.cards.pluck(:value).uniq
    assert_equal 52, deck.cards.count
  end

  test "should generate a deck with selected cards" do
    deck = Deck.create(shuffled: false, selected_card_codes: ["AS", "KD", "AC", "2C", "KH"])

    assert_equal ["ACE", "KING", "ACE", "2", "KING"], deck.cards.pluck(:value)
    assert_equal 5, deck.cards.count
  end
end
