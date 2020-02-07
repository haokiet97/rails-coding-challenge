# Purpose: Format dates and times for presentation
# Changes: When we need to change or add new time formats.

class TimeFormatter

  def initialize (default_timezone = nil)
    @force_show_zone = default_timezone.nil?
    @default_timezone = default_timezone || ActiveSupport::TimeZone.new("UTC")
  end

  attr_reader :default_timezone

  # ===========
  # = Formats =
  # ===========

  OFFER_CLOSING_DATE        = "%e %b, %Y %I:%M %P"  #  1 Jan, 2015 01:30 pm
  OFFER_CLOSING_DATE_MOMENT = "D MMM, YYYY hh:mm a" # Equivelent format for JS moment library.
  AGREEMENT_DATE            = "%e %b, %Y"           #  1 Jan, 2015
  INVOICE_DATE              = "%e %b, %Y"           #  1 Jan, 2015
  INVOICE_DATE_MOMENT       = "D MMM, YYYY"         # Equivelent format for JS moment library.

  # ==================
  # = Format Methods =
  # ==================

  def date_only (date, options = {})
    options[:short_year] ||= false
    timezone = options[:timezone] || default_timezone
    format = date_format_for_options(options)
    format_time_in_zone(format, date, timezone)
  end

  def time_of_day (time, options = {})
    timezone = options[:timezone] || default_timezone
    format = "%I:%M %P"
    format += " %z" if (@force_show_zone || options[:with_zone]) && (options[:with_zone] != false)
    format_time_in_zone(format, time, timezone)
  end

  def same_day (time, options = {})
    time_of_day(time, options) + " TODAY"
  end

  def invoice_date (date)
    format_time_in_zone(INVOICE_DATE, date, default_timezone)
  end

  def agreement_date (date)
    format_time_in_zone(AGREEMENT_DATE, date, default_timezone)
  end

  def offer_closing_date (date)
    format_time_in_zone(OFFER_CLOSING_DATE, date, default_timezone)
  end

  # ========
  # = Base =
  # ========

  # Base formatting method.

  def format_time_in_zone (format, time, zone)
    if time.nil?
      "&ndash;".html_safe
    else
      time.to_time.in_time_zone(normalized_timezone(zone)).strftime(format).strip.gsub(/\s+/, ' ')
    end
  end

  def normalized_timezone (zone)
    zone || default_timezone || ActiveSupport::TimeZone.new("UTC")
  end



  # =====================
  # = Full Session Time =
  # =====================

  def full_session_time (session, options = {})
    return "-" if session.start_time.nil?
    d = date_only(session.start_time, timezone: options[:timezone], weekday: true)
    t = time_of_day(session.start_time, options)
    "#{d} @ #{t}"
  end

  SESSION_REMINDER_NOTIFICATION = "%A, %-d %b @ %I:%M %P"
  def session_reminder_notification (time, zone)
    [format_time_in_zone(SESSION_REMINDER_NOTIFICATION, time, zone), local_zone(zone)].join(" ")
  end

  def local_zone (zone)
    "(#{zone.to_s.split('/').last} Time)"
  end

  def full_session_time_for_booking (time, timezone)
    if time.present?
      date_string = h.format_date(time, timezone: timezone)
      time_string = h.format_time(time, timezone: timezone)
      "#{date_string} @ #{time_string}"
    else
      "N/A"
    end
  end

  private

  def date_format_for_options (options)
    if options[:weekday].present?
      "%A, %e %b"
    elsif options[:month_first].present?
      "%b %e, %Y"
    elsif options[:short_year].present?
      "%e %b, '%y"
    else
      "%e %b, %Y"
    end
  end

  def h
    @helper ||= ::Class.new do
      include ::ApplicationHelper
      include ::TimeFormatHelper
    end.new
  end

end
