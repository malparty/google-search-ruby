# frozen_string_literal: true

require 'csv'

class CSVUploadForm
  include ActiveModel::Validations

  attr_reader :file

  validates_with CSVValidator

  def initialize(user)
    @user = user
  end

  def save(params)
    @file = params[:csv_upload_form][:file]

    return false unless valid?

    begin
      Keyword.transaction do
        # rubocop:disable Rails/SkipsModelValidations
        user.keywords.insert_all parse_keywords
        # rubocop:enable Rails/SkipsModelValidations
      end
    rescue ActiveRecord::StatementInvalid
      errors.add(:keyword, I18n.t('csv.validation.bad_keyword_length'))
    end

    errors.empty?
  end

  private

  attr_reader :user

  def parse_keywords
    time = Time.current
    CSV.read(file.tempfile).filter_map do |row|
      keyword_attributes row.join(','), time
    end
  end

  def keyword_attributes(name, time)
    return nil if name.blank?

    {
      user_id: user.id,
      name: name,
      created_at: time,
      updated_at: time
    }
  end
end
