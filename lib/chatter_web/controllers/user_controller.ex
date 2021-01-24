defmodule ChatterWeb.UserController do
  use ChatterWeb, :controller
  alias Chatter.{Repo, User}
  alias Doorman.Auth.Secret
  alias Doorman.Login.Session

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    {:ok, user} =
      %User{}
      |> User.changeset(params)
      |> Secret.put_session_secret()
      |> Repo.insert()

    conn
    |> Session.login(user)
    |> redirect(to: "/")
  end
end
