describe 'Browse Contacts By Tag', type: :feature do
  Scenario "view contact list when tags are present" do
    Given "there are tags" do
      @contact = create(:contact, tags: ["Foo", "Bar"])
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    Then "I see a list of my tags in the sidebar" do
      within ".tags-list" do
        page.should have_content "Browse by tag"
        page.should have_content "Foo"
        page.should have_content "Bar"
      end
    end
    And "the tags appear on the contact" do
      within ".contact-index-item" do
        page.should have_content "Foo"
        page.should have_content "Bar"
      end
    end
  end

  Scenario "view contact list when no tags are present" do
    Given "there are no tags" do
      RocketTag::Tag.delete_all
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    Then "there is no list of tags" do
      page.should have_no_content "Browse by tag"
    end
  end

  Scenario "find contacts for tag" do
    Given "there are tags" do
      @contact1 = create(:contact, first_name: "Bill", tags: ["Foo", "Bar"])
    end
    And "there are other contacts, without tags" do
      @contact2 = create(:contact, first_name: "Ted")
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    And "click on a tag" do
      within ".tags-list" do
        click_link "Foo"
      end
    end
    Then "I see only the contacts with that tag" do
      page.should have_content "Bill"
      page.should have_no_content "Ted"
    end
  end
end
