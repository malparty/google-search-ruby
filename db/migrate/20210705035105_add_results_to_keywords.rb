class AddResultsToKeywords < ActiveRecord::Migration[6.1]
  def change
    add_column :keywords, :status, :integer, default: 0
    add_column :keywords, :ads_top_count, :integer
    add_column :keywords, :ads_page_count, :integer
    add_column :keywords, :non_ads_result_count, :integer
    add_column :keywords, :total_link_count, :integer
    add_column :keywords, :html, :text

    add_index :keywords, :status
    add_index :keywords, :ads_top_count
    add_index :keywords, :ads_page_count
    add_index :keywords, :non_ads_result_count
    add_index :keywords, :total_link_count

    create_table :result_links do |t|
      t.references :keyword, foreign_key: true, null: false
      t.integer :link_type, null: false
      t.citext :url, null: false

      t.timestamps
    end

    add_index :result_links, :link_type
    add_index :result_links, :url
  end
end
