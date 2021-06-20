defmodule FrontiersSiteWeb.FrontierLive do
  use FrontiersSiteWeb, :live_view

  @impl true
  def mount(%{"frontier" => frontier}, _session, socket) do
    f = FrontiersSite.Model.Frontier.new(frontier)
    IO.inspect(f)

    {:ok, assign(socket, tiles: f.tiles, frontier_id: frontier)}
  end

  # @impl true
  # def handle_event("suggest", %{"q" => query}, socket) do
  #  {:noreply, assign(socket, results: search(query), query: query)}
  # end
end
