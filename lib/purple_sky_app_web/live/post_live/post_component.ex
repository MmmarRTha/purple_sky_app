defmodule PurpleSkyAppWeb.PostLive.PostComponent do
  use PurpleSkyAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={"post-#{@post.id}"}
      class="p-4 transition-colors duration-200 bg-white border border-gray-200 rounded-xl hover:bg-gray-50"
    >
      <div class="flex items-start space-x-3">
        <div class="flex-shrink-0">
          <div class="flex items-center justify-center w-10 h-10 bg-gray-200 rounded-full">
            <span class="font-medium text-gray-500">{String.first(@post.username)}</span>
          </div>
        </div>
        <div class="flex-1 min-w-0">
          <div class="flex items-center space-x-2">
            <span class="font-medium text-gray-900">@{@post.username}</span>
            <span class="text-sm text-gray-500">·</span>
            <span class="text-sm text-gray-500">Just now</span>
          </div>
          <p class="mt-1 text-gray-900">{@post.body}</p>
          <div class="flex items-center justify-between mt-3">
            <div class="flex items-center space-x-8">
              <.button
                phx-click={JS.push("like", value: %{id: @post.id})}
                class="flex items-center space-x-1 text-gray-500 hover:text-red-500"
              >
                <.icon name="hero-heart" class="w-5 h-5" />
                <span>{@post.likes_count}</span>
              </.button>
              <.button
                phx-click={JS.push("repost", value: %{id: @post.id})}
                class="flex items-center space-x-1 text-gray-500 hover:text-green-500"
              >
                <.icon name="hero-arrow-path" class="w-5 h-5" />
                <span>{@post.reposts_count}</span>
              </.button>
            </div>
            <div class="relative">
              <.button
                phx-click={JS.toggle(to: "#post-actions-#{@id}")}
                class="text-gray-500 hover:text-gray-700"
              >
                <.icon name="hero-ellipsis-horizontal" class="w-5 h-5" />
              </.button>
              <div
                id={"post-actions-#{@id}"}
                class="absolute right-0 z-10 hidden w-48 mt-2 bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5"
              >
                <div class="py-1" role="menu" aria-orientation="vertical">
                  <.link
                    patch={~p"/posts/#{@post}/edit"}
                    class="flex items-center px-4 py-2 text-sm text-sky-500 hover:bg-gray-100 hover:text-sky-400"
                    role="menuitem"
                  >
                    <.icon name="hero-pencil-square" class="w-5 h-5 mr-2" /> Edit
                  </.link>
                  <.link
                    phx-click={JS.push("delete", value: %{id: @post.id}) |> hide("##{@id}")}
                    data-confirm="Are you sure?"
                    class="flex items-center px-4 py-2 text-sm text-red-600 hover:text-red-500 hover:bg-gray-100"
                    role="menuitem"
                  >
                    <.icon name="hero-trash" class="w-5 h-5 mr-2" /> Delete
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
end
