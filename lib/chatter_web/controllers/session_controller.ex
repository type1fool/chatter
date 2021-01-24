defmodule ChatterWeb.SessionController do
  use ChatterWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    user = Doorman.authenticate(email, password)
    conn
    |> Doorman.Login.Session.login(user)
    |> redirect(to: "/")
  end
end
