class CreateTableUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, primary_key: :id do |t|
      t.string :name
    end
  end
end
