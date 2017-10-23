class CreateUserOutings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_outings do |t|
      t.integer :user_id
      t.integer :outing_id

      t.timestamps
    end
  end
end
