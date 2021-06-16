class RenameNamesForUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :lastname, :last_name
    rename_column :users, :firstname, :first_name
  end
end
