# frozen_string_literal: true

Fabricator(:result_link) do
  link_type { FFaker.rand 3 }
  url { FFaker::Internet.http_url }
end

Fabricator(:result_link_with_keyword, from: :result_link) do
  keyword { Fabricate(:keyword) }
end
