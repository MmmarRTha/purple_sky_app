defmodule PurpleSkyAppWeb.UserLive.Login do
  use PurpleSkyAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center dark:bg-slate-800">
      <div class="w-full max-w-md">
        <div class="p-8 border border-gray-200 shadow-2xl dark:shadow-slate-400 dark:border-gray-500 rounded-2xl">
          <div class="mb-8 text-right">
            <div class="text-5xl font-extrabold text-purple-500 dark:text-purple-400">Sign in</div>
            <div class="mt-2 text-lg font-semibold dark:text-slate-300 text-slate-500">
              Don't have an account?
            </div>
          </div>

          <.simple_form
            for={@form}
            id="login_form"
            action={~p"/users/log-in"}
            phx-update="ignore"
            class="space-y-6"
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
                    field={@form[:email]}
                    type="email"
                    class="block w-full py-2 pl-3 pr-10 text-right text-gray-600 border-0 rounded-lg dark:text-gray-200 focus:outline-none"
                    placeholder="Enter your email"
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
                    placeholder="Enter your password"
                    autocomplete="current-password"
                    required
                  />
                </div>
              </div>
            </div>

            <div class="flex items-center justify-between">
              <div class="flex items-center">
                <.input
                  field={@form[:remember_me]}
                  type="checkbox"
                  class="rounded bg-slate-900 border-slate-700"
                />
                <label class="ml-2 text-sm dark:text-slate-300 text-slate-500">
                  Keep me logged in
                </label>
              </div>
              <.link
                href={~p"/users/reset-password"}
                class="text-sm font-semibold dark:text-slate-300 text-slate-500 hover:text-purple-600"
              >
                Forgot password?
              </.link>
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
                Sign in
              </.button>
            </div>
          </.simple_form>

          <div class="mt-6 text-center">
            <span class="dark:text-slate-300 text-slate-500">Don't have an account?</span>
            <.link
              navigate={~p"/users/register"}
              class="ml-2 font-semibold text-purple-600 dark:text-purple-300 hover:underline"
            >
              Sign up
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
