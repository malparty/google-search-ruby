# frozen_string_literal: true

class CreateKeywords < ActiveRecord::Migration[6.1]
  def change
    create_table :keywords do |t|
      t.string :name, null: false

      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end

    add_index :keywords, :name
  end
end
