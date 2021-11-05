require "application_system_test_case"

class FridgesTest < ApplicationSystemTestCase
  setup do
    @fridge = fridges(:one)
  end

  test "visiting the index" do
    visit fridges_url
    assert_selector "h1", text: "Fridges"
  end

  test "creating a Fridge" do
    visit fridges_url
    click_on "New Fridge"

    fill_in "Title", with: @fridge.title
    click_on "Create Fridge"

    assert_text "Fridge was successfully created"
    click_on "Back"
  end

  test "updating a Fridge" do
    visit fridges_url
    click_on "Edit", match: :first

    fill_in "Title", with: @fridge.title
    click_on "Update Fridge"

    assert_text "Fridge was successfully updated"
    click_on "Back"
  end

  test "destroying a Fridge" do
    visit fridges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fridge was successfully destroyed"
  end
end
