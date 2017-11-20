class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :vendor
      t.integer :user_id
      t.string :token
      t.integer :last_4
      t.string :type

      t.timestamps
    end
  end
end
