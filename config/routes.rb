Rails.application.routes.draw do
  resources :decks, only: [:create, :show], param: :uuid
  get "/decks/:uuid/draw/:count", to: "decks#draw", as: :deck_draw
end
