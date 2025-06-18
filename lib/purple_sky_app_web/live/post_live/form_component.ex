defmodule PurpleSkyAppWeb.PostLive.FormComponent do
  use PurpleSkyAppWeb, :live_component

  alias PurpleSkyApp.Timeline

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-full">
      <div class="px-2 py-0">
        <div class="flex px-4 pb-3 space-x-4">
          <div class="flex-1">
            <.simple_form
              for={@form}
              id="post-form"
              phx-target={@myself}
              phx-change="validate"
              phx-submit="save"
              class="mt-16"
            >
              <div class="absolute top-5 right-5">
                <.button
                  phx-disable-with="Saving..."
                  class="px-4 py-2 font-semibold text-white bg-purple-500 rounded-full hover:bg-purple-600 dark:hover:bg-purple-400"
                >
                  {button_text(@action)}
                </.button>
              </div>
              <div class="flex space-x-4">
                <div class="flex-shrink-0">
                  <div class="overflow-hidden w-12 h-12 rounded-full">
                    <img
                      src="https://cdn.bsky.app/img/avatar_thumbnail/plain/did:plc:6nueesku7rpq7v2odkvky4hh/bafkreiciuauao5r6wnil3y6utnmni2q5442xyjwhjkxst4fmzthqlojrpy@jpeg"
                      class="object-cover w-full h-full"
                    />
                  </div>
                </div>
                <div class="flex-1 text-gray-600">
                  <.input
                    field={@form[:body]}
                    type="textarea"
                    placeholder="What's up"
                    class="p-2 w-full rounded-lg min-h-6 bg-slate-50 dark:bg-slate-700"
                  />
                </div>
              </div>
            </.simple_form>
          </div>
        </div>
      </div>

      <div class="flex justify-between items-center p-4 mt-5 border-t border-slate-300">
        <div class="flex space-x-2">
          <button class="p-2 rounded-full hover:dark:bg-slate-800 hover:bg-purple-100">
            <.icon name="hero-photo" class="w-6 h-6 text-purple-500" />
          </button>
          <button class="p-2 rounded-full hover:dark:bg-slate-800 hover:bg-purple-100">
            <.icon name="hero-film" class="w-6 h-6 text-purple-500" />
          </button>
          <button class="p-2 rounded-full hover:dark:bg-slate-800 hover:bg-purple-100">
            <.icon name="hero-face-smile" class="w-6 h-6 text-purple-500" />
          </button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{post: post} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Timeline.change_post(post))
     end)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset = Timeline.change_post(socket.assigns.post, post_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Timeline.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_post(socket, :new, post_params) do
    case Timeline.create_post(post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp button_text(:new), do: "Post"
  defp button_text(:edit), do: "Save"

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
