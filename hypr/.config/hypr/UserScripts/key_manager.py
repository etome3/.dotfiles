#!/usr/bin/env python3
"""
API Key rotation manager for gemini-kitty.sh
Handles key rotation and .env file creation
"""

import os
import sys
from pathlib import Path

# Configuration
API_KEYS = [
    "csk-285jhhpw88wvee5krk3phf9rdcccyxd8mrrcpjnx8jm5ncej",
    "csk-9rm3tv25m9xhxw2xjj64wx5vcyxfwktnck8hhpj944d5kfye",
    "csk-kh452w9pjxh62nmxp3njxfymvryjrkrn5jr9hf28jwp5m685",
    # Add more API keys here as needed
]

BASE_URL = "https://api.cerebras.ai/v1"
MODEL = "gpt-oss-120b"
INDEX_FILE = Path.home() / ".gemini-kitty-key-index"

def get_next_api_key():
    """Get the next API key in rotation and update the index."""
    # Read current index, default to 0
    current_index = 0
    if INDEX_FILE.exists():
        try:
            current_index = int(INDEX_FILE.read_text().strip())
        except (ValueError, FileNotFoundError):
            current_index = 0
    
    # Ensure index is within bounds
    current_index = current_index % len(API_KEYS)
    
    # Get current key
    selected_key = API_KEYS[current_index]
    
    # Update index for next time
    next_index = (current_index + 1) % len(API_KEYS)
    INDEX_FILE.write_text(str(next_index))
    
    return selected_key

def create_env_file(directory, api_key):
    """Create .env file in the specified directory."""
    env_path = Path(directory) / ".env"
    
    env_content = f"""OPENAI_API_KEY={api_key}
OPENAI_BASE_URL={BASE_URL}
OPENAI_MODEL={MODEL}
"""
    
    env_path.write_text(env_content)
    return env_path

def main():
    if len(sys.argv) < 2:
        print("Usage: key_manager.py <directory>", file=sys.stderr)
        sys.exit(1)
    
    directory = sys.argv[1]
    
    # Get next API key
    api_key = get_next_api_key()
    
    # Create .env file
    env_path = create_env_file(directory, api_key)
    
    # Print info (for shell script to capture)
    print(f"Using API key: {api_key[:20]}...")
    print(f"Created .env file: {env_path}")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())