defmodule ChatterWeb.UserController do
  use ChatterWeb, :controller
  alias Chatter.{Accounts, User}
  alias Doorman.Login.Session

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> Session.login(user)
        |> redirect(to: "/")

      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
