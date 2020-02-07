# encoding: utf-8

# require "spec_helper"

describe "View a Contact", type: :feature do

  include ApplicationHelper # format_date, format_currency

  Scenario "view contact details" do
    Given "a contact exists without an agreement" do
      @contact = create(:contact, position: "Founder", business_name: "Satori")
    end
    When "I visit the contact profile page" do
      visit contact_path(@contact)
    end
    Then "I see the contact details" do
      page.should have_content "Founder"
      page.should have_content "Satori"
    end
  end

  Scenario "view a current client" do
    Given "a contact exists with used sessions and an invoice" do
      @contact = create(:contact)
    end
    When "I visit the contact profile page" do
      visit contact_path(@contact)
    end
    Then "I see the contact summary stats" do
      within(".total-value") { page.should have_content "0" }
      within(".session-count") { page.should have_content "0" }
      # within(".last-contact") { page.should have_content "-" }
    end
  end

end
