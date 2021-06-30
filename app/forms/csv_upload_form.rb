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
    self.file = params[:file]

    return false unless valid?

    keywords_attr = valid_keywords_attributes

    # rubocop:disable Rails/SkipsModelValidations
    user.keywords.insert_all keywords_attr
    # rubocop:enable Rails/SkipsModelValidations

    errors.empty?
  end

  private

  attr_writer :file

  def valid_keywords_attributes
    parse_keywords.select(&:validate).map { |k| k.attributes.except('id') }.to_a
  end

  def parse_keywords
    CSV.read(file).map do |row|
      new_bulk_keyword row[0]
    end
  end

  def new_bulk_keyword(name)
    Keyword.new(user_id: user.id, name: name, created_at: Time.current, updated_at: Time.current, bulk_insert: true)
  end

  attr_reader :user
end
