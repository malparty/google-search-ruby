class AddDiscardedAtToUsersAndKeywords < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :discarded_at, :datetime
    add_index :users, :discarded_at

    add_column :keywords, :discarded_at, :datetime
    add_index :keywords, :discarded_at
  end
end
