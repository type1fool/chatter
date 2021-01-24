defmodule ChatterWeb.UserCanChatTest do
  use ChatterWeb.FeatureCase, async: true

  test "user can chat with others successfully", %{metadata: metadata} do
    room = insert(:chat_room)
    greeting = "Hi everyone"
    greeting_response = "Hi, welcome to #{room.name}"

    user_a =
      metadata
      |> new_user()
      |> visit(rooms_index())
      |> join_room(room.name)

    user_b =
      metadata
      |> new_user()
      |> visit(rooms_index())
      |> join_room(room.name)

    user_a
    |> add_message(greeting)

    user_b
    |> assert_has(query_message(greeting))
    |> add_message(greeting_response)

    user_a
    |> assert_has(query_message(greeting_response))
  end

  defp new_user(metadata) do
    {:ok, user} = Wallaby.start_session(metadata: metadata)
    user
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

  defp query_message(message) do
    Query.data("role", "message", text: message)
  end
end
