# frozen_string_literal: true

require 'csv'

class CSVValidator < ActiveModel::Validator
  def validate(csv_form)
    file = csv_form.file

    add_error :blank if file.blank?
    add_error :wrong_count unless valid_count? file
    add_error :wrong_type unless valid_extension? file
    add_error :not_readable unless file.readable?
  end

  private

  def valid_count?(file)
    CSV.read(file).count.between?(1, 1000)
  end

  def valid_extension?(file)
    file.extname == '.csv'
  end

  def add_error(type)
    csv_form.errors.add(:file, I18n.t("csv.validation.#{type}"))
  end
end
