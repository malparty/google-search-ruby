# frozen_string_literal: true

module FileUploadHelpers
  def save_csv_file(file_name)
    file = file_fixture("csv/#{file_name}")

    form = CSVUploadForm.new(Fabricate(:user))

    saved = form.save({ file: file })

    [form, file, saved]
  end
end
