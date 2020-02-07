describe "Create new contact", type: :feature do

  Scenario "create new contact" do
    When "I visit the new contact page" do
      visit new_contact_path
    end
    Then "I see the contact form" do
      page.should have_field "contact_first_name"
      page.should have_field "contact_last_name"
      page.should have_field "contact_phone_1"
      page.should have_field "contact_phone_2"
      page.should have_field "contact_phone_3"
      page.should have_field "contact_phone_1_label"
      page.should have_field "contact_phone_2_label"
      page.should have_field "contact_phone_3_label"
      page.should have_field "contact_email"
      page.should have_field "contact_skype"
      page.should have_field "contact_website"
      page.should have_field "contact_twitter"
      page.should have_field "contact_street_address"
      page.should have_field "contact_city"
      page.should have_field "contact_state"
      page.should have_field "contact_post_code"
      page.should have_field "contact_country"
    end
    When "I enter new contact details" do
      fill_in "contact_first_name", :with => "Lach"
      fill_in "contact_last_name", :with => "Cotter"
      click_button "Add This Contact"
    end

    Then "the new contact is displayed" do
      current_path.should eq(contact_path(Contact.last))
    end
  end

end
