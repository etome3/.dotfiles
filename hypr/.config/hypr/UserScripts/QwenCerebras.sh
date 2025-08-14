
# SecretTerminal variables for Cerebras
export CEREBRAS_API_KEY_1="csk-285jhhpw88wvee5krk3phf9rdcccyxd8mrrcpjnx8jm5ncej"
export CEREBRAS_API_KEY_2="csk-9rm3tv25m9xhxw2xjj64wx5vcyxfwktnck8hhpj944d5kfye"
export CEREBRAS_API_KEY_3="csk-kh452w9pjxh62nmxp3njxfymvryjrkrn5jr9hf28jwp5m685"

# Function to rotate through API keys (1, 2, 3, 1, ...) and return the VALUE
get_rotating_key_value() {
    # Define the path to the file that will store our state (the last used number)
    local state_file="$HOME/projects/.cerebras_key_rotator_state"
    local num_keys=3 # The total number of keys to rotate through

    # Read the last used index. Default to 0 if the file doesn't exist or is empty.
    local last_index=0
    if [[ -f "$state_file" ]]; then
        # Read the file and ensure it's a number, otherwise default to 0
        local content=$(<"$state_file")
        [[ "$content" =~ ^[0-9]+$ ]] && last_index=$content
    fi

    # Calculate the current index by rotating.
    # The formula (last_index % num_keys) + 1 does this perfectly:
    # (0 % 3) + 1 = 1
    # (1 % 3) + 1 = 2
    # (2 % 3) + 1 = 3
    # (3 % 3) + 1 = 1  <-- a full rotation
    local current_index=$(( (last_index % num_keys) + 1 ))

    # Construct the name of the environment variable
    local key_name="CEREBRAS_API_KEY_${current_index}"

    # Use eval to get the *value* of the variable.
    # IMPORTANT: The function will now output the key's value to standard out.
    eval echo "\$$key_name"

    # Save the current index to the state file for the next run.
    # The > operator will create the file if it doesn't exist or overwrite it if it does.
    echo "$current_index" > "$state_file"
}

Qwen_CLI_with_rotating_key() {
    cd $HOME/Documents/Answers
    OPENAI_API_KEY=$(get_rotating_key_value) \
    OPENAI_BASE_URL="https://api.cerebras.ai/v1" \
    OPENAI_MODEL="gpt-oss-120b" \
    qwen -y
}

Gemini_CLI_with_zoxide_search() {
    # Use zoxide query with all function arguments ("$@") to find the target directory.
    # The result is stored in the 'target_dir' variable.
    local target_dir
    target_dir=$(zoxide query "$@")

    # Check if zoxide successfully found a directory.
    if [ -d "$target_dir" ]; then
        # If found, change to that directory and print a confirmation.
        cd "$target_dir" && echo "Changed directory to: $(pwd)"
        
        # Now, run the gemini command in the new directory.
        gemini -a --approval-mode auto_edit
    else
        # If zoxide couldn't find a match, print an error and do nothing.
        echo "zoxide could not find a match for: $@" >&2
        return 1 # Return a non-zero status to indicate failure
    fi
}