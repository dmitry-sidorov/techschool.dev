defmodule TechschoolWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :techschool,
    pubsub_server: Techschool.PubSub

  def init(_opts) do
    {:ok, %{}}
  end

  def fetch(_topic, presences) do
    IO.puts "fetch"
    for {key, %{metas: [meta | metas]}} <- presences, into: %{} do
      # user can be populated here from the database here we populate
      # the name for demonstration purposes
      {key, %{metas: [meta | metas], id: meta.id, user: %{name: meta.id}}}
    end
  end

  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    IO.puts "handle_metas"
    joins |> Map.to_list() |> dbg()
    for {user_id, presence} <- joins |> Map.to_list() do
      user_data = %{id: presence.id, user: presence.user, metas: Map.fetch!(presence, user_id)}
      msg = {__MODULE__, {:join, user_data}}
      Phoenix.PubSub.local_broadcast(Techschool.PubSub, "proxy:#{topic}", msg) |> dbg()
    end

    presences |> dbg()
    for {user_id, presence} <- leaves do
      metas = case Map.fetch(presence, user_id) do
        {:ok, presence_metas} -> presence_metas
        :error -> []
      end

      user_data = %{id: user_id, user: presence.user, metas: metas}
      msg = {__MODULE__, {:leave, user_data}}
      Phoenix.PubSub.local_broadcast(Techschool.PubSub, "proxy:#{topic}", msg) |> dbg()
    end

    {:ok, state}
  end

  def list_online_users(), do: list("online_users") |> Enum.map(fn {_id, presence} -> presence end)

  def track_user(id), do: track(self(), "online_users", id, %{id: id})

  def subscribe(), do: Phoenix.PubSub.subscribe(Techschool.PubSub, "proxy:online_users")
end
