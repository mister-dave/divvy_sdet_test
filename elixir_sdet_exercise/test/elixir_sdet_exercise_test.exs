defmodule ElixirSdetExerciseTest do
  use Hound.Helpers
  # use Hound.Matchers
  use ExUnit.Case
  alias Helpers

  setup do
    Hound.start_session()
    :ok
  end

  def screenshot(name) do
    screenshot_directory = File.mkdir_p("./support/screenshots")
    take_screenshot("./support/screenshots/#{name}_#{DateTime.utc_now()}.png")
  end

  @tag :skip
  test "Goes to Facebook Login page" do
    navigate_to("https://facebook.com")
    IO.inspect(page_title())
  end

  test "Doesn't allow naughty words in name", context do
    navigate_to("https://facebook.com")
    fields_map = Helpers.assign_selectors()

    fill_field(fields_map[:first_name], "crap")
    fill_field(fields_map[:last_name], "crap")
    fill_field(fields_map[:email_address], "bob556677@yahoo.com")
    fill_field(fields_map[:confirm_email], "bob556677@yahoo.com")
    fill_field(fields_map[:password], "UIG79haeg3x")

    find_element(:css, "#month option[value='7']") |> click()
    find_element(:css, "#day option[value='23']") |> click()
    find_element(:css, "#year  option[value='1980']") |> click()

    click(fields_map[:gender_male])
    click(fields_map[:sign_up_button])
    :timer.sleep(1500)

    try do
      warning_text =
        "We require everyone to use the name they use in everyday life, what their friends call them, on Facebook. Learn more about our name policies."

      assert visible_in_element?({:id, "reg_error_inner"}, ~r/#{warning_text}/)
    catch
      error ->
        Map.get(context, :test)
        |> to_string()
        |> screenshot()

        IO.inspect(error)
    end
  end

  test "Doesn't allow symbols in names", context do
    navigate_to("https://facebook.com")
    fields_map = Helpers.assign_selectors()

    fill_field(fields_map[:first_name], "as;lkhasel;h")
    fill_field(fields_map[:last_name], "sal;fj!wl;ekr")
    fill_field(fields_map[:email_address], "bob556677@yahoo.com")
    fill_field(fields_map[:confirm_email], "bob556677@yahoo.com")
    fill_field(fields_map[:password], "UIG79haeg3x")
    find_element(:css, "#month option[value='7']") |> click()
    find_element(:css, "#day option[value='23']") |> click()
    find_element(:css, "#year  option[value='1980']") |> click()

    click(fields_map[:gender_male])
    click(fields_map[:sign_up_button])
    :timer.sleep(1500)

    try do
      warning_text =
        "This name has certain characters that aren't allowed. Learn more about our name policies."

      assert visible_in_element?({:id, "reg_error_inner"}, ~r/#{warning_text}/)
    catch
      error ->
        Map.get(context, :test)
        |> to_string()
        |> screenshot()

        IO.inspect(error)
    end
  end

  test "Doesn't allow long names", context do
    navigate_to("https://facebook.com")
    fields_map = Helpers.assign_selectors()

    fill_field(fields_map[:first_name], "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz")
    fill_field(fields_map[:last_name], "abcdefghijklmnopqrstuvwxyz")
    fill_field(fields_map[:email_address], "bob556677@yahoo.com")
    fill_field(fields_map[:confirm_email], "bob556677@yahoo.com")
    fill_field(fields_map[:password], "UIG79haeg3x")
    find_element(:css, "#month option[value='7']") |> click()
    find_element(:css, "#day option[value='23']") |> click()
    find_element(:css, "#year  option[value='1980']") |> click()

    click(fields_map[:gender_male])
    click(fields_map[:sign_up_button])
    :timer.sleep(1500)

    try do
      warning_text =
        "First or last names on Facebook can't have too many characters. Learn more about our name policies."

      assert visible_in_element?({:id, "reg_error_inner"}, ~r/#{warning_text}/)
    catch
      error ->
        Map.get(context, :test)
        |> to_string()
        |> screenshot()

        IO.inspect(error)
    end
  end

  # Bobby Tables
  test "Doesn't allow injection attacks", context do
    navigate_to("https://facebook.com")
    fields_map = Helpers.assign_selectors()
    fill_field(fields_map[:first_name], "Robert")
    fill_field(fields_map[:last_name], "Tables")
    fill_field(fields_map[:email_address], "xxx@xxx.xxx")
    fill_field(fields_map[:confirm_email], "xxx@xxx.xxx")
    fill_field(fields_map[:password], "xxx') OR 1 = 1 -- ]")
    find_element(:css, "#month option[value='7']") |> click()
    find_element(:css, "#day option[value='23']") |> click()
    find_element(:css, "#year  option[value='1980']") |> click()

    click(fields_map[:gender_male])
    click(fields_map[:sign_up_button])
    :timer.sleep(20000) # super long wait for this one

    try do
      warning_text =
        "This name has certain characters that aren't allowed. Learn more about our name policies."

      assert visible_in_element?({:id, "reg_error_inner"}, ~r/#{warning_text}/)
    catch
      error ->
        Map.get(context, :test)
        |> to_string()
        |> screenshot()

        IO.inspect(error)
    end
  end


  test "Doesn't allow minors to register", context do
    navigate_to("https://facebook.com")
    fields_map = Helpers.assign_selectors()
    fill_field(fields_map[:first_name], "Robert")
    fill_field(fields_map[:last_name], "Tables")
    fill_field(fields_map[:email_address], "notaminor@clubpenguin.com")
    fill_field(fields_map[:confirm_email], "notaminor@clubpenguin.com")
    fill_field(fields_map[:password], "CP5ever")
    find_element(:css, "#month option[value='7']") |> click()
    find_element(:css, "#day option[value='23']") |> click()
    find_element(:css, "#year  option[value='2010']") |> click()

    click(fields_map[:gender_male])
    click(fields_map[:sign_up_button])
    :timer.sleep(1500)

    try do
      warning_text =
        "We Couldn't Create Your Account.\nWe were not able to sign you up for Facebook."

      assert visible_in_element?({:id, "softblock_error_inner"}, ~r/#{warning_text}/)
    catch
      error ->
        Map.get(context, :test)
        |> to_string()
        |> screenshot()

        IO.inspect(error)
    end
  end

  #different login page
  # test "Visit new page after X login attempts" do
  #   navigate_to("https://facebook.com")
  #   page_title = page_title()
  #   find_element(:id, "email") |> fill_field("jason@gmail.com")
  #   find_element(:id, "pass") |> fill_field("jasonsfavoritewebsite")
  #   find_element(:login, "login") |> click()


  #   new_page_title = page_title()
  #   refute page_title == new_page_title
  # end
  # Doesn't allow too short of a password
  # Doesn't allow simple-sequence passwords
  # Doesn't allow empty fields
  # Doesn't allow invalid email address domains
  # Doesn't allow invalid email prefix
  # Doesn't allow mismatched email values in confirm field
  # Doesn't allow bad words in the email address
  # Doesn't allow name to be in password
  # Doesn't allow date of birth to be password
  # Doesn't allow email address to be password
  # Doesn't allow mobile number to be password
  # Doesn't allow many attempts in short amount of time
  # Doesn't allow submission without first name present
  # Doesn't allow submission without last name present
  # Doesn't allow submission without mobile number or email address present
  # Doesn't allow submission without date of birth present
  # Doesn't allow submission without gender selection present
  # Doesn't allow submission without pronoun selection present
  # choose radio button
  # choose other and fill field
  # Doesn't allow submission with no values entered
  # Doesn't allow
  # Doesn't allow
end
