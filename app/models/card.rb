class Card < ApplicationRecord
  belongs_to :deck, counter_cache: :remaining

  validates :suit, inclusion: { in: Deck::SUITS }
  validates :value, inclusion: { in: Deck::VALUES }

  before_create :set_code

  private
    def set_code
      self.code = "#{value[0]}#{suit[0]}"
    end
end
