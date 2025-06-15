defmodule PurpleSkyAppWeb.UserLive.ForgotPassword do
  use PurpleSkyAppWeb, :live_view

  alias PurpleSkyApp.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center dark:bg-slate-800">
      <div class="w-full">
        <div class="p-8 border border-gray-200 shadow-2xl dark:shadow-slate-400 dark:border-gray-500 rounded-2xl">
          <div class="mb-8 text-right">
            <.header class="text-5xl">
              Forgot your password?
              <:subtitle>We'll send a password reset link to your inbox</:subtitle>
            </.header>
          </div>

          <.simple_form for={@form} id="reset_password_form" phx-submit="send_email" class="space-y-4">
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
            </div>

            <div class="flex items-center justify-end pt-4">
              <.button
                class="px-6 py-3 text-base font-semibold text-white bg-purple-500 rounded-lg hover:bg-purple-600 dark:hover:bg-purple-400"
                phx-disable-with="Sending..."
              >
                Send password reset instructions
              </.button>
            </div>
          </.simple_form>

          <p class="mt-4 text-sm text-center dark:text-slate-300 dark:hover:text-purple-300">
            <.link href={~p"/users/register"}>Sign up</.link>
            | <.link href={~p"/users/log-in"}>Sign in</.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset-password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
