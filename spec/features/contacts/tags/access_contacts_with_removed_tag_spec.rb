describe 'Access Contacts With Removed Tag', type: :feature do
  Scenario "view contact list when one or more tags are removed" do
    Given "there are tags" do
      @contact = create(:contact, tags: ["Foo", "Bar"])
    end
    And "one of the tag is removed from the system" do
      ActiveRecord::Base.connection.exec_query "DELETE FROM tags " \
                                               "WHERE name = 'Bar'"
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    Then "I see a list of my tags in the sidebar" do
      within ".tags-list" do
        page.should have_content "Browse by tag"
        page.should have_content "Foo"
        page.should_not have_content "Bar"
      end
    end
    And "the tags appear on the contact" do
      within ".contact-index-item" do
        page.should have_content "Foo"
        page.should_not have_content "Bar"
      end
    end
  end
end
