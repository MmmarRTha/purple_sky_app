defmodule PurpleSkyAppWeb.PostLive.FormComponent do
  use PurpleSkyAppWeb, :live_component

  alias PurpleSkyApp.Timeline

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 flex flex-col items-center bg-black/80 animate-fadeIn">
      <div class="w-full max-w-2xl border rounded-lg bg-slate-900 border-slate-700 animate-zoomIn">
        <div class="flex flex-col h-full">
          <div class="flex items-center justify-between p-4">
            <button class="px-3 py-2 font-semibold text-purple-400 rounded-full hover:bg-slate-900">
              Cancel
            </button>
            <div class="flex-1"></div>
            <button class="px-4 py-2 font-semibold text-white bg-purple-600 rounded-full disabled:opacity-50">
              Post
            </button>
          </div>

          <div class="flex-1 p-4">
            <div class="flex space-x-4">
              <div class="w-12 h-12 overflow-hidden rounded-full bg-slate-900">
                <img
                  src="https://cdn.bsky.app/img/avatar_thumbnail/plain/did:plc:6nueesku7rpq7v2odkvky4hh/bafkreiciuauao5r6wnil3y6utnmni2q5442xyjwhjkxst4fmzthqlojrpy@jpeg"
                  class="object-cover w-full h-full"
                />
              </div>
              <div class="flex-1">
                <.simple_form
                  for={@form}
                  id="post-form"
                  phx-target={@myself}
                  phx-change="validate"
                  phx-submit="save"
                  class="text-white "
                >
                  <.input field={@form[:body]} type="textarea" placeholder="What's up" />
                </.simple_form>
              </div>
            </div>
          </div>

          <div class="flex items-center justify-between p-4 border-t border-slate-700">
            <div class="flex space-x-2">
              <button class="p-2 rounded-full hover:bg-slate-800">
                <svg class="w-6 h-6 text-purple-500" fill="none" viewBox="0 0 24 24">
                  <path
                    fill="currentColor"
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M3 4a1 1 0 0 1 1-1h16a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V4Zm2 1v7.213l1.246-.932.044-.03a3 3 0 0 1 3.863.454c1.468 1.58 2.941 2.749 4.847 2.749 1.703 0 2.855-.555 4-1.618V5H5Zm14 10.357c-1.112.697-2.386 1.097-4 1.097-2.81 0-4.796-1.755-6.313-3.388a1 1 0 0 0-1.269-.164L5 14.712V19h14v-3.643ZM15 8a1 1 0 1 0 0 2 1 1 0 0 0 0-2Zm-3 1a3 3 0 1 1 6 0 3 3 0 0 1-6 0Z"
                  />
                </svg>
              </button>
              <button class="p-2 rounded-full hover:bg-slate-800">
                <svg class="w-6 h-6 text-purple-500" fill="none" viewBox="0 0 24 24">
                  <path
                    fill="currentColor"
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M3 4a1 1 0 011-1h16a1 1 0 011 1v16a1 1 0 01-1 1H4a1 1 0 01-1-1V4Zm2 1v2h2V5H5Zm4 0v6h6V5H9Zm8 0v2h2V5h-2Zm2 4h-2v2h2V9Zm0 4h-2v2h2V13Zm0 4h-2V19h2ZM15 19v-6H9v6h6Zm-8 0v-2H5v2h2Zm-2-4h2v-2H5v2Zm0-4h2V9H5v2Z"
                  />
                </svg>
              </button>
              <button class="p-2 rounded-full hover:bg-slate-800">
                <svg class="w-6 h-6 text-purple-500" fill="none" viewBox="0 0 24 24">
                  <path
                    fill="currentColor"
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M4 3a1 1 0 0 0-1 1v16a1 1 0 0 0 1 1h16a1 1 0 0 0 1-1V4a1 1 0 0 0-1-1H4Zm1 16V5h14v14H5Zm10.725-5.2c0 .566-.283.872-.802.872-.538 0-.848-.318-.848-.872v-3.635c0-.512.314-.826.82-.826h2.496c.35 0 .609.272.609.64 0 .369-.26.629-.609.629h-1.666v.973h1.47c.365 0 .608.248.608.613 0 .36-.247.613-.608.613h-1.47v.993Z"
                  />
                </svg>
              </button>
              <button class="p-2 rounded-full hover:bg-slate-800">
                <svg class="w-6 h-6 text-purple-500" fill="none" viewBox="0 0 24 24">
                  <path
                    fill="currentColor"
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M12 4a8 8 0 1 0 0 16 8 8 0 0 0 0-16ZM2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10S2 17.523 2 12Zm8-5a1 1 0 0 1 1 1v3a1 1 0 1 1-2 0V8a1 1 0 0 1 1-1Zm4 0a1 1 0 0 1 1 1v3a1 1 0 1 1-2 0V8a1 1 0 0 1 1-1Zm-5.894 7.803a1 1 0 0 1 1.341-.447c1.719.859 3.387.859 5.106 0a1 1 0 1 1 .894 1.788c-2.281 1.141-4.613 1.141-6.894 0a1 1 0 0 1-.447-1.341Z"
                  />
                </svg>
              </button>
            </div>
          </div>
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

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
