require_relative "../../spec_helper"

describe "Contact Activity", type: :feature do

  # ==============
  # = Timestamps =
  # ==============

  Scenario "view contact activity" do
    Given "a contact exists with activity" do
      @contact       = create(:contact)
      @timezone      = ActiveSupport::TimeZone.new("UTC")
      @activity_date = @timezone.local(2014, 9, 14, 14, 37)
      @activity      = create(:note, {
         created_at:    @activity_date,
         subject:       @contact,
         activity_type: "note",
         text:          "Foo."
      })
    end
    When "I view my contact's profile" do
      visit contact_path(@contact)
    end
    Then "I see the full activity timestamp" do
      page.should have_content "Sunday, September 14"
      page.should have_content "at 2:37 PM"
    end
  end

  # ======================
  # = Email Notification =
  # ======================

  Scenario "view notification activity" do
    Given "a contact exists with a notification activity" do
      @contact  = create(:contact)
      @activity = create(:note, {
         subject:       @contact,
         activity_type: "notification",
         text:          "Satori sent a reminder email about an upcoming session."
      })
    end
    When "I view my contact's profile" do
      visit contact_path(@contact)
    end
    Then "I see the activity log" do
      page.should have_content "Session reminder email from Satori"
    end
    And "it shows the activity type" do
      page.should have_selector ".contact-note.contact-note-notification"
    end
    And "there is no action menu for the note" do
      page.should_not have_content "Edit Note"
    end
  end

end
