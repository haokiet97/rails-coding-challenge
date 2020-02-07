# require 'spec_helper'

describe "Contact Notes", type: :feature do
  include ApplicationHelper
  include TimeFormatHelper

  Scenario "Add note to contact" do

    Given "I have a contact" do
      @contact = create(:contact)
    end

    And "I am on the contact's page" do
      visit contact_path(@contact)
    end

    When "I add a new note" do
      fill_in "note_text", :with => "# note heading\n\nnote paragraph"
      click_button "Add Note"
    end

    Then "it redisplays the contact" do
      current_path.should eq(contact_path(@contact))
    end

    And "it displays the new note" do
      within ".contact-notes" do
        page.should have_content "note heading"
        page.should have_content "note paragraph"
      end
    end

    And "it converts markdown headings" do
      page.find("h4").text.should eq("note heading")
    end

    And "it displays the date of the note" do
      page.should have_content format_note_date(Time.now, :timezone => "UTC")
    end

  end


  # ===============
  # = Delete Note =
  # ===============

  Scenario "Delete contact note" do

    Given "I have a contact with a note" do
      @contact = create(:contact)
      @note    = create(:note, subject: @contact)
    end

    And "I am on the contact's page" do
      visit contact_path(@contact)
    end

    And "I click the delete link for the note" do
      within("div[@id='note_#{@note.id}']") do
        click_link "Delete"
      end
    end

    Then "it returns me to the contact page" do
      current_path.should == contact_path(@contact)
    end

    And "The note has been deleted" do
      page.should_not have_content "note 2 text"
    end
  end

  # =============
  # = Edit Note =
  # =============

  Scenario "Edit note" do

    Given "I have a contact with a note" do
      @contact = create(:contact)
      @note    = create(:note, subject: @contact)
    end

    And "I am on the contact's page" do
      visit contact_path(@contact)
    end

    When "I click the edit link for that note" do
      within("div[@id='note_#{@note.id}']") do
        click_link "Edit"
      end
    end

    Then "takes me to the note's edit page" do
      current_path.should eq(edit_note_path(@note))
    end

    When "I submit an edit" do
      fill_in "note_text", :with => "updated note text"
      click_button "Update Note"
    end

    Then "it returns me to the contact's page" do
      current_path.should eq(contact_path(@contact))
    end

    And "it displays the updated note text" do
      page.should have_content "updated note text"
    end
  end

end
