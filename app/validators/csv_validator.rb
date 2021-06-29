# frozen_string_literal: true

class CSVValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:file, I18n.t('csv.validation.blank')) if is_blank?
    record.errors.add(:file, I18n.t('csv.validation.too_many_keywords')) if has_too_many_keywords?
    record.errors.add(:file, I18n.t('csv.validation.readable')) unless is_readable?
  end

  private

  def is_blank?
    false
  end

  def has_too_many_keywords?
    false
  end

  def is_readable?
    true
  end
end
