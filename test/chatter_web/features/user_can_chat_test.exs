defmodule ChatterWeb.UserCanChatTest do
  use ChatterWeb.FeatureCase, async: true

  test "user can chat with others successfully", %{metadata: metadata} do
    room = insert(:chat_room)
    user1 = insert(:user)
    user2 = insert(:user)
    greeting = "Hi everyone"
    greeting_response = "Hi, welcome to #{room.name}"

    session1 =
      metadata
      |> new_session()
      |> visit(rooms_index())
      |> sign_in(as: user1)
      |> join_room(room.name)

    session2 =
      metadata
      |> new_session()
      |> visit(rooms_index())
      |> sign_in(as: user2)
      |> join_room(room.name)

    session1
    |> add_message(greeting)

    session2
    |> assert_has(query_message(greeting, author: user1))
    |> add_message(greeting_response)

    session1
    |> assert_has(query_message(greeting_response, author: user2))
  end

  test "new user can see previous messages in chat room", %{metadata: metadata} do
    room = insert(:chat_room)
    user1 = insert(:user)
    user2 = insert(:user)

    metadata
    |> new_session()
    |> visit(rooms_index())
    |> sign_in(as: user1)
    |> join_room(room.name)
    |> add_message("Welcome future users")

    metadata
    |> new_session()
    |> visit(rooms_index())
    |> sign_in(as: user2)
    |> join_room(room.name)
    |> assert_has(query_message("Welcome future users", author: user1))
  end

  defp new_session(metadata) do
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    session
  end

  defp rooms_index, do: Routes.chat_room_path(@endpoint, :index)

  defp join_room(session, name) do
    session
    |> click(Query.link(name))
  end

  defp add_message(session, message) do
    session
    |> fill_in(Query.text_field("New Message"), with: message)
    |> click(Query.button("Send"))
  end

  defp query_message(text, author: author) do
    message = "#{author.email}: #{text}"
    Query.data("role", "message", text: message)
  end
end
