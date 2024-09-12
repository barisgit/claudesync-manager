#!/bin/bash

# Complete ClaudeSync Manager Script

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to setup ClaudeSync in the current directory
setup_claude() {
    echo "Setting up ClaudeSync in the current directory..."

    # Check for Python
    if ! command_exists python3; then
        echo "Python 3 is not installed. Please install Python 3.12.5 or newer and try again."
        return 1
    fi

    # Create venv if it doesn't exist
    if [ ! -d "venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv venv
    fi

    # Activate virtual environment
    echo "Activating virtual environment..."
    source venv/bin/activate

    # Check for pip
    if ! command_exists pip; then
        echo "pip is not installed in the virtual environment. Please check your Python installation and try again."
        return 1
    fi

    # Install ClaudeSync
    pip install claudesync

    # Verify installation
    if ! command_exists claudesync; then
        echo "ClaudeSync installation failed. Please check your internet connection and try again."
        return 1
    fi

    # Display version
    claudesync --version

    # Project type selection for .claudeignore
    echo "Select your project type for .claudeignore template:"
    echo "1. ESP-IDF"
    echo "2. Flutter"
    echo "3. Python"
    echo "4. Node.js"
    echo "5. React"
    echo "6. Java"
    echo "7. Other (General)"
    read -p "Enter your choice (1-7): " project_type

    case $project_type in
        1) # ESP-IDF
            cat << EOF > .claudeignore
build/
sdkconfig
sdkconfig.old
dependencies.lock
managed_components/
.vscode/
*.log
temp/
secrets.txt
EOF
            ;;
        2) # Flutter
            cat << EOF > .claudeignore
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
build/
*.log
.vscode/
.idea/
*.iml
.DS_Store
.pub-cache/
.pub/
/build/
secrets.yaml
EOF
            ;;
        3) # Python
            cat << EOF > .claudeignore
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST
.venv
venv/
ENV/
.vscode/
*.log
.DS_Store
secrets.py
EOF
            ;;
        4) # Node.js
            cat << EOF > .claudeignore
node_modules/
npm-debug.log
yarn-error.log
.pnp/
.pnp.js
coverage/
build/
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local
.vscode/
*.log
secrets.js
EOF
            ;;
        5) # React
            cat << EOF > .claudeignore
node_modules/
/build
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.vscode/
*.log
secrets.js
EOF
            ;;
        6) # Java
            cat << EOF > .claudeignore
*.class
*.log
*.ctxt
.mtj.tmp/
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar
hs_err_pid*
.idea/
*.iml
.vscode/
target/
build/
out/
.gradle/
secrets.properties
EOF
            ;;
        7) # Other (General)
            cat << EOF > .claudeignore
.vscode/
.idea/
*.log
temp/
build/
dist/
node_modules/
__pycache__/
*.pyc
.DS_Store
secrets.*
*.env
EOF
            ;;
        *)
            echo "Invalid choice. Using general template."
            cat << EOF > .claudeignore
.vscode/
.idea/
*.log
temp/
build/
dist/
node_modules/
__pycache__/
*.pyc
.DS_Store
secrets.*
*.env
EOF
            ;;
    esac

    echo "ClaudeSync has been set up successfully in the current directory."
    echo "The .claudeignore file has been created based on your project type."
}

# Function to configure ClaudeSync
configure_claudesync() {
    echo "Configuring ClaudeSync..."
    
    # Set upload delay
    read -p "Enter upload delay in seconds (default is 0.5): " upload_delay
    claudesync config set upload_delay ${upload_delay:-0.5}
    
    # Enable two-way sync (experimental)
    read -p "Enable two-way sync? (y/n, default is n): " enable_two_way
    if [[ $enable_two_way == "y" ]]; then
        claudesync config set two_way_sync true
    else
        claudesync config set two_way_sync false
    fi
    
    # Enable automatic deletion of remote files not present locally
    read -p "Enable automatic deletion of remote files not present locally? (y/n, default is n): " enable_prune
    if [[ $enable_prune == "y" ]]; then
        claudesync config set prune_remote_files true
    else
        claudesync config set prune_remote_files false
    fi
    
    # Set log level
    read -p "Enter log level (INFO/DEBUG, default is INFO): " log_level
    claudesync config set log_level ${log_level:-INFO}
    
    echo "Configuration complete. You can further customize using 'claudesync config' commands."
}

# Function to set up file categories
setup_file_categories() {
    echo "Setting up file categories..."
    read -p "Enter category name: " category_name
    read -p "Enter category description: " category_desc
    read -p "Enter file patterns (space-separated): " category_patterns
    claudesync config category add "$category_name" --description "$category_desc" --patterns $category_patterns
    echo "Category '$category_name' has been added."
}

# Function to manage authentication
manage_auth() {
    echo "Authentication Management"
    echo "1. Login"
    echo "2. Logout"
    echo "3. List Authentication"
    read -p "Enter your choice (1-3): " auth_choice

    case $auth_choice in
        1) claudesync auth login ;;
        2) claudesync auth logout ;;
        3) claudesync auth ls ;;
        *) echo "Invalid choice. Skipping authentication management." ;;
    esac
}

