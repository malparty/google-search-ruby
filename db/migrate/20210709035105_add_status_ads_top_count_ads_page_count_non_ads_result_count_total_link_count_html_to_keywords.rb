class AddStatusAdsTopCountAdsPageCountNonAdsResultCountTotalLinkCountHtmlToKeywords < ActiveRecord::Migration[6.1]
  def change
    add_column :keywords, :status, :integer, default: 0, null: false
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
  end
end
