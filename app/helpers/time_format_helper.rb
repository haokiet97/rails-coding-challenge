module TimeFormatHelper

  def current_user
    Class.new do

    end.new
  end

  def current_user_timezone
    ActiveSupport::TimeZone.new(current_user.try(:timezone) || "UTC")
  end

  def time_formatter
    TimeFormatter.new(current_user_timezone)
  end

  # Move to TimeFormatter
  def format_date (date, options = {})
    time_formatter.date_only(date, options)
  end

  # Move to TimeFormatter
  def format_time (time, options = {})
    time_formatter.time_of_day(time, options)
  end

  # Move to TimeFormatter
  def format_full_session_time (session, timezone)
    time_formatter.full_session_time(session, { timezone: timezone, with_zone: true })
  end

  # Move to TimeFormatter
  def format_full_session_time_for_booking (time, timezone)
    time_formatter.full_session_time_for_booking(time, timezone)
  end

  # Move to TimeFormatter
  # def format_agreement_date (date)
  #   format_date(date)
  # end

  # Move to TimeFormatter
  def format_appointment_date (time)
    time = time.in_time_zone(current_user_timezone)
    now = Time.now.in_time_zone(current_user_timezone)
    today_boundary = now.end_of_day
    tomorrow_boundary = now.tomorrow.end_of_day
    week_boundary = (now + 7.days).end_of_day
    if time < today_boundary
      "today"
    elsif time < tomorrow_boundary
      "tomorrow"
    elsif time < week_boundary
      time.strftime("%A")
    else
      format_date(time)
    end
  end

  # Move to TimeFormatter
  def format_appointment (time)
    "#{format_appointment_date(time)}, #{format_time(time)}"
  end

  # =========================
  # = Formatting Note Dates =
  # =========================

  NOTE_DATE_FORMAT = "%A, %B %e at %l:%M %p"
  NIL_DATE_STRING = "&ndash;".html_safe

  def format_note_date (date, options = {})
    timezone = options[:timezone] || current_user_timezone
    render_with_format(date, timezone, NOTE_DATE_FORMAT)
  end

  def render_with_format (date, timezone, format)
    return NIL_DATE_STRING if date.nil?
    return date.to_time.in_time_zone(timezone).strftime(format).gsub(/\s+/, ' ')
  end

end
