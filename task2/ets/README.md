# Chat Room Application Usage Guide

Welcome to the Chat Room application! This guide provides comprehensive instructions on setting up, using the application, and specifically how users can write and receive messages through CLI.

## Getting Started

### Prerequisites

- Elixir 1.15 or later installed on your machine.
- Downloaded or cloned source code of the Chat Room application.

### Installation

1. **Install Dependencies:** Inside the project root, run `mix deps.get` to fetch the necessary Elixir dependencies.
2. **Compile the Application:** Execute `mix compile` to compile the source code.

### Starting the Application

1. Open a terminal session and run `iex -S mix` to start an Interactive Elixir session with the project loaded.
2. Initialize the application by running `App.start`. You should see "Chat Room CLI started."

## Writing and Receiving Messages

Upon joining the chat room, users can write messages intended for other users and receive messages. Here's how the message functionality works:

### Writing Messages

1. **Message File:** Each user has a `send.txt` file in their dedicated directory within `chat_room/<name>`. To send a message, the user writes the message content into their `send.txt` file.
2. **Broadcasting Messages:** The application continuously monitors the `send.txt` file. When it detects content, it broadcasts the message to all active users, appending the sender's name to the message.
3. **Automatic Clearance:** After broadcasting, the application clears the `send.txt` file, readying it for new messages.

### Receiving Messages

1. **Reception File:** Each user also has a `receive.txt` file. Incoming messages are appended to this file, enabling users to see messages sent to them by others.
2. **Continuous Monitoring:** The application regularly checks for new messages addressed to the user. When new messages are found, they're appended to the `receive.txt` file.
3. **Message Format:** Messages in `receive.txt` follow the format "sender: message", providing clear context on who sent each message.

## Using the Chat Room

### Basic Commands

- `join <name>`: Registers a new user and starts their message monitoring processes.
- `leave <name>`: Removes a user from the chat room, terminating their message monitoring.
- `exit`: Exits the Chat Room application CLI.

## Troubleshooting

- Ensure commands are typed correctly, as they are case-sensitive and require precise syntax.
- If messages don't appear to be sending or receiving correctly, verify the contents of `send.txt` and `receive.txt` for the respective user directories.

## Conclusion

The Chat Room application offers a unique CLI-based platform for real-time messaging among users. By following this guide, you should be able to seamlessly set up the application, join the chat room, and engage in conversations. Enjoy your chatting experience!
