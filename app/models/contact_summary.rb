# ---------------------------------------------------------
# Name:    ContactSummary
# Purpose: Logical home for contact summary stats.
# Changes: When we decide we want to display different
#          summary stats on the contact profile page.
# ---------------------------------------------------------

class ContactSummary

  def initialize (contact)
    @contact = contact
  end

  def last_contact_at
    [last_note_created_at].compact.max
  end

  def total_value
    @contact.total_investment
  end

  def num_sessions
    @contact.used_sessions.count
  end

  def last_session_occured_at
    used_sessions_by_start_time.last.try(:start_time)
  end

  def last_note_created_at
    notes_by_created_at.last.try(:created_at)
  end

  protected

  # Possibly move these into Contact and add unit tests if we need them
  # elsewhere in the code.

  def used_sessions_by_start_time
    @contact.used_sessions.sort { |a, b| a.start_time.to_i <=> b.start_time.to_i }
  end

  def notes_by_created_at
    @contact.notes.sort { |a, b| a.created_at.to_i <=> b.created_at.to_i }
  end

end
