class CreateFavoriteTable < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :event_id
    end
  end
end
