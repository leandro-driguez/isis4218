defmodule CspTest do
  use ExUnit.Case
  doctest Chat

  test "simple test" do
    chatroom = Chat.start

    {chatroom, user1} = Chat.add_user(chatroom, "user1")
    {chatroom, user2} = Chat.add_user(chatroom, "user2")

    Chat.write_message(user1, "both users will receive this message")
    Chat.write_message(user2, "this message too")
    Chat.recv_messages(chatroom)
    Chat.recv_messages(chatroom)

    user1 = User.recv_msg(user1)
    user2 = User.recv_msg(user2)

    user1 = User.recv_msg(user1)
    user2 = User.recv_msg(user2)

    chatroom = Chat.user_delete(chatroom, user2)

    Chat.write_message(user1, "only the user1 will receive this message")
    Chat.recv_messages(chatroom)

    user1 = User.recv_msg(user1)
    user2 = User.recv_msg(user2)

    assert length(user1.messages) == 3
    assert length(user2.messages) == 2
  end
end
