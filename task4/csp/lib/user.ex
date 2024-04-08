use CSP

defmodule User do
  defstruct messages: [], name: "", recv_channel_pid: nil, chat_channel_pid: nil

  def start user_name, chat_channel_pid do
    {:ok, pid} = Channel.start_link()

    %User{
      messages: [],
      name: user_name,
      chat_channel_pid: chat_channel_pid,
      recv_channel_pid: pid,
    }
  end

  def recv_msg user do
    func = fn ->
      user.recv_channel_pid
      |> Channel.wrap
      |> Channel.get
    end

    case Utils.async_timeout(func, 100) do
      nil -> user
      msg -> %{user | messages: user.messages ++ [msg]}
    end
  end

  def send_msg user, msg do
    spawn(fn ->
      user.chat_channel_pid
      |> Channel.wrap
      |> Channel.put(%Message{username: user.name, text: msg})
    end)
  end
end
