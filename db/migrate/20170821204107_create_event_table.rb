class CreateEventTable < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.text :name
      t.integer :price
      t.text :city
      t.text :state
      t.time :time
      t.date :date
      t.text :url
      t.integer :most_money
      t.integer :min_money
    end
  end
end
