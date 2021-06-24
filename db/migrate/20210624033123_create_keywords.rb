class CreateKeywords < ActiveRecord::Migration[6.1]
  def change
    create_table :keywords do |t|
      t.string :name, null: false

      t.references :user, index: true, null: false

      t.timestamps
    end

    add_index :keywords, :name

    add_foreign_key(
      :keywords,
      :users,
      column: :user_id
    )
  end
end
