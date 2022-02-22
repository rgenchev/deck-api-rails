class CreateDecks < ActiveRecord::Migration[7.0]
  def change
    create_table :decks do |t|
      t.string :uuid
      t.boolean :shuffled
      t.integer :remaining, default: 0

      t.timestamps
    end

    add_index :decks, :uuid, unique: true
  end
end
