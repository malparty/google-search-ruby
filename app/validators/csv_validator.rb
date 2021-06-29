# frozen_string_literal: true

class CSVValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(attribute, I18n.t('csv.validation.blank')) if is_blank?
    record.errors.add(attribute, I18n.t('csv.validation.too_many_keywords')) if has_too_many_keywords?
    record.errors.add(attribute, I18n.t('csv.validation.readable')) unless is_readable?
  end

  private

  def is_blank?
    true
  end

  def has_too_many_keywords?
    true
  end

  def is_readable?
    true
  end
end
