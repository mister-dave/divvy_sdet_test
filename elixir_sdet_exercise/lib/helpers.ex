defmodule Helpers do
  use Hound.Helpers

  @spec assign_selectors :: %{
          confirm_email: Hound.Element.t(),
          dob_day: Hound.Element.t(),
          dob_month: Hound.Element.t(),
          dob_year: Hound.Element.t(),
          email_address: Hound.Element.t(),
          first_name: Hound.Element.t(),
          gender_custom: any,
          gender_female: any,
          gender_male: any,
          last_name: Hound.Element.t(),
          password: Hound.Element.t(),
          sign_up_button: Hound.Element.t()
        }
  def assign_selectors() do
    # have to visit FB URL first
    # flaky; next time FB runs their minifier, this will change;
    find_element(:id, "u_0_2") |> click()
    first_name_selector = find_element(:name, "firstname")
    last_name_selector = find_element(:name, "lastname")
    email_selector = find_element(:name, "reg_email__")
    confirm_email_selector = find_element(:name, "reg_email_confirmation__")
    password_selector = find_element(:name, "reg_passwd__")
    dob_month_selector = find_element(:name, "birthday_month")
    dob_day_selector = find_element(:name, "birthday_day")
    dob_year_selector = find_element(:name, "birthday_year")

    gender_female_selector =
      find_all_elements(:tag, "label") |> Enum.find(&(inner_text(&1) == "Female"))

    gender_male_selector =
      find_all_elements(:tag, "label") |> Enum.find(&(inner_text(&1) == "Male"))

    gender_custom_selector =
      find_all_elements(:tag, "label") |> Enum.find(&(inner_text(&1) == "Custom"))

    sign_up_button_selector = find_element(:name, "websubmit")

    %{
      first_name: first_name_selector,
      last_name: last_name_selector,
      email_address: email_selector,
      confirm_email: confirm_email_selector,
      password: password_selector,
      dob_month: dob_month_selector,
      dob_day: dob_day_selector,
      dob_year: dob_year_selector,
      gender_female: gender_female_selector,
      gender_male: gender_male_selector,
      gender_custom: gender_custom_selector,
      sign_up_button: sign_up_button_selector
    }
  end

  @spec get_screenshot(String) :: binary
  def get_screenshot(name) do
    File.mkdir_p("./support/screenshots")
    take_screenshot("./support/screenshots/#{name}_#{DateTime.utc_now()}.png")
  end

  @spec poll_element(
          {:class | :css | :id | :link_text | :name | :partial_link_text | :tag | :xpath, binary}
          | Hound.Element.t(),
          Regex.t(),
          integer()
        ) :: true
  def poll_element(element, criteria, duration) do
    case visible_in_element?(element, criteria) do
      true ->
        true

      false ->
        :timer.sleep(1000)
        poll_element(element, criteria, duration - 1)
    end
  end
end
