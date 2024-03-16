defmodule Chat do
  @moduledoc """
  Manages chat operations including starting the service, user management,
  and message handling using Mnesia as the underlying data store.
  """

  @doc """
  Starts the chat service by ensuring Mnesia is started and the users table exists.
  """
  def start do
    :ok = :mnesia.start()
    create_users_table()
  end

  @doc """
  Adds a new user with the given details to the chat service.

  ## Parameters

  - user: A map with `:name`, an empty `:messages` list, and PIDs for send and receive processes.
  """
  def add_user(%{name: name, messages: [], send_pid: send_pid, receive_pid: recv_pid}) do
    :mnesia.transaction(fn ->
      :mnesia.write({:users, name, [], send_pid, recv_pid})
    end)
  end

  @doc """
  Deletes a user from the chat service by their name and terminates their processes.

  ## Parameters

  - user_name: The name of the user to delete.
  """
  def user_delete(user_name) do
    {:atomic, [{:users, _, _, send_pid, recv_pid}]} = :mnesia.transaction(fn ->
      :mnesia.read({:users, user_name})
    end)
    :mnesia.transaction(fn ->
      :mnesia.delete({:users, user_name})
    end)
    Process.exit(send_pid, :kill)
    Process.exit(recv_pid, :kill)
  end

  @doc """
  Writes a message from a user, distributing it to all active users' message lists.

  ## Parameters

  - user: The name of the user sending the message.
  - message: The content of the message.
  """
  def write_message(user, message) do
    :mnesia.transaction(fn ->
      for {:users, user_name, messages, send_pid, recv_pid} <- :mnesia.match_object({:users, :_, :_, :_, :_}) do
        updated_messages = [{user, message} | messages]
        :mnesia.write({:users, user_name, updated_messages, send_pid, recv_pid})
      end
    end)
  end

  @doc """
  Retrieves the list of messages for a given user.

  ## Parameters

  - user: The name of the user whose messages are to be retrieved.

  ## Returns

  - `{:ok, messages}` on success, `{:error, :not_found}` if the user does not exist.
  """
  def get_user_messages(user) do
    case :mnesia.transaction(fn -> :mnesia.read({:users, user}) end) do
      {:atomic, [{:users, _, messages, _, _}]} -> {:ok, messages}
      _ -> {:error, :not_found}
    end
  end

  defp create_users_table do
    unless Enum.member?(:mnesia.system_info(:tables), :users) do
      :mnesia.create_table(:users, attributes: [:user_name, :messages, :send_pid, :recv_pid], type: :set)
      |> handle_table_creation_response()
    end
  end

  defp handle_table_creation_response({:atomic, :ok}), do: :ok
  defp handle_table_creation_response({:aborted, reason}), do: raise "Failed to create users table: #{inspect(reason)}"
end
