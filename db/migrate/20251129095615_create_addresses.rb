class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :street_address
      t.string :city
      t.references :province, null: false, foreign_key: true
      t.string :postal_code
      t.string :address_type

      t.timestamps
    end
  end
end
