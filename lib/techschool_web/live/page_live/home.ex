defmodule TechschoolWeb.PageLive.Home do
  use TechschoolWeb, :live_view

  alias Techschool.GitHub

  embed_templates "components/*"

  attr :inverse_locale, :string, required: true
  def translate_button(assigns)

  defp inverse_locale(locale) do
    case locale do
      "pt" -> "en"
      "en" -> "pt"
    end
  end

  @impl true
  def mount(params, session, socket) do
    socket = stream(socket, :presence, [])

    socket =
    if connected?(socket) do
      TechschoolWeb.Presence.track_user(socket.id)
      TechschoolWeb.Presence.subscribe()
      socket = stream(socket, :presences, TechschoolWeb.Presence.list_online_users())
    else
      socket
    end

    socket
    |> assign_async(:github_contributors, fn ->
      {:ok, %{github_contributors: GitHub.get_contributors()}}
    end)
    |> assign(:page_title, "TechSchool")
    |> ok()
  end

  def handle_info({TechschoolWeb.Presence, {:join, presence}}, socket) do
    {:noreply, stream_insert(socket, :presences, presence)}
  end

  def handle_info({TechschoolWeb.Presence, {:leave, presence}}, socket) do
    if presence.metas == [] do
      {:noreply, stream_delete(socket, :presences, presence)}
    else
      {:noreply, stream_insert(socket, :presences, presence)}
    end
  end
end
