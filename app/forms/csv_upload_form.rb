# frozen_string_literal: true

require 'csv'

class CSVUploadForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attr_accessor :file

  validates_with CSVValidator

  def initialize(user)
    @user = user
    # super({})
  end

  def save(params)
    file = params[:file]
    @file = params[:file]
    # assign_attributes params

    return false unless valid?

    user_id = user.id

    keywords = CSV.read(file).map do |row|
      Keyword.new(user_id: user_id, name: row[0], created_at: Time.current, updated_at: Time.current)
    end

    # TODO: Bulk validation makes repetitive SQL Query for USER!!!!!
    keywords_attr = keywords.select(&:validate).map { |k| k.attributes.except('id') }.to_a

    Rails.logger.debug keywords_attr

    # rubocop:disable Rails/SkipsModelValidations
    user.keywords.insert_all keywords_attr
    # rubocop:enable Rails/SkipsModelValidations

    errors.empty?
  end

  private

  attr_reader :user
end
