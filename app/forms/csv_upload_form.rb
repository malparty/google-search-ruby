# frozen_string_literal: true

require 'csv'

class CSVUploadForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :file
  attribute :user

  validates_with CSVValidator

  def initialize(attribute = {})
    super(attribute)
  end

  def save(params)
    keywords = CSV.read.map do | row |
      {
        user_id: user.id,
        name: row[0]
      }
    end

    Keyword.insert_all(keywords)

    errors.empty?
  end

  private

  attr_accessor :user
end
