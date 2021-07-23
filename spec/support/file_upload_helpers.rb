# frozen_string_literal: true

module FileUploadHelpers
  module Form
    def save_csv_file(file_name)
      form = CSVUploadForm.new(Fabricate(:user))

      saved = form.save(uploaded_file(file_name))

      [form, saved]
    end

    def uploaded_file(file_name)
      file = file_fixture("csv/#{file_name}")

      type = MIME::Types.type_for(file.extname).first.content_type

      ActionDispatch::Http::UploadedFile.new({ tempfile: file, type: type })
    end
  end

  module System
    def submit_file(name)
      visit root_path

      page.attach_file('csv_upload_form_file', Rails.root.join('spec', 'fixtures', 'files', 'csv', name), visible: :all)
    end
  end

  module Request
    def file_api_params(file_name)
      path = Rails.root.join('spec', 'fixtures', 'files', 'csv', file_name)

      { file: Rack::Test::UploadedFile.new(path, 'text/csv', true) }
    end

    def file_params(file_name)
      { csv_upload_form: file_api_params(file_name) }
    end
  end
end
