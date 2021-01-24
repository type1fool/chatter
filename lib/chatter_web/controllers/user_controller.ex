defmodule ChatterWeb.UserController do
  use ChatterWeb, :controller
  alias Chatter.User

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    {:ok, _user} =
      %User{}
      |> User.changeset(params)
      |> Secret.put_session_secret()
      |> Repo.insert()

    conn
    |> redirect(to: "/")
  end
end
