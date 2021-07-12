# frozen_string_literal: true

Fabricator(:result_link) do
  keyword { Fabricate(:keyword) }
  link_type { FFaker.rand 3 }
  url { FFaker::Internet.http_url }
end
