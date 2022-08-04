# frozen_string_literal: true

class Filter
  include ActiveModel::Model

  QUERY_PARAMS = [filter: [:url_pattern, :keyword_pattern, { link_types: [] }]].freeze
  PATTERN_REGEXP =
    %r{\A\^?((\[[\\\-/:.\w]+\])|([\\\-/:.\w]+)|(\(([\\\-/:.\w]+)\|?([\\\-/:.\w]+)\)))[+?*]?(\{\d+(,\d?)?\})?\$?\Z}
    .freeze

  attr_accessor :keyword_pattern, :url_pattern, :link_types

  validates :keyword_pattern, format: { with: PATTERN_REGEXP }, allow_blank: true
  validates :url_pattern, format: { with: PATTERN_REGEXP }, allow_blank: true
  validate :link_types_exist?

  def self.from_params(params)
    return Filter.new unless params.key?(:filter)

    Filter.new keyword_pattern: params[:filter][:keyword_pattern],
               url_pattern: params[:filter][:url_pattern],
               link_types: params[:filter][:link_types]&.select(&:present?)&.map(&:to_i)&.uniq
  end

  def result_link_filter_exist?
    url_pattern.present? || link_types.present?
  end

  def error_message
    errors.full_messages.join '. '
  end

  protected

  def link_types_exist?
    return if link_types_valid?

    errors.add :link_types, I18n.t('filters.value_error')
  end

  def link_types_valid?
    link_types.blank? || link_types.all? { |link_type| link_type >= 0 && ResultLink.link_types.keys[link_type] }
  end
end
