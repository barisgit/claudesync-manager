# ClaudeSync Manager

ClaudeSync Manager is a bash script that simplifies the process of setting up, configuring, and using ClaudeSync across your entire computer. It provides an easy-to-use interface for managing various aspects of ClaudeSync, including file synchronization, configuration, authentication, and troubleshooting.

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/barisgit/claudesync-manager.git
   cd claudesync-manager
   ```

2. Make the script executable:

   ```
   chmod +x claude.sh
   ```

3. Run the script once to set up the 'claude' alias:

   ```
   ./claude.sh
   ```

   Choose option 11 to set up the 'claude' alias.

4. Restart your terminal or run the appropriate source command for your shell:
   - For bash: `source ~/.bashrc`
   - For zsh: `source ~/.zshrc`
   - For fish: `source ~/.config/fish/config.fish`

## Usage

After setting up the alias, you can use the ClaudeSync Manager from any directory on your computer by simply typing `claude` in your terminal.

The script provides the following options:

1. Sync Files
2. Configure ClaudeSync
3. Set Up File Categories
4. Manage Authentication
5. Manage Organization and Project
6. Set Up Scheduled Sync
7. Disable Scheduled Sync
8. List Chats
9. Create New Chat
10. Troubleshoot ClaudeSync
11. Set up 'claude' alias
12. Clean up Claude files
13. Exit

To use any of these options, run `claude` and enter the corresponding number.

## Features

- **Easy Setup**: The script automatically sets up a Python virtual environment and installs ClaudeSync if it's not already installed.
- **Configuration Management**: Easily configure ClaudeSync settings like upload delay, two-way sync, and log level.
- **File Category Management**: Set up and manage file categories for better organization.
- **Authentication Handling**: Manage ClaudeSync authentication, including login and logout.
- **Organization and Project Management**: Select or create organizations and projects.
- **Scheduled Syncing**: Set up or disable scheduled file synchronization.
- **Chat Management**: List existing chats or create new ones.
- **Troubleshooting**: Built-in troubleshooting options for common issues.
- **Cleanup**: Option to remove all Claude-related files and directories in the current directory.

## Manually Editing Configuration Files

If you need to manually edit your shell configuration files, here's how you can open them:

### For Bash

1. Open a terminal.
2. Use a text editor to open the `.bashrc` file in your home directory. For example:

   ```
   nano ~/.bashrc
   ```

   Or if you prefer vim:

   ```
   vim ~/.bashrc
   ```

3. After making changes, save the file and exit the editor.
4. To apply the changes in your current session, run:
   ```
   source ~/.bashrc
   ```

### For Zsh

1. Open a terminal.
2. Use a text editor to open the `.zshrc` file in your home directory. For example:

   ```
   nano ~/.zshrc
   ```

   Or if you prefer vim:

   ```
   vim ~/.zshrc
   ```

3. After making changes, save the file and exit the editor.
4. To apply the changes in your current session, run:
   ```
   source ~/.zshrc
   ```

### For Fish

1. Open a terminal.
2. Use a text editor to open the `config.fish` file. The location may vary, but it's typically in `~/.config/fish/`. For example:

   ```
   nano ~/.config/fish/config.fish
   ```

   Or if you prefer vim:

   ```
   vim ~/.config/fish/config.fish
   ```

3. After making changes, save the file and exit the editor.
4. To apply the changes in your current session, run:
   ```
   source ~/.config/fish/config.fish
   ```

Note: If you're not comfortable with command-line text editors, you can also use graphical text editors. Just make sure you have the necessary permissions to edit these files.

## Verifying the Alias

To verify that the 'claude' alias is set correctly, you can use the following commands:

- For bash and zsh:

  ```
  alias claude
  ```

- For fish:
  ```
  functions claude
  ```

These commands will display the current definition of the 'claude' alias or function. If set correctly, it should point to the location of your `claude.sh` script.

## Troubleshooting Alias Issues

If you encounter issues with the 'claude' alias, you can manually check and remove it:

1. Open your shell configuration file (`.bashrc`, `.zshrc`, or `config.fish`).
2. Look for any lines containing `alias claude=` or `function claude`.
3. If found, you can manually remove these lines.
4. Save the file and run the appropriate source command or restart your terminal.
5. Run the ClaudeSync Manager script again and choose option 11 to set up the alias.

If problems persist, you may need to check for alias definitions in other configuration files specific to your system.

## Notes

- The script creates a Python virtual environment in the directory where it's first run. This environment is reused for subsequent runs.
- The 'claude' alias allows you to run the script from any location on your computer.
- Always ensure you're in the correct directory when syncing files or managing chats.
- If you move the script to a different location after setting up the alias, you'll need to update the alias by running the script again and choosing option 11.

## Troubleshooting

If you encounter any issues:

1. Ensure Python 3.12.5 or newer is installed on your system.
2. Check your internet connection.
3. Verify that you have the necessary permissions in the directories you're working with.
4. Use the built-in troubleshooting option (option 10) in the script.

For more detailed information about ClaudeSync, refer to the official documentation.
