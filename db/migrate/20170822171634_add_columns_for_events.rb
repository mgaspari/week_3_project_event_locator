class AddColumnsForEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :price_range, :string
  end
end
