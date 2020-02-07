describe 'Filtering Contacts', type: :feature do
  
  # ===========
  # = By Name =
  # ===========
  
  Scenario "filter contacts by first name" do
    Given  "there are contacts in my account" do
      @contact1 = create(:contact, first_name: "Bill")
      @contact2 = create(:contact, first_name: "Ted")
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    And "filter by name" do
      fill_in "q_full_name_cont", with: "Bill"
      click_button "Filter"
    end
    Then "I see only the contacts that match" do
      page.should have_content "Bill"
      page.should have_no_content "Ted"
    end
  end
  
  Scenario "filter contacts by last name" do
    Given  "there are contacts in my account" do
      @contact1 = create(:contact, last_name: "Cleese")
      @contact2 = create(:contact, last_name: "Idle")
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    And "filter by name" do
      fill_in "q_full_name_cont", with: "Cle"
      click_button "Filter"
    end
    Then "I see only the contacts that match" do
      page.should have_content "Cleese"
      page.should have_no_content "Idle"
    end
  end
  
  Scenario "filter contacts by full name" do
    Given  "there are contacts in my account" do
      @contact1 = create(:contact, first_name: "David", last_name: "Smith")
      @contact2 = create(:contact, first_name: "David", last_name: "Jones")
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    And "filter by name" do
      fill_in "q_full_name_cont", with: "David S"
      click_button "Filter"
    end
    Then "I see only the contacts that match" do
      page.should have_content "David Smith"
      page.should have_no_content "David Jones"
    end
  end
  
  # ==============
  # = By Company =
  # ==============
  
  Scenario "filter contacts by company" do
    Given  "there are contacts in my account" do
      @contact1 = create(:contact, business_name: "Apple")
      @contact2 = create(:contact, business_name: "Google")
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    And "filter by name" do
      fill_in "q_business_name_start", with: "App"
      click_button "Filter"
    end
    Then "I see only the contacts that match" do
      page.should have_content "Apple"
      page.should have_no_content "Google"
    end
  end
  
  # ===============
  # = By Position =
  # ===============
  
  Scenario "filter contacts by position" do
    Given  "there are contacts in my account" do
      @contact1 = create(:contact, position: "Designer")
      @contact2 = create(:contact, position: "Programmer")
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    And "filter by name" do
      fill_in "q_position_start", with: "Des"
      click_button "Filter"
    end
    Then "I see only the contacts that match" do
      page.should have_content "Designer"
      page.should have_no_content "Programmer"
    end
  end
  
  # ============
  # = By Email =
  # ============
  
  Scenario "filter contacts by email" do
    Given  "there are contacts in my account" do
      @contact1 = create(:contact, first_name: "Lach", email: "lach@satoriapp.com")
      @contact2 = create(:contact, first_name: "Grace", email: "grace@satoriapp.com")
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    And "filter by name" do
      fill_in "q_email_cont", with: "lach"
      click_button "Filter"
    end
    Then "I see only the contacts that match" do
      page.should have_content "Lach"
      page.should have_no_content "Grace"
    end
  end
  
  # ==============
  # = No matches =
  # ==============
  
  Scenario "no contacts match filter" do
    Given  "there are contacts in my account" do
      @contact1 = create(:contact, email: "lach@satoriapp.com")
      @contact2 = create(:contact, email: "grace@satoriapp.com")
    end
    When "I visit the contact list" do
      visit contacts_path
    end
    And "filter out all contacts" do
      fill_in "q_email_cont", with: "not-here"
      click_button "Filter"
    end
    Then "I see that there are no matches" do
      page.should have_content "No contacts match"
    end
  end
  
end