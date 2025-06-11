defmodule PurpleSkyAppWeb.UserLive.Login do
  use PurpleSkyAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center dark:bg-slate-800">
      <div class="w-full max-w-md">
        <div class="p-8 border border-gray-700 rounded-2xl">
          <div class="mb-8 text-right">
            <div class="text-5xl font-extrabold text-purple-400">Sign in</div>
            <div class="mt-2 text-lg font-semibold text-slate-300">Don't have an account?</div>
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
                <label class="block mb-2 text-sm font-semibold text-slate-300">Email</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                    <svg class="w-5 h-5 text-gray-500" fill="none" viewBox="0 0 24 24">
                      <path
                        fill="currentColor"
                        fill-rule="evenodd"
                        clip-rule="evenodd"
                        d="M12 4a8 8 0 1 0 4.21 14.804 1 1 0 0 1 1.054 1.7A9.96 9.96 0 0 1 12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10c0 1.104-.27 2.31-.949 3.243-.716.984-1.849 1.6-3.331 1.465a4.2 4.2 0 0 1-2.93-1.585c-.94 1.21-2.388 1.94-3.985 1.715-2.53-.356-4.04-2.91-3.682-5.458s2.514-4.586 5.044-4.23c.905.127 1.68.536 2.286 1.126a1 1 0 0 1 1.964.368l-.515 3.545v.002a2.22 2.22 0 0 0 1.999 2.526c.75.068 1.212-.21 1.533-.65.358-.493.566-1.245.566-2.067a8 8 0 0 0-8-8Z"
                      />
                    </svg>
                  </div>
                  <.input
                    field={@form[:email]}
                    type="email"
                    class="w-full pl-16 text-gray-200 border-0 rounded-lg"
                    placeholder="Enter your email"
                    autocomplete="username"
                    required
                  />
                </div>
              </div>

              <div>
                <label class="block mb-2 text-sm font-semibold text-slate-300">Password</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                    <svg class="w-5 h-5 text-gray-500" fill="none" viewBox="0 0 24 24">
                      <path
                        fill="currentColor"
                        fill-rule="evenodd"
                        clip-rule="evenodd"
                        d="M7 7a5 5 0 0 1 10 0v2h1a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-9a2 2 0 0 1 2-2h1V7Zm-1 4v9h12v-9H6Zm9-2H9V7a3 3 0 1 1 6 0v2Zm-3 4a1 1 0 0 1 1 1v3a1 1 0 1 1-2 0v-3a1 1 0 0 1 1-1Z"
                      />
                    </svg>
                  </div>
                  <.input
                    field={@form[:password]}
                    type="password"
                    class="w-full pl-10 text-gray-200 border-0 rounded-lg"
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
                <label class="ml-2 text-sm text-gray-300">Keep me logged in</label>
              </div>
              <.link
                href={~p"/users/reset-password"}
                class="text-sm font-semibold text-gray-300 hover:text-purple-600"
              >
                Forgot password?
              </.link>
            </div>

            <div class="flex items-center justify-between pt-4">
              <.link
                navigate={~p"/"}
                class="px-6 py-3 bg-[#1e2936] text-[#aebbc9] font-semibold rounded-lg hover:bg-[#2e4052]"
              >
                Back
              </.link>
              <div class="flex-1"></div>
              <.button class="px-6 py-3 font-semibold text-white bg-purple-600 rounded-lg hover:bg-purple-500">
                Sign in
              </.button>
            </div>
          </.simple_form>

          <div class="mt-6 text-center">
            <span class="text-slate-300">Don't have an account?</span>
            <.link
              navigate={~p"/users/register"}
              class="ml-2 font-semibold text-purple-300 hover:underline"
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
