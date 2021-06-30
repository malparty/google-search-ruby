# frozen_string_literal: true

require 'csv'

class CSVUploadForm
  include ActiveModel::Validations

  attr_reader :file, :keywords

  validates_with CSVValidator

  def initialize(user)
    @user = user
  end

  def save(params)
    @file = params[:file]
    @keywords = parse_keywords

    return false unless valid?

    keywords_attr = keywords_attributes

    # rubocop:disable Rails/SkipsModelValidations
    user.keywords.insert_all keywords_attr
    # rubocop:enable Rails/SkipsModelValidations

    errors.empty?
  end

  private

  def keywords_attributes
    parse_keywords.map { |k| k.attributes.except('id') }.to_a
  end

  def parse_keywords
    CSV.read(file).map do |row|
      new_bulk_keyword row.join(',')
    end
  end

  def new_bulk_keyword(name)
    Keyword.new(user_id: user.id, name: name, created_at: Time.current, updated_at: Time.current, bulk_insert: true)
  end

  attr_reader :user
end
