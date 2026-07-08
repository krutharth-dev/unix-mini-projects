# ASCII Art File Converter

A Unix shell scripting project that generates ASCII art banners and fun terminal messages using tools such as `figlet` and `cowsay`.

The script also includes built-in fallback formatting, so it can still run even if `figlet` or `cowsay` are not installed.

## Features

- Generate ASCII banners from user input
- Generate cowsay-style terminal messages
- Convert a text file into multiple ASCII banners
- Save generated banners into output files
- View saved output files
- Preview output files from the terminal
- Check whether `figlet` and `cowsay` are installed
- Uses a menu-driven interface

## Project Structure

```text
05-ascii-art-file-converter/
├── ascii_converter.sh
├── config/
│   └── ascii_art.conf
├── outputs/
│   └── .gitkeep
├── sample_inputs/
│   └── messages.txt
├── README.md
└── .gitignore
```

## Optional Tools

This project can use:

- `figlet`
- `cowsay`

On macOS with Homebrew, install them using:

```bash
brew install figlet cowsay
```

The project still works without them by using fallback ASCII formatting.

## How to Run

Give permission to the script:

```bash
chmod +x ascii_converter.sh
```

Run the script:

```bash
./ascii_converter.sh
```

## Menu Options

```text
1. Generate ASCII banner from text
2. Generate cowsay-style message
3. Convert text file to ASCII banners
4. Save custom banner to file
5. View saved output files
6. Preview an output file
7. Check figlet/cowsay installation
8. Exit
```

## Sample Input File

The project includes:

```text
sample_inputs/messages.txt
```

This file can be used to test the file conversion option.

## Purpose

This project demonstrates:

- Unix shell scripting
- Menu-driven programming
- File input and output
- External command usage
- Tool availability checks
- Fallback logic
- Basic terminal-based creativity
