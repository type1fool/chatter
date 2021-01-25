defmodule ChatterWeb.ChatRoomChannelTest do
  use ChatterWeb.ChannelCase, async: false

  describe "new_message event" do
    test "broadcasts message to all users" do
      email = "random@example.com"
      room = insert(:chat_room)
      {:ok, _, socket} = join_channel("chat_room:#{room.name}", as: email)
      payload = %{"body" => "hello world!"}

      push(socket, "new_message", payload)

      expected_payload = Map.put(payload, "author", email)
      assert_broadcast "new_message", ^expected_payload
    end

  end

  defp join_channel(topic, as: email) do
    ChatterWeb.UserSocket
    |> socket("", %{email: email})
    |> subscribe_and_join(ChatterWeb.ChatRoomChannel, topic)
  end
end
