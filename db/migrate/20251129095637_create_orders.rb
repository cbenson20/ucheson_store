class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.string :status, default: "pending"
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :tax_amount, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.string :payment_id

      t.timestamps
    end
  end
end
