# frozen_string_literal: true

module API
  module V1
    module Pagy
      module JSONAPIConcern
        private

        def pagy_options(pagy)
          {
            meta: { total_pages: pagy.pages },
            links: pagy_options_links(pagy)
          }
        end

        def pagy_options_links(pagy)
          {
            first: url_for_page(1),
            self: url_for_page(pagy.page),
            next: url_for_page(pagy.next),
            prev: url_for_page(pagy.prev),
            last: url_for_page(pagy.last)
          }
        end

        def url_for_page(page)
          return nil unless page

          url_for only_path: false, params: jsonapi_params.merge(page: page)
        end

        def jsonapi_params
          params.permit(:page, :sort, :filter)
        end
      end
    end
  end
end
