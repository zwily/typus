module Admin::Resources::DataTypes::DateHelper

  def date_filter(filter)
    values = %w(today last_few_days last_7_days last_30_days)
    items = [[Typus::I18n.t("Show all dates"), ""]]
    items += values.map { |v| [Typus::I18n.t(v.humanize), v] }
  end

  alias :datetime_filter :date_filter
  alias :timestamp_filter :date_filter

end
