defmodule Message do
  @moduledoc """
  A struct for representing a chat message, including the sender's username and the message text.
  """

  # Define the Message struct with username and text fields.
  defstruct username: "", text: ""
end

defmodule Utils do
  @moduledoc """
  Provides utility functions, including an implementation for running a function
  with a timeout in an asynchronous manner.
  """

  @doc """
  Executes a given function asynchronously with a specified timeout.

  If the function completes within the timeout, its result is returned. If the function
  does not complete within the timeout, `nil` is returned.

  ## Parameters

  - `func`: The function to be executed asynchronously.
  - `timeout`: The maximum time in milliseconds to wait for `func` to complete.

  ## Returns

  The result of `func` if it completes within the timeout, otherwise `nil`.
  """
   def async_timeout(func, timeout) do
    pid = Task.async(func)
    try do
      Task.await(pid, timeout)
    catch
      # Catches and ignores exits from the task, returning nil if the task exits before completion.
      :exit, _ -> nil
    end
  end
end
