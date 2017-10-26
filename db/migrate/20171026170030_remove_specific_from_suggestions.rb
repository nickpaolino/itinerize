class RemoveSpecificFromSuggestions < ActiveRecord::Migration[5.1]
  def change
    remove_column(:suggestions, :specific)
  end
end
