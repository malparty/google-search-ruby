# frozen_string_literal: true

require 'rails_helper'

describe API::V1::KeywordsController, type: :request do
  describe 'GET #index' do
    context 'given one page of keywords' do
      it 'returns the right number of keywords' do
        user = Fabricate(:user)
        Fabricate.times(15, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(json_response[:data].count).to eq(15)
      end

      it 'does not display the HTML attribute' do
        user = Fabricate(:user)
        Fabricate.times(15, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(json_response[:data].first[:attributes].keys).not_to include(:html)
      end

      it 'does not include any additional data such as the result_links' do
        user = Fabricate(:user)
        Fabricate.times(15, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(json_response[:included]).to be_nil
      end
    end

    context 'when more than a page of keywords' do
      it 'returns the first page of keywords' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(json_response[:data].count).to eq(50)
      end

      it 'returns the total_pages meta info' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(json_response[:meta][:total_pages]).to eq(2)
      end

      it 'returns the links to related pages' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(json_response[:links].keys).to contain_exactly(:self, :first, :prev, :next, :last)
      end
    end

    context 'given a valid page param' do
      it 'returns the keywords for that page' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index, params: { page: 2 }

        expect(json_response[:data].count).to eq(1)
      end
    end

    context 'given an invalid page param' do
      it 'returns a 422 Unprocessable Entity status code' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index, params: { page: 10 }

        expect(response.status).to eq(422)
      end
    end

    context 'given an unauthenticated user' do
      it 'returns a 401 status code' do
        get :index

        expect(response.status).to eq(401)
      end
    end

    context 'when keyword_list is empty' do
      it 'returns an empty data array', authenticated_api_user: true do
        get :index

        expect(json_response[:data].count).to eq(0)
      end
    end

    context 'given a keyword_pattern param' do
      it 'returns only the keywords matching that pattern' do
        user = create_token_header

        %w[freeride FREERUN Freedom unfreeze not matching keyword].each { |name| Fabricate(:keyword, user: user, name: name) }

        get :index, params: { keyword_pattern: '^(unfree|free)' }

        expect(json_response[:data].length).to eq(4)
      end
    end

    context 'given a link_types param' do
      it 'returns only the keywords having one or many matching result_link' do
        user = create_token_header

        10.times { Fabricate(:result_link, keyword: Fabricate(:keyword, user: user), link_type: :ads_top) }
        5.times { Fabricate(:result_link, keyword: Fabricate(:keyword, user: user), link_type: :non_ads) }

        get :index, params: { link_types: [:ads_top] }

        expect(json_response[:data].length).to eq(10)
      end

      it 'counts the right url_match_count' do
        user = create_token_header

        Fabricate.times(10, :result_link, keyword: Fabricate(:keyword, user: user), link_type: :ads_top)
        Fabricate.times(5, :result_link, keyword: Fabricate(:keyword, user: user), link_type: :non_ads)

        get :index, params: { link_types: [:ads_top] }

        expect(json_response[:meta][:url_match_count]).to eq(10)
      end
    end

    context 'given an url_pattern param' do
      it 'returns only the keywords having one or many matching result_link' do
        user = create_token_header

        %w[http://technology.vn www.hello.vn/technology www.not-matching.th http://neither.match].each { |url| Fabricate(:result_link, keyword: Fabricate(:keyword, user: user), url: url) }

        get :index, params: { url_pattern: '(.vn){1}' }

        expect(json_response[:data].length).to eq(2)
      end

      it 'counts the right url_match_count' do
        user = create_token_header

        %w[http://technology.vn www.hello.vn/technology www.not-matching.th http://neither.match].each { |url| Fabricate(:result_link, keyword: Fabricate(:keyword, user: user), url: url) }

        get :index, params: { url_pattern: '(.vn){1}' }

        expect(json_response[:meta][:url_match_count]).to eq(2)
      end
    end

    context 'given an AdWords link_types and a (technology|technology.vn)$ url_pattern params' do
      it 'counts the right url_match_count' do
        user = create_token_header

        Fabricate.times(10, :result_link, keyword: Fabricate(:keyword, user: user), link_type: %i[ads_top ads_page].sample, url: %w[http://technology.vn www.hello.com/technology].sample)
        Fabricate.times(15, :result_link, keyword: Fabricate(:keyword, user: user), url: 'https://technologies.com')

        get :index, params: { link_types: [ResultLink.link_types[:ads_top].to_s, ResultLink.link_types[:ads_page].to_s], url_pattern: '(technology|technology.vn)$' }

        expect(json_response[:meta][:url_match_count]).to eq(10)
      end
    end
  end

  describe 'POST #create' do
    context 'given a valid file' do
      it 'saves the keywords in the DB', authenticated_api_user: true do
        params = file_api_params 'valid.csv'

        expect { post :create, params: params }.to change(Keyword, :count).by(8)
      end

      it 'returns the upload_success meta message', authenticated_api_user: true do
        post :create, params: file_api_params('valid.csv')

        expect(JSON.parse(response.body)['meta']).to eq(I18n.t('csv.upload_success'))
      end

      it 'responds with a 200 OK status code', authenticated_api_user: true do
        post :create, params: file_api_params('valid.csv')

        expect(response.status).to eq(200)
      end

      it 'queues a Google::DistributeSearchJob job', authenticated_api_user: true do
        expect { post :create, params: file_api_params('valid.csv') }.to have_enqueued_job(Google::DistributeSearchJob)
      end
    end

    context 'given an invalid file' do
      it 'does not save any new keyword', authenticated_api_user: true do
        params = file_api_params 'too_many_keywords.csv'

        expect { post :create, params: params }.to change(Keyword, :count).by(0)
      end

      it 'returns an errors object', authenticated_api_user: true do
        post :create, params: file_api_params('too_many_keywords.csv')

        expect(JSON.parse(response.body)['errors'].keys).to contain_exactly('details', 'code', 'status')
      end

      it 'responds with a 422 Unprocessable Entity status code', authenticated_api_user: true do
        post :create, params: file_api_params('too_many_keywords.csv')

        expect(response.status).to eq(422)
      end

      it 'does not queue any job', authenticated_request_user: true do
        expect { post :create, params: file_api_params('too_many_keywords.csv') }.not_to have_enqueued_job
      end
    end
  end

  describe 'GET #show' do
    context 'given an unparsed keyword' do
      it 'has the keyword type' do
        keyword = Fabricate(:keyword)

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:data][:type]).to eq('keyword')
      end

      it 'has a pending status' do
        keyword = Fabricate(:keyword)

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:data][:attributes][:status]).to eq('pending')
      end

      it 'has a name' do
        keyword = Fabricate(:keyword, name: 'specific_name')

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:data][:attributes][:name]).to eq('specific_name')
      end

      it 'has a nil html attribute' do
        keyword = Fabricate(:keyword)

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:data][:attributes][:html]).to be_nil
      end
    end

    context 'given a parsed keyword without result_links' do
      it 'has an empty result_links relationship' do
        keyword = Fabricate(:keyword_parsed)

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:data][:relationships][:result_links][:data]).to be_empty
      end

      it 'has an empty included element' do
        keyword = Fabricate(:keyword_parsed)

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:included]).to be_empty
      end
    end

    context 'given a parsed keyword with 5 result_links' do
      it 'counts 5 included items' do
        keyword = Fabricate(:keyword_parsed)

        keyword.result_links = Fabricate.times(5, :result_link, keyword: keyword)

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:included].length).to eq(5)
      end

      it 'includes urls starting with http' do
        keyword = Fabricate(:keyword_parsed)

        keyword.result_links = Fabricate.times(5, :result_link, keyword: keyword)

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:included].map { |incl| incl[:attributes][:url] }).to all(start_with 'http')
      end

      it 'includes valid link_type items' do
        keyword = Fabricate(:keyword_parsed)

        keyword.result_links = Fabricate.times(5, :result_link, keyword: keyword)

        create_token_header(keyword.user)

        get :show, params: { id: keyword.id }

        expect(json_response[:included].map { |incl| incl[:attributes][:link_type] }).to all(eq('ads_top').or(eq('ads_page')).or(eq('non_ads')))
      end
    end

    context 'given an invalid id' do
      it 'returns an errors element' do
        create_token_header(Fabricate(:user))

        get :show, params: { id: 0 }

        expect(json_response.keys).to include(:errors)
      end

      it 'returns a 404 Not Found status code' do
        create_token_header(Fabricate(:user))

        get :show, params: { id: 0 }

        expect(response.status).to eq(404)
      end
    end
  end
end
