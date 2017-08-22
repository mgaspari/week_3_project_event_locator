class DeletingExtraColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :min_money
    remove_column :events, :price
    remove_column :events, :state
    remove_column :events, :time
    remove_column :events, :most_money
  end
end
