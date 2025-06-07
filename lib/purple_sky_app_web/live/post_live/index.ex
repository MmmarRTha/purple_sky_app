defmodule PurpleSkyAppWeb.PostLive.Index do
  use PurpleSkyAppWeb, :live_view

  alias PurpleSkyApp.Timeline
  alias PurpleSkyApp.Timeline.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Timeline.subscribe()
    end

    {:ok,
     socket
     |> stream_configure(:posts, dom_id: &"post-#{&1.id}")
     |> stream(:posts, Timeline.list_posts())
     |> assign(:page_title, "Listing Posts")
     |> assign(:post, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({PurpleSkyAppWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post, at: 0)}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, stream_insert(socket, :posts, post, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
