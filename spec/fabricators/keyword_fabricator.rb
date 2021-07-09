# frozen_string_literal: true

Fabricator(:keyword) do
  name { FFaker::FreedomIpsum.word }
  user { Fabricate(:user) }
end

Fabricator(:keyword_with_result, from: :keyword) do
  name { FFaker::FreedomIpsum.word }
  user { Fabricate(:user) }

  status :parsed

  ads_top_count { FFaker.rand 6 }
  ads_page_count { |attrs| attrs[:ads_top_count] + FFaker.rand(3) }
  non_ads_result_count { |attrs| 15 + attrs[:ads_top_count] }
  total_link_count { |attrs| FFaker.rand(30) + attrs[:non_ads_result_count] }

  html { FFaker::HTMLIpsum.body }
end
