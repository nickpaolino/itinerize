class CreateSuggestions < ActiveRecord::Migration[5.1]
  def change
    create_table :suggestions do |t|
      t.string :name
      t.string :address
      t.boolean :specific
      t.integer :user_id
      t.integer :outing_id

      t.timestamps
    end
  end
end
