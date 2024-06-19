defmodule TechschoolWeb.SearchLiveTest do
  alias Techschool.Languages.Language
  use TechschoolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Techschool.{CoursesFixtures, ChannelsFixtures, PlatformsFixtures}

  use ExUnitProperties

  defp url_generator do
    domains = [
      "net",
      "com",
      "pt"
    ]

    generator =
      ExUnitProperties.gen all(
                             name <- StreamData.string(:alphanumeric),
                             name != "",
                             domain <- StreamData.member_of(domains)
                           ) do
        "https://www." <> name <> "." <> domain
      end

    StreamData.resize(generator, 40)
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
          image_url <- url_generator()
        ) do
          %Language{name: name, image_url: image_url}
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
