require 'rails_helper'

#smoke test for rspec and capybara
feature "user visits home page" do
  scenario "not logged in" do
    visit '/'

    expect(page).to have_content("Phez")
  end
end
