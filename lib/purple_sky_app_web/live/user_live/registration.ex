defmodule PurpleSkyAppWeb.UserLive.Registration do
  use PurpleSkyAppWeb, :live_view

  alias PurpleSkyApp.Accounts
  alias PurpleSkyApp.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center dark:bg-slate-800">
      <div class="w-full max-w-md">
        <div class="p-8 border border-gray-200 shadow-2xl dark:shadow-slate-400 dark:border-gray-500 rounded-2xl">
          <div class="mb-8 text-right">
            <div class="text-5xl font-extrabold text-purple-500 dark:text-purple-400">Sign up</div>
          </div>

          <.simple_form
            for={@form}
            id="registration_form"
            phx-submit="save"
            phx-change="validate"
            phx-trigger-action={@trigger_submit}
            action={~p"/users/log-in?_action=registered"}
            method="post"
            class="space-y-4"
          >
            <.error :if={@check_errors}>
              <div class="p-3 mb-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800">
                Oops, something went wrong! Please check the errors below.
              </div>
            </.error>

            <div class="space-y-4 dark:bg-slate-800">
              <div>
                <label class="block mb-2 text-sm font-semibold dark:text-slate-300 text-slate-500">
                  Email
                </label>
                <div class="relative">
                  <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                    <.icon name="hero-at-symbol-mini" class="text-gray-500" />
                  </div>
                  <.input
                    field={@form[:email]}
                    type="email"
                    class="block w-full py-2 pl-3 pr-10 text-right text-gray-600 border-0 rounded-lg dark:text-gray-200 focus:outline-none"
                    placeholder="Enter your email"
                    autocomplete="username"
                    required
                  />
                </div>
              </div>

              <div>
                <label class="block mb-2 text-sm font-semibold dark:text-slate-300 text-slate-500">
                  Username
                </label>
                <div class="relative">
                  <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                    <.icon name="hero-user" class="text-gray-500" />
                  </div>
                  <.input
                    field={@form[:username]}
                    type="text"
                    class="block w-full py-2 pl-3 pr-10 text-right text-gray-600 border-0 rounded-lg dark:text-gray-200 focus:outline-none"
                    placeholder="Choose a username"
                    required
                  />
                </div>
              </div>

              <div>
                <label class="block mb-2 text-sm font-semibold dark:text-slate-300 text-slate-500">
                  Password
                </label>
                <div class="relative">
                  <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                    <.icon name="hero-lock-closed" class="w-5 h-5 text-gray-500" />
                  </div>
                  <.input
                    field={@form[:password]}
                    type="password"
                    class="block w-full py-2 pl-3 pr-10 text-right text-gray-600 border-0 rounded-lg dark:text-gray-200 focus:outline-none"
                    placeholder="Create a password"
                    autocomplete="new-password"
                    required
                  />
                </div>
              </div>
            </div>

            <div class="flex items-center justify-between pt-4">
              <.link
                navigate={~p"/"}
                class="px-6 py-3 font-semibold text-gray-600 bg-gray-200 rounded-lg dark:text-gray-200 hover:bg-gray-300 dark:bg-slate-600 dark:hover:bg-slate-500"
              >
                Back
              </.link>
              <div class="flex-1"></div>
              <.button class="px-6 py-3 text-base font-semibold text-white bg-purple-500 rounded-lg hover:bg-purple-600 dark:hover:bg-purple-400">
                Create account
              </.button>
            </div>
          </.simple_form>

          <div class="mt-6 text-center">
            <span class="dark:text-slate-300 text-slate-500">Already have an account?</span>
            <.link
              navigate={~p"/users/log-in"}
              class="ml-2 font-semibold text-purple-600 dark:text-purple-300 hover:underline"
            >
              Sign in
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
