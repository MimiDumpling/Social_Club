class RemoveTextFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :text, :text
  end
end
