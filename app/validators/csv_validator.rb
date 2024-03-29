# frozen_string_literal: true

require 'csv'

class CSVValidator < ActiveModel::Validator
  def validate(csv_form)
    @csv_form = csv_form

    validate_file
  end

  private

  attr_reader :csv_form

  def file
    csv_form.file
  end

  def validate_file
    add_error :wrong_count unless valid_count?
    add_error :wrong_type unless valid_extension?
  end

  def add_error(type)
    csv_form.errors.add(:base, I18n.t("csv.validation.#{type}"))
  end

  def valid_count?
    CSV.read(file.tempfile).count.between?(1, 1000)
  end

  def valid_extension?
    file.content_type == 'text/csv'
  end
end
