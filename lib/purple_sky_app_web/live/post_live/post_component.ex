defmodule PurpleSkyAppWeb.PostLive.PostComponent do
  use PurpleSkyAppWeb, :live_component
  alias PurpleSkyAppWeb.Helpers.TimeHelper

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={"post-#{@post.id}"}
      class="p-4 transition-colors duration-200 bg-white border border-gray-200 hover:bg-gray-50 dark:bg-slate-800 dark:border-slate-600 dark:hover:bg-slate-700/15"
    >
      <div class="flex items-start space-x-3">
        <div class="flex-shrink-0">
          <div class="flex items-center justify-center w-10 h-10 bg-gray-200 rounded-full">
            <span class="font-medium text-gray-500">{String.first(@post.username)}</span>
          </div>
        </div>
        <div class="flex-1 min-w-0">
          <div class="flex items-center space-x-2">
            <span class="font-medium text-gray-900 dark:text-white">@{@post.username}</span>
            <span class="text-sm text-gray-500 dark:text-gray-400">·</span>
            <span class="text-sm text-gray-500 dark:text-gray-400">
              {TimeHelper.relative_time(@post.updated_at)}
            </span>
          </div>
          <p class="mt-1 text-gray-900 dark:text-white">{@post.body}</p>
          <div class="flex items-center justify-between mt-3">
            <div class="flex items-center space-x-8">
              <a
                href="#"
                phx-click="like"
                phx-target={@myself}
                class="flex items-center p-1 space-x-1 text-gray-500 rounded-full dark:text-slate-400 hover:text-pink-400 hover:bg-gray-100 dark:hover:bg-gray-700"
              >
                <.icon name="hero-heart" class="w-5 h-5" />
                <span>{@post.likes_count}</span>
              </a>
              <a
                href="#"
                phx-click="repost"
                phx-target={@myself}
                class="flex items-center p-1 space-x-1 text-gray-500 rounded-full hover:text-green-500 hover:bg-gray-100 dark:text-slate-400 dark:hover:bg-gray-700"
              >
                <.icon name="hero-arrow-path" class="w-5 h-5" />
                <span>{@post.reposts_count}</span>
              </a>
            </div>
            <div class="relative" phx-click-away={JS.hide(to: "#post-actions-#{@id}")}>
              <.button
                phx-click={JS.toggle(to: "#post-actions-#{@id}")}
                class="px-3 py-1 text-gray-500 rounded-full hover:text-gray-700 hover:bg-gray-100 dark:text-slate-400 dark:hover:bg-slate-700 dark:hover:text-slate-400"
              >
                <.icon name="hero-ellipsis-horizontal" class="w-5 h-5" />
              </.button>
              <div
                id={"post-actions-#{@id}"}
                class="absolute right-0 z-10 hidden w-48 mt-2 bg-white rounded-lg ring-1 ring-black ring-opacity-5 dark:bg-slate-700"
              >
                <div role="menu" aria-orientation="vertical">
                  <.link
                    patch={~p"/posts/#{@post}/edit"}
                    class="flex items-center justify-between px-5 py-2 text-sm font-semibold text-gray-600 rounded-lg hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-slate-600"
                    role="menuitem"
                  >
                    <span>Update Post</span>
                    <.icon name="hero-pencil-square" class="w-5 h-5" />
                  </.link>
                  <.link
                    phx-click={JS.push("delete", value: %{id: @post.id})}
                    data-confirm="Are you sure?"
                    class="flex items-center justify-between px-5 py-2 text-sm font-semibold text-gray-600 rounded-lg hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-slate-600"
                    role="menuitem"
                  >
                    <span>Delete Post</span>
                    <.icon name="hero-trash" class="w-5 h-5" />
                  </.link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("like", _, socket) do
    PurpleSkyApp.Timeline.increment_likes(socket.assigns.post)
    {:noreply, socket}
  end

  @impl true
  def handle_event("repost", _, socket) do
    PurpleSkyApp.Timeline.increment_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
