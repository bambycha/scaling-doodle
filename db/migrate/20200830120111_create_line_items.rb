class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.integer :product_id, null: false, index: true
      t.references :cart, null: false, foreign_key: true
      t.integer :quantity, default: 1, null: false
      t.string :title, null: false
      t.decimal :price, null: false

      t.timestamps
    end
  end
end