# Function to manage organization and project
manage_org_project() {
    echo "Organization and Project Management"
    echo "1. Select Organization"
    echo "2. List Organizations"
    echo "3. Select Project"
    echo "4. Create Project"
    echo "5. List Projects"
    read -p "Enter your choice (1-5): " op_choice

    case $op_choice in
        1) claudesync organization set ;;
        2) claudesync organization ls ;;
        3) claudesync project set ;;
        4) claudesync project create ;;
        5) claudesync project ls ;;
        *) echo "Invalid choice. Skipping organization and project management." ;;
    esac
}

# Updated function to set up scheduled syncing
setup_scheduled_sync() {
    echo "Setting up scheduled syncing..."
    if ! claudesync schedule 2>/dev/null; then
        echo "Automatic scheduling failed. Let's set up a manual cron job."
        
        # Get the full path to the claudesync executable
        claudesync_path=$(which claudesync)
        
        if [ -z "$claudesync_path" ]; then
            echo "Error: claudesync executable not found in PATH."
            return 1
        fi
        
        # Get sync interval from user
        read -p "Enter sync interval in minutes (e.g., 60 for hourly): " interval
        
        # Create cron job string
        cron_job="*/$interval * * * * $claudesync_path push > /dev/null 2>&1"
        
        # Add cron job
        (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
        
        echo "Manual cron job set up. ClaudeSync will sync every $interval minutes."
    else
        echo "Scheduled sync has been set up successfully."
    fi
}

# New function to disable scheduled syncing
disable_scheduled_sync() {
    echo "Disabling scheduled syncing..."
    
    # Check if there's a claudesync job in the crontab
    if crontab -l 2>/dev/null | grep -q "claudesync push"; then
        # Remove the claudesync job from crontab
        crontab -l 2>/dev/null | grep -v "claudesync push" | crontab -
        echo "Scheduled sync has been disabled."
    else
        echo "No scheduled sync job found in crontab."
    fi
    
    # Also try to use claudesync's built-in method to disable scheduling
    if claudesync schedule --disable 2>/dev/null; then
        echo "Built-in scheduled sync has been disabled."
    else
        echo "No built-in scheduled sync found or unable to disable."
    fi
}

# Function for troubleshooting
troubleshoot_claudesync() {
    echo "ClaudeSync Troubleshooting"
    echo "1. Authentication Issues"
    echo "2. Synchronization Errors"
    echo "3. Performance Issues"
    echo "4. Windows-Specific Issues"
    echo "5. Enable Detailed Logging"
    echo "6. View Logs"
    read -p "Enter your choice (1-6): " trouble_choice

    case $trouble_choice in
        1)
            echo "Authentication Troubleshooting"
            echo "1. Verify your Claude.ai credentials"
            echo "2. Perform logout and login"
            echo "3. Switch to CURL provider"
            read -p "Enter your choice (1-3): " auth_trouble_choice
            case $auth_trouble_choice in
                1) echo "Please verify your Claude.ai credentials manually." ;;
                2)
                    claudesync auth logout
                    claudesync auth login
                    ;;
                3) claudesync auth login claude.ai-curl ;;
                *) echo "Invalid choice." ;;
            esac
            ;;
        2)
            echo "Synchronization Error Troubleshooting"
            echo "1. Check your internet connection"
            echo "2. Verify local directory permissions"
            echo "3. Check file size limits"
            read -p "Enter your choice (1-3): " sync_trouble_choice
            case $sync_trouble_choice in
                1) echo "Please check your internet connection manually." ;;
                2) echo "Please verify your local directory permissions manually." ;;
                3) 
                    current_size=$(claudesync config get max_file_size)
                    echo "Current max file size: $current_size bytes"
                    read -p "Enter new max file size in bytes (or press Enter to keep current): " new_size
                    if [ ! -z "$new_size" ]; then
                        claudesync config set max_file_size $new_size
                    fi
                    ;;
                *) echo "Invalid choice." ;;
            esac
            ;;
        3)
            echo "Performance Issue Troubleshooting"
            echo "1. Adjust upload delay"
            echo "2. Implement .claudeignore file"
            read -p "Enter your choice (1-2): " perf_trouble_choice
            case $perf_trouble_choice in
                1)
                    read -p "Enter new upload delay in seconds: " new_delay
                    claudesync config set upload_delay $new_delay
                    ;;
                2)
                    if [ ! -f ".claudeignore" ]; then
                        echo "Creating .claudeignore file..."
                        echo "# Add patterns to ignore here" > .claudeignore
                    fi
                    echo "Please edit .claudeignore file to exclude unnecessary files."
                    ;;
                *) echo "Invalid choice." ;;
            esac
            ;;
        4)
            echo "Windows-Specific Issue Troubleshooting"
            echo "1. Enable file input for cURL"
            echo "2. Adjust maximum file size"
            read -p "Enter your choice (1-2): " win_trouble_choice
            case $win_trouble_choice in
                1) claudesync config set curl_use_file_input True ;;
                2)
                    read -p "Enter new max file size in bytes: " new_size
                    claudesync config set max_file_size $new_size
                    ;;
                *) echo "Invalid choice." ;;
            esac
            ;;
        5)
            claudesync config set log_level DEBUG
            echo "Detailed logging enabled."
            ;;
        6)
            claudesync logs
            ;;
        *) echo "Invalid choice." ;;
    esac
}

