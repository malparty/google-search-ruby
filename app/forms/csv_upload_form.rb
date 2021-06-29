# frozen_string_literal: true

require 'csv'

class CSVUploadForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :file

  validates_with CSVValidator

  def initialize(user)
    @user = user
  end

  def save(params)
    Rails.logger.debug 'THAT?'
    file = params[:file]
    # Rails.logger.debug 'OR THAT?'
    # assign_attributes(params)

    return false unless valid?

    keywords = CSV.read(file).map do |row|
      # Keyword.create(user_id: user.id, name: row[0]) # created_at: Time.current, updated_at: Time.current
      Keyword.new(user_id: user.id, name: row[0], created_at: Time.current, updated_at: Time.current)
    end

    Rails.logger.debug keywords

    # keywords = keywords.select(&:validate).to_a
    ActiveRecord::Base.transaction { keywords.each(&:save) }

    # rubocop:disable Rails/SkipsModelValidations
    # Keyword.insert_all(keywords,returning: nil, unique_by: :name)
    # rubocop:enable Rails/SkipsModelValidations

    errors.empty?
  end

  private

  attr_reader :user
end
