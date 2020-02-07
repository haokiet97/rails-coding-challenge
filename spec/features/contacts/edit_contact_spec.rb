describe "Edit contact", type: :feature do
  Scenario "edit contact" do
    Given "a contact exists" do
       @contact = create(:contact)
    end
    When "I visit the edit contact page" do
       visit edit_contact_path(@contact)
    end
    And "I enter new contact details" do
       fill_in "contact_first_name", :with => "Lach"
       fill_in "contact_last_name", :with => "Cotter"
       fill_in "contact_position", :with => "Founder"
       fill_in "contact_business_name", :with => "Satori"
       select "Mobile", from: 'contact_phone_1_label'
       select "Work", from: 'contact_phone_2_label'
       click_button "Save Changes"
    end
    Then "the new contact is displayed" do
       current_path.should eq(contact_path(Contact.last))
       @contact.reload.full_name.should eq("Lach Cotter")
       @contact.position.should eq("Founder")
       @contact.business_name.should eq("Satori")
       page.should have_content "Mobile"
       page.should have_content "Work"
    end
  end
end
