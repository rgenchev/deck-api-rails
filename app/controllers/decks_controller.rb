class DecksController < ApplicationController
  before_action :set_deck, only: [:show, :draw]

  def show; end

  def create
    @deck = Deck.new
    @deck.shuffled = params[:shuffled]

    if params[:cards]
      @deck.selected_card_codes = params[:cards].split(",")
    end

    if @deck.save
      render status: :created
    else
      render json: @deck.errors.to_json, status: :unprocessable_entity
    end
  end

  def draw
    drawn_cards_count = params[:count].to_i

    if @deck.remaining < drawn_cards_count
      render json: { message: "Not enough cards in the deck. Please check the number of cards remaining and modify the count parameter." }, status: :bad_request and return
    end

    @drawn_cards = @deck.cards.last(drawn_cards_count)
    @deck.cards = @deck.cards.where.not(id: @drawn_cards.pluck(:id))

    render status: :ok
  end

  private
    def set_deck
      @deck = Deck.find_by(uuid: params[:uuid])

      render json: { message: "Deck not found" }, status: :not_found and return if @deck.nil?
    end
end
