defmodule PurpleSkyAppWeb.UserLive.Settings do
  use PurpleSkyAppWeb, :live_view

  alias PurpleSkyApp.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center dark:bg-slate-800">
      <div class="w-full">
        <div class="p-8 border border-gray-200 shadow-2xl dark:shadow-slate-400 dark:border-gray-500 rounded-2xl">
          <div class="mb-8 text-right">
            <.header class="text-5xl">
              Account Settings
              <:subtitle>
                Manage your account email address and password settings
              </:subtitle>
            </.header>
          </div>

          <div class="space-y-12 divide-y">
            <div>
              <.simple_form
                for={@email_form}
                id="email_form"
                phx-submit="update_email"
                phx-change="validate_email"
                class="space-y-4"
              >
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
                        field={@email_form[:email]}
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
                      Current Password
                    </label>
                    <div class="relative">
                      <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                        <.icon name="hero-lock-closed" class="w-5 h-5 text-gray-500" />
                      </div>
                      <.input
                        field={@email_form[:current_password]}
                        name="current_password"
                        id="current_password_for_email"
                        type="password"
                        class="block w-full py-2 pl-3 pr-10 text-right text-gray-600 border-0 rounded-lg dark:text-gray-200 focus:outline-none"
                        placeholder="Enter your current password"
                        value={@email_form_current_password}
                        autocomplete="current-password"
                        required
                      />
                    </div>
                  </div>
                </div>

                <div class="flex items-center justify-end pt-4">
                  <.button
                    class="px-6 py-3 text-base font-semibold text-white bg-purple-500 rounded-lg hover:bg-purple-600 dark:hover:bg-purple-400"
                    phx-disable-with="Changing..."
                  >
                    Change Email
                  </.button>
                </div>
              </.simple_form>
            </div>

            <div class="pt-3">
              <.simple_form
                for={@password_form}
                id="password_form"
                action={~p"/users/log-in?_action=password-updated"}
                method="post"
                phx-change="validate_password"
                phx-submit="update_password"
                phx-trigger-action={@trigger_submit}
                class="space-y-4"
              >
                <input
                  name={@password_form[:email].name}
                  type="hidden"
                  id="hidden_user_email"
                  autocomplete="username"
                  value={@current_email}
                />

                <div class="space-y-4 dark:bg-slate-800">
                  <div>
                    <label class="block mb-2 text-sm font-semibold dark:text-slate-300 text-slate-500">
                      New Password
                    </label>
                    <div class="relative">
                      <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                        <.icon name="hero-lock-closed" class="w-5 h-5 text-gray-500" />
                      </div>
                      <.input
                        field={@password_form[:password]}
                        type="password"
                        class="block w-full py-2 pl-3 pr-10 text-right text-gray-600 border-0 rounded-lg dark:text-gray-200 focus:outline-none"
                        placeholder="Enter new password"
                        autocomplete="new-password"
                        required
                      />
                    </div>
                  </div>

                  <div>
                    <label class="block mb-2 text-sm font-semibold dark:text-slate-300 text-slate-500">
                      Confirm New Password
                    </label>
                    <div class="relative">
                      <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                        <.icon name="hero-lock-closed" class="w-5 h-5 text-gray-500" />
                      </div>
                      <.input
                        field={@password_form[:password_confirmation]}
                        type="password"
                        class="block w-full py-2 pl-3 pr-10 text-right text-gray-600 border-0 rounded-lg dark:text-gray-200 focus:outline-none"
                        placeholder="Confirm new password"
                        autocomplete="new-password"
                      />
                    </div>
                  </div>

                  <div>
                    <label class="block mb-2 text-sm font-semibold dark:text-slate-300 text-slate-500">
                      Current Password
                    </label>
                    <div class="relative">
                      <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                        <.icon name="hero-lock-closed" class="w-5 h-5 text-gray-500" />
                      </div>
                      <.input
                        field={@password_form[:current_password]}
                        name="current_password"
                        type="password"
                        class="block w-full py-2 pl-3 pr-10 text-right text-gray-600 border-0 rounded-lg dark:text-gray-200 focus:outline-none"
                        placeholder="Enter your current password"
                        id="current_password_for_password"
                        value={@current_password}
                        autocomplete="current-password"
                        required
                      />
                    </div>
                  </div>
                </div>

                <div class="flex items-center justify-end pt-4">
                  <.button
                    class="px-6 py-3 text-base font-semibold text-white bg-purple-500 rounded-lg hover:bg-purple-600 dark:hover:bg-purple-400"
                    phx-disable-with="Changing..."
                  >
                    Change Password
                  </.button>
                </div>
              </.simple_form>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm-email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
