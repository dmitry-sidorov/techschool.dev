defmodule Techschool.FundamentalsJSONTest do
  use ExUnit.Case

  use Techschool.JSONValidator,
    path: "priv/repo/data/fundamentals.json",
    types: %{
      name: :string,
      image_url: :string
    },
    required: [:name, :image_url]

  setup_all do
    {:ok, fundamentals: get_json()}
  end

  describe "fundamentals JSON validation" do
    test "validates priv/repo/data/fundamentals.json file", %{fundamentals: fundamentals} do
      assert Enum.all?(fundamentals, &validate/1)
    end
  end
end