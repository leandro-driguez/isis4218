# Chat Room

In this project, the Communicating Sequential Processes (CSP) model is prominently utilized, facilitated through the use of the [CSPEx library](https://hexdocs.pm/cspex/CSP.html), which provides channels as a core abstraction for inter-process communication. This choice aligns perfectly with Elixir's capabilities for handling concurrency, leveraging its lightweight processes to implement the CSP model efficiently. Below, we'll explore how CSP is applied within the project, specifically focusing on channel usage and the interaction between chatrooms and users.

### Utilizing CSPEx for Channels

The [CSPEx library](https://hexdocs.pm/cspex/CSP.html) is instrumental in this project, introducing the concept of channels to manage communication between different processes, such as chatrooms and users. Channels serve as conduits for messages, ensuring that data flows seamlessly and concurrently across the application.

### Channels in Action

- **Chatroom Initialization**: Upon starting a chatroom with `Chat.start`, a new channel is created and linked to this chatroom. This channel is dedicated to receiving messages that will be broadcasted to all users in the chatroom.
  
  ```elixir
  def start do
    {:ok, pid} = Channel.start_link()
    %Chat{recv_channel_pid: pid}
  end
  ```

- **User Communication**: When a user is added to a chatroom via `Chat.add_user`, the user is initialized with a reference to the chatroom's receive channel (`recv_channel_pid`). This setup allows the user to send messages to the chatroom, which then broadcasts these messages to other users.

- **Message Broadcasting and Reception**: The `Chat.write_message` function demonstrates CSP in action, where a message sent by a user is placed into the chatroom's channel. The chatroom then retrieves this message and forwards it to all users' channels, showcasing the message-passing mechanism central to CSP.

  ```elixir
  def write_message(user, message) do
    spawn(fn ->
      Channel.wrap(user.chat_channel_pid)
      |> Channel.put(%Message{username: user.name, text: message})
    end)
  end
  ```

- **Asynchronous Message Handling**: The `Utils.async_timeout` function encapsulates the asynchronous nature of message handling in CSP, allowing the system to attempt message reception within a specified timeout period. This approach ensures that the system remains responsive, even when messages are not immediately available.

  ```elixir
  def async_timeout(func, timeout) do
    pid = Task.async(func)
    try do
      Task.await(pid, timeout)
    catch
      :exit, _ -> nil
    end
  end
  ```

### Summary

By leveraging the [CSPEx library](https://hexdocs.pm/cspex/CSP.html), this project effectively implements the CSP model to facilitate concurrent communication through channels. Each chatroom and user operates as a separate process, with channels serving as the primary means for passing messages. This design allows for efficient, non-blocking communication patterns, exemplifying the power of Elixir for building concurrent applications. Through the use of channels, the application ensures that messages are asynchronously sent and received, adhering to the principles of CSP and showcasing the strengths of Elixir's process-based concurrency model.