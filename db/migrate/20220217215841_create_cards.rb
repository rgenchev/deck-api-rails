class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :value
      t.string :suit
      t.string :code
      t.references :deck, foreign_key: true

      t.timestamps
    end
  end
end
