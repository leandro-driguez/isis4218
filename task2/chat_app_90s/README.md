# Chat Room Application Usage Guide

Welcome to the Chat Room application! This guide will walk you through the steps to use the Chat Room from the Command Line Interface (CLI). Our application allows users to join a chat room, post messages, leave the chat room, and automatically saves the chat history in a designated folder.

## Getting Started

### Prerequisites

- Elixir 1.15 or later installed on your machine.
- The source code of the Chat Room application.

### Starting the Application

1. Open your terminal.
2. Navigate to the root directory of your Chat Room application project.
3. Run the command `iex -S mix` to start the Elixir Interactive Shell with your project loaded.
4. **Initiate the chat room by executing:** 
   ```elixir
   App.start
   ```
   This command sets up the chat room and prepares it for incoming commands.

## Using the Chat Room

Once the application is initialized in the IEx session, you're ready to interact with the chat room using the following commands:

### Joining the Chat Room

To join the chat room, type:

```
join <name>
```

Replace `<name>` with your desired username. This command creates a new user with the given name and subscribes them to the chat room.

### Posting Messages

To post a message to the chat room, type:

```
message <name> <msg>
```

Replace `<name>` with your username and `<msg>` with the message you want to send. This command sends your message to all subscribed users in the chat room.

### Leaving the Chat Room

To leave the chat room, type:

```
leave <name>
```

Replace `<name>` with the username you used to join the chat room. This command unsubscribes the user from receiving further messages and stops their process.

### Exiting the Application

To exit the application, simply type:

```
exit
```

This command stops all user processes and exits the chat application.

## Chat Logs

The Chat Room application automatically saves all received messages for each user in a file within the `chat_logs` directory, created at the root of your project. Each user's messages are saved in a separate file named `<username>_messages.txt`. You can review the chat history by opening these files.

## Troubleshooting

- **Command Not Recognized:** Ensure you type the commands exactly as shown, including spaces. The application is case-sensitive.
- **Messages Not Posting:** Verify that you've joined the chat room with the correct username and that you're using the correct format for posting messages.
- **Unable to Join:** If you cannot join the chat room, ensure that the chat room process has started correctly and that you're not trying to use a username that's already in use.

## Conclusion

The Chat Room application provides a simple yet powerful way to communicate in real-time from the CLI. Whether you're looking to chat with friends or colleagues, this guide should help you get started quickly and easily. Enjoy your chatting experience!