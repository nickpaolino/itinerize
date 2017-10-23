class CreateOutings < ActiveRecord::Migration[5.1]
  def change
    create_table :outings do |t|
      t.string :name
      t.datetime :event_start
      t.datetime :voting_deadline

      t.timestamps
    end
  end
end
