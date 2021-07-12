class CreateResultLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :result_links do |t|
      t.references :keyword, foreign_key: true, null: false
      t.integer :link_type, null: false
      t.citext :url, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :result_links, :link_type
    add_index :result_links, :url
  end
end
