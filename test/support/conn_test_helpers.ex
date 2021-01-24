defmodule ChatterWeb.ConnTestHelpers do
  import Chatter.Factory

  def sign_in(conn) do
    user = build(:user) |> set_password("password") |> insert()

    conn
    |> Plug.Test.init_test_session(%{})
    |> Doorman.Login.Session.login(user)
  end
end
