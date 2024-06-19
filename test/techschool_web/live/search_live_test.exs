defmodule TechschoolWeb.SearchLiveTest do
  alias Techschool.Languages.Language
  use TechschoolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Techschool.{CoursesFixtures, ChannelsFixtures, PlatformsFixtures}

  use ExUnitProperties

  @languages [
    "Elixir",
    "Ruby",
    "JavaScript",
    "TypeScript",
    "Python",
    "Java",
    "C",
    "C#",
    "C++"
  ]

  @frameworks [
    "Phoenix",
    "Ruby on Rails",
    "Laravel",
    "React",
    "Vue",
    "Angular",
    "Django",
    ".NET",
    "Flask",
    "Hanami",
    "Express.js",
    "Nest.js",
    "Next.js",
    "Adonis.js",
    "Spring",
    "Hibernate",
    "Fastify"
  ]

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

  defp language_generator(language) do
    %Language{name: language, image_url: url_generator()}
  end

  defp gen_languages() do
    @languages |> Enum.map(fn language -> language_generator(language) end)
  end

  describe "search courses" do
    test "some", %{conn: conn} do
      gen_languages() |> dbg()
      assert true
    end
  end
end
