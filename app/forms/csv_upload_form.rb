# frozen_string_literal: true

require 'csv'

class CSVUploadForm
  include ActiveModel::Validations

  attr_reader :file, :keyword_ids

  validates_with CSVValidator

  def initialize(user)
    @user = user
  end

  def save(file)
    @file = file

    return false unless valid?

    begin
      Keyword.transaction do
        # rubocop:disable Rails/SkipsModelValidations
        @keyword_ids = user.keywords.insert_all(parsed_keywords).map { |keyword_hash| keyword_hash['id'] }
        # rubocop:enable Rails/SkipsModelValidations
      end
    rescue ActiveRecord::StatementInvalid
      errors.add(:base, I18n.t('csv.validation.bad_keyword_length'))
    end

    errors.empty?
  end

  private

  attr_reader :user

  def parsed_keywords
    CSV.read(file.tempfile).filter_map do |row|
      keyword_attributes row.join(',')
    end
  end

  def keyword_attributes(name)
    return nil if name.blank?

    {
      user_id: user.id,
      name: name
    }
  end
end
