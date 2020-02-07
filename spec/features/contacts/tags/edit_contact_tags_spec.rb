describe 'Edit Contact Tags', type: :feature do

  # ============
  # = Add Tags =
  # ============

  Scenario "add tags to contact with enter" do
    Given "a contact exists" do
      @contact = create(:contact)
    end
    When "I visit the contact profile page" do
      visit contact_path(@contact)
    end
    And "add tags" do
      tags_field = find("#contact_tags")
      tags_field.click
      tags_field.set("foo,bar,baz")
      click_button "Save Tags"
    end
    Then "my tags are added to the contact" do
      @contact.reload
      @contact.reload.tags.should include("foo")
    end
    And "my tags appear on the page" do
      current_path.should eq(contact_path(@contact))
      find("#contact_tags").value.should include("baz")
      find("#contact_tags").value.should include("bar")
      find("#contact_tags").value.should include("foo")
    end
  end

  # ===============
  # = Delete Tags =
  # ===============

  Scenario "remove tags from contact" do
    Given "a contact exists, with tags" do
      @contact = create(:contact, tags: "foo, bar, baz")
    end
    When "I visit the contact profile page" do
      visit contact_path(@contact)
      find("#contact_tags").value.should include("baz")
      find("#contact_tags").value.should include("bar")
      find("#contact_tags").value.should include("foo")
    end
    And "remove the tags" do
      tags_field = find("#contact_tags")
      tags_field.click
      tags_field.set("baz,bar")
      click_button "Save Tags"
    end
    Then "no tags appear on the page" do
      current_path.should eq(contact_path(@contact))
      find("#contact_tags").value.should include("baz")
      find("#contact_tags").value.should include("bar")
      find("#contact_tags").value.should_not include("foo")
    end
  end

end
