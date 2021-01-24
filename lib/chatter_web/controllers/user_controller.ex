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
    changeset =
      %User{}
      |> User.changeset(params)
      |> Secret.put_session_secret()

    case Repo.insert(changeset) do
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
