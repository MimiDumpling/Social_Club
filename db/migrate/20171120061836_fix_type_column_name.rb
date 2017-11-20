class FixTypeColumnName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :payments, :type, :card_type
  end
end
