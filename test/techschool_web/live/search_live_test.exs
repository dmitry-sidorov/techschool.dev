defmodule TechschoolWeb.SearchLiveTest do
  use TechschoolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Techschool.{CoursesFixtures, ChannelsFixtures, PlatformsFixtures}

  use ExUnitProperties

  defp email_generator do
    domains = [
      "gmail.com",
      "hotmail.com",
      "yahoo.com"
    ]

    generator =
      ExUnitProperties.gen all(
                             name <- StreamData.string(:alphanumeric),
                             name != "",
                             domain <- StreamData.member_of(domains)
                           ) do
        name <> "@" <> domain
      end

    StreamData.resize(generator, 30)
  end

  defp language_generator do
    generator =
      ExUnitProperties.gen(
        all(
          name <-
            StreamData.member_of([
              "Elixir",
              "Ruby",
              "JavaScript",
              "TypeScript",
              "Python",
              "Java",
              "C",
              "C#",
              "C++"
            ]),
          image_url <- email_generator()
        ) do
          %{name: name, image_url: image_url}
        end
      )
  end

  describe "search courses" do
    test "some", %{conn: conn} do
      # Techschool.Courses.list_courses() |> dbg()
      Enum.take(language_generator(), 10) |> dbg()
      assert true
    end
  end
end
