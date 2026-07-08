#!/bin/bash

# ==========================================================
# ASCII Art File Converter
# Creates ASCII banners and fun terminal messages using
# figlet, cowsay, or built-in fallback formatting.
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/ascii_art.conf"
OUTPUT_DIR="$SCRIPT_DIR/outputs"
SAMPLE_DIR="$SCRIPT_DIR/sample_inputs"

mkdir -p "$OUTPUT_DIR"

DEFAULT_STYLE="standard"
DEFAULT_OUTPUT_FILE="$OUTPUT_DIR/ascii_output_$(date '+%Y%m%d_%H%M%S').txt"

if [ -f "$CONFIG_FILE" ]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
fi

pause_screen() {
    echo
    read -r -p "Press Enter to continue..."
}

print_line() {
    echo "------------------------------------------------------------"
}

show_header() {
    clear
    echo "============================================================"
    echo "                 ASCII ART FILE CONVERTER                   "
    echo "============================================================"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

read_non_empty() {
    local prompt="$1"
    local value

    while true; do
        read -r -p "$prompt" value

        if [ -n "$value" ]; then
            echo "$value"
            return
        fi

        echo "Input cannot be empty."
    done
}

fallback_banner() {
    local text="$1"
    local length
    local border

    length=${#text}
    border=""

    for ((i = 0; i < length + 8; i++)); do
        border="${border}*"
    done

    echo "$border"
    echo "*** $text ***"
    echo "$border"
}

fallback_cowsay() {
    local message="$1"
    local length
    local border

    length=${#message}
    border=""

    for ((i = 0; i < length + 4; i++)); do
        border="${border}-"
    done

    echo " $border"
    echo "<  $message  >"
    echo " $border"
    echo "        \\   ^__^"
    echo "         \\  (oo)\\_______"
    echo "            (__)\\       )\\/\\"
    echo "                ||----w |"
    echo "                ||     ||"
}

generate_figlet_banner() {
    show_header
    echo "Generate ASCII Banner"
    print_line

    local text
    text="$(read_non_empty "Enter text for banner: ")"

    echo
    echo "Generated Banner:"
    print_line

    if command_exists figlet; then
        figlet -f "$DEFAULT_STYLE" "$text"
    else
        echo "figlet is not installed. Using fallback banner."
        echo
        fallback_banner "$text"
    fi

    pause_screen
}

generate_cowsay_message() {
    show_header
    echo "Generate Cowsay Message"
    print_line

    local message
    message="$(read_non_empty "Enter message: ")"

    echo
    echo "Generated Message:"
    print_line

    if command_exists cowsay; then
        cowsay "$message"
    else
        echo "cowsay is not installed. Using fallback cowsay."
        echo
        fallback_cowsay "$message"
    fi

    pause_screen
}

convert_text_file() {
    show_header
    echo "Convert Text File to ASCII Art"
    print_line

    local input_file
    local output_file

    read -r -p "Enter input text file path [default: sample_inputs/messages.txt]: " input_file

    if [ -z "$input_file" ]; then
        input_file="$SAMPLE_DIR/messages.txt"
    fi

    if [ ! -f "$input_file" ]; then
        echo "Error: Input file not found."
        pause_screen
        return
    fi

    read -r -p "Enter output file path [default: timestamped output file]: " output_file

    if [ -z "$output_file" ]; then
        output_file="$DEFAULT_OUTPUT_FILE"
    fi

    {
        echo "============================================================"
        echo "                  ASCII ART FILE OUTPUT"
        echo "============================================================"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Input file: $input_file"
        echo

        while IFS= read -r line || [ -n "$line" ]; do
            if [ -z "$line" ]; then
                continue
            fi

            echo "Original Text: $line"
            print_line

            if command_exists figlet; then
                figlet -f "$DEFAULT_STYLE" "$line"
            else
                fallback_banner "$line"
            fi

            echo
        done < "$input_file"
    } > "$output_file"

    echo "File converted successfully."
    echo "Output saved at:"
    echo "$output_file"

    pause_screen
}

save_banner_to_file() {
    show_header
    echo "Save Custom Banner to File"
    print_line

    local text
    local output_file

    text="$(read_non_empty "Enter text for banner: ")"

    read -r -p "Enter output file path [default: timestamped output file]: " output_file

    if [ -z "$output_file" ]; then
        output_file="$DEFAULT_OUTPUT_FILE"
    fi

    {
        echo "============================================================"
        echo "                    SAVED ASCII BANNER"
        echo "============================================================"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo

        if command_exists figlet; then
            figlet -f "$DEFAULT_STYLE" "$text"
        else
            fallback_banner "$text"
        fi
    } > "$output_file"

    echo "Banner saved successfully:"
    echo "$output_file"

    pause_screen
}

view_saved_outputs() {
    show_header
    echo "Saved ASCII Art Outputs"
    print_line

    if find "$OUTPUT_DIR" -type f ! -name ".gitkeep" | grep -q .; then
        find "$OUTPUT_DIR" -type f ! -name ".gitkeep" -print
    else
        echo "No saved output files found yet."
    fi

    pause_screen
}

preview_output_file() {
    show_header
    echo "Preview Output File"
    print_line

    local file_path
    read -r -p "Enter output file path to preview: " file_path

    if [ -z "$file_path" ]; then
        echo "File path cannot be empty."
        pause_screen
        return
    fi

    if [ ! -f "$file_path" ]; then
        echo "File not found."
        pause_screen
        return
    fi

    print_line
    cat "$file_path"

    pause_screen
}

check_tools() {
    show_header
    echo "Tool Availability Check"
    print_line

    if command_exists figlet; then
        echo "figlet: installed"
    else
        echo "figlet: not installed"
    fi

    if command_exists cowsay; then
        echo "cowsay: installed"
    else
        echo "cowsay: not installed"
    fi

    if command_exists brew; then
        echo
        echo "Homebrew detected."
        echo "To install the optional tools, run:"
        echo "brew install figlet cowsay"
    else
        echo
        echo "Homebrew not detected."
        echo "The script will still work using built-in fallback formatting."
    fi

    pause_screen
}

main_menu() {
    while true; do
        show_header
        echo "1. Generate ASCII banner from text"
        echo "2. Generate cowsay-style message"
        echo "3. Convert text file to ASCII banners"
        echo "4. Save custom banner to file"
        echo "5. View saved output files"
        echo "6. Preview an output file"
        echo "7. Check figlet/cowsay installation"
        echo "8. Exit"
        print_line

        read -r -p "Enter your choice: " choice

        case "$choice" in
            1)
                generate_figlet_banner
                ;;
            2)
                generate_cowsay_message
                ;;
            3)
                convert_text_file
                ;;
            4)
                save_banner_to_file
                ;;
            5)
                view_saved_outputs
                ;;
            6)
                preview_output_file
                ;;
            7)
                check_tools
                ;;
            8)
                clear
                echo "Thank you for using ASCII Art File Converter."
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter a number from 1 to 8."
                sleep 1
                ;;
        esac
    done
}

main_menu