# Function to set up the 'claude' alias
setup_alias() {
    echo "Setting up or updating 'claude' alias/function for bash, zsh, and fish..."

    script_path="$PWD/$(basename $0)"
    
    # Setup for bash
    bash_config="$HOME/.bashrc"
    bash_alias="alias claude='$script_path'"
    if grep -q "alias claude=" "$bash_config"; then
        sed -i "s|alias claude=.*|$bash_alias|" "$bash_config"
        echo "Bash alias updated in $bash_config"
    else
        echo "$bash_alias" >> "$bash_config"
        echo "Bash alias added to $bash_config"
    fi

    # Setup for zsh
    zsh_config="$HOME/.zshrc"
    zsh_alias="alias claude='$script_path'"
    if grep -q "alias claude=" "$zsh_config"; then
        sed -i "s|alias claude=.*|$bash_alias|" "$zsh_config"
        echo "Zsh alias updated in $zsh_config"
    else
        echo "$zsh_alias" >> "$zsh_config"
        echo "Zsh alias added to $zsh_config"
    fi

    # Setup for fish
    fish_config="$HOME/.config/fish/config.fish"
    fish_function="function claude; $script_path \$argv; end"
    mkdir -p "$(dirname "$fish_config")"
    if grep -q "function claude" "$fish_config"; then
        sed -i "s|function claude.*|$fish_function|" "$fish_config"
        echo "Fish function updated in $fish_config"
    else
        echo "$fish_function" >> "$fish_config"
        echo "Fish function added to $fish_config"
    fi

    echo "Alias/function 'claude' has been set up or updated for bash, zsh, and fish."
    echo "To use it in your current session, please run:"
    echo "  For bash: source ~/.bashrc"
    echo "  For zsh:  source ~/.zshrc"
    echo "  For fish: source ~/.config/fish/config.fish"
    echo "Or restart your terminal."
}

cleanup_claude() {
    echo "This will remove all Claude-related files and directories in the current directory."
    read -p "Are you sure you want to proceed? (y/n): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        echo "Removing Claude-related files and directories..."
        rm -rf .claudesync
        rm -rf venv
        rm -f .claudeignore
        echo "Cleanup completed."
    else
        echo "Cleanup cancelled."
    fi
}

# Function to activate virtual environment
activate_venv() {
    if [ -d "venv" ] && [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    else
        echo "Virtual environment not found. Please run Setup Claude first."
        return 1
    fi
}

# Main execution
while true; do
    echo "ClaudeSync Management Script"
    echo "1. Setup Claude in current directory"
    echo "2. Sync Files"
    echo "3. Configure ClaudeSync"
    echo "4. Set Up File Categories"
    echo "5. Manage Authentication"
    echo "6. Manage Organization and Project"
    echo "7. Set Up Scheduled Sync"
    echo "8. Disable Scheduled Sync"
    echo "9. List Chats"
    echo "10. Create New Chat"
    echo "11. Troubleshoot ClaudeSync"
    echo "12. Set up 'claude' alias"
    echo "13. Clean up Claude files"
    echo "14. Exit"

    read -p "Enter your choice (1-14): " choice

    case $choice in
        1) setup_claude ;;
        2) 
            if activate_venv; then
                claudesync push
                deactivate
            fi
            ;;
        3) 
            if activate_venv; then
                configure_claudesync
                deactivate
            fi
            ;;
        4) 
            if activate_venv; then
                setup_file_categories
                deactivate
            fi
            ;;
        5) 
            if activate_venv; then
                manage_auth
                deactivate
            fi
            ;;
        6) 
            if activate_venv; then
                manage_org_project
                deactivate
            fi
            ;;
        7) 
            if activate_venv; then
                setup_scheduled_sync
                deactivate
            fi
            ;;
        8) 
            if activate_venv; then
                disable_scheduled_sync
                deactivate
            fi
            ;;
        9) 
            if activate_venv; then
                claudesync chat ls
                deactivate
            fi
            ;;
        10) 
            if activate_venv; then
                read -p "Enter chat name: " chat_name
                claudesync chat init --name "$chat_name"
                deactivate
            fi
            ;;
        11) troubleshoot_claudesync ;;
        12) setup_alias ;;
        13) cleanup_claude ; break ;;
        14) echo "Exiting." ; break ;;
        *) echo "Invalid choice. Please try again." ;;
    esac

    echo ""
    read -p "Press Enter to continue..."
    clear
done

echo "Thank you for using ClaudeSync Manager."