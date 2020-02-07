class NotePresenter < Decorator

  def initialize (note, template)
    super(note)
    @note = note
    @template = template
  end

  def subject_display_name
    return @note.subject.full_name if @note.subject.respond_to?(:full_name)
    return @note.subject.name
  end

  def activity_type_class
    return nil if activity_type.nil?
    return "contact-note-#{activity_type}"
  end

  def session_reminder_description
    formatter = ::TimeFormatter.new
    time_string = formatter.session_reminder_notification(data[:start_time], data[:timezone])
    # Bold everything except the timezone.
    foramtted_time_string = time_string.sub(/^(.*)(am|pm)(.*)$/, "<b>\\1\\2</b>\\3")
    message_text = "Your next #{data[:session_name]} is on #{foramtted_time_string}."
    message_text.html_safe
  end

  def activity_type_description
    return "Session reminder email from Satori" if is_session_reminder?
    return "Email notification from Satori" if is_notification_email?
    return "Questionnaire responses from client" if is_questionnaire_responses?
    return "Note by coach"
  end

end
