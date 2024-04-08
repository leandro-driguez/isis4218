use CSP

defmodule Chat do
  defstruct users: [], recv_channel_pid: nil

  def start do
    {:ok, pid} = Channel.start_link()
    %Chat{recv_channel_pid: pid}
  end

  def add_user(chat, user_name) do
    new_user = User.start(user_name, chat.recv_channel_pid)
    {
      %{chat | users: chat.users ++ [new_user]},
      new_user
    }
  end

  def user_delete(chat, user) do
    users = chat.users
    |> Enum.filter(fn u -> u.name != user.name end)
    %{chat | users: users}
  end

  def write_message(user, message) do
    spawn(fn ->
      user.chat_channel_pid
      |> Channel.wrap
      |> Channel.put(%Message{username: user.name, text: message})
    end)
  end

  def recv_messages(chat) do
    func = fn ->
      msg = chat.recv_channel_pid
      |> Channel.wrap
      |> Channel.get

      Enum.each(chat.users, fn user ->
        spawn(fn ->
          user.recv_channel_pid
          |> Channel.wrap
          |> Channel.put(msg)
        end)
      end)
    end

    Utils.async_timeout(func, 100)
  end
end
