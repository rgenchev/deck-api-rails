class Deck < ApplicationRecord
  has_many :cards, -> { order(created_at: :asc) }, dependent: :destroy

  validates :uuid, :remaining, presence: true
  validates :uuid, uniqueness: { case_sensitive: false }

  validates_inclusion_of :shuffled, in: [true, false]

  before_validation :set_uuid, on: :create
  after_commit :generate_cards, on: :create

  SUITS = ["SPADES", "DIAMONDS", "CLUBS", "HEARTS"]
  VALUES = ["ACE", "2", "3", "4", "5", "6", "7", "8", "9", "10", "JACK", "QUEEN", "KING"]

  attr_accessor :selected_card_codes

  def shuffled=(value)
    super(value.present? && value.to_s.downcase == "true")
  end

  def to_param
    uuid
  end

  private
    def set_uuid
      begin
        self.uuid = SecureRandom.uuid
      end while Deck.exists?(uuid: uuid)
    end

    def generate_cards
      suits = shuffled ? SUITS.shuffle : SUITS
      values = shuffled ? VALUES.shuffle : VALUES

      suits.each do |suit|
        values.each do |value|
          if selected_card_codes.is_a?(Array) && selected_card_codes.any?
            generate_card_and_append_to_cards(suit, value) if card_selected?(suit, value)
          else
            generate_card_and_append_to_cards(suit, value)
          end
        end
      end
    end

    def card_selected?(suit, value)
      selected_card_codes.include?("#{value[0]}#{suit[0]}")
    end

    def generate_card_and_append_to_cards(suit, value)
      cards << Card.create(suit: suit, value: value)
    end
end
