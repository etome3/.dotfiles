#!/bin/zsh

# This script launches a small Kitty terminal running the Gemini CLI.
# It is designed to be used with a Hyprland window rule for positioning.

# Target directories
QWEN_DIR="$HOME/Documents/Answers"

# Python helper script for key management
KEY_MANAGER_SCRIPT="$(dirname "$0")/key_manager.py"

# The command to run inside the terminal.
# Define function and run interactive menu, then exit after completion.
COMMAND_TO_RUN="

interactive_menu() {
    echo 'Select a command:'
    echo '  [q] Qwen (OpenAI-powered) - Uses $QWEN_DIR'
    echo '  [g] Gemini (Google-powered) - Uses zoxide to find directory'
    echo -n 'Your choice: '
    
    read -k 1 choice
    echo
    
    case \$choice in
        q|Q)
            echo 'Enter your query for Qwen:'
            read -r query
            if [[ -n \"\$query\" ]]; then
                mkdir -p '$QWEN_DIR'
                cd '$QWEN_DIR'
                # Use Python script to handle key rotation and .env creation
                python3 '$KEY_MANAGER_SCRIPT' '$QWEN_DIR'
                echo \"\$query\" | qwen -y -p
                # Clean up temporary .env file
                rm -f .env
            else
                echo 'No query provided.'
            fi
            ;;
        g|G)
            echo 'Enter directory search pattern for Gemini (e.g., \"anci 3\" for Ancient History Term 3):'
            read -r dir_pattern
            if [[ -n \"\$dir_pattern\" ]]; then
                target_dir=\$(zoxide query \$dir_pattern 2>/dev/null)
                if [[ -n \"\$target_dir\" && -d \"\$target_dir\" ]]; then
                    echo \"Found directory: \$target_dir\"
                    cd \"\$target_dir\"
                    echo 'Enter your query for Gemini:'
                    read -r query
                    if [[ -n \"\$query\" ]]; then
                        echo \"\$query\" | gemini --approval-mode auto_edit -a --prompt-interactive
                    else
                        echo 'No query provided.'
                    fi
                else
                    echo 'Directory not found with pattern: '\$dir_pattern
                    echo 'Available directories:'
                    zoxide query --list | head -10
                fi
            else
                echo 'No directory pattern provided.'
            fi
            ;;
        *)
            echo 'Invalid choice. Please select q for Qwen or g for Gemini.'
            ;;
    esac
}
interactive_menu; zsh"

# Launch Kitty with a specific class. The size is set here, but positioning
# should be handled by a Hyprland window rule for best results.
# Note: 50x50 pixels is very small. You can adjust the width and height below.
# A more usable size might be 400px by 300px.
kitty --class "gemini-popup" \
      -o initial_window_width=5 \
      -o initial_window_height=5 \
      -e zsh
