#!/bin/bash

# ==========================================================
# Network Tools Module
# Provides common network diagnostic commands
# ==========================================================

network_ping_host() {
    show_title "NETWORK TOOLS - PING HOST"

    local host
    host="$(safe_path_input "Enter host/IP to ping [default: google.com]: ")"

    if [ -z "$host" ]; then
        host="google.com"
    fi

    echo "Pinging $host..."
    print_line
    ping -c 4 "$host"

    pause_screen
}

network_show_ip() {
    show_title "NETWORK TOOLS - SHOW IP INFORMATION"

    echo "Hostname: $(hostname)"
    print_line

    if command_exists ifconfig; then
        ifconfig | grep -E "^[a-zA-Z0-9]|inet "
    elif command_exists ip; then
        ip addr
    else
        echo "No IP information command found."
    fi

    pause_screen
}

network_dns_lookup() {
    show_title "NETWORK TOOLS - DNS LOOKUP"

    local domain
    domain="$(safe_path_input "Enter domain name: ")"

    if [ -z "$domain" ]; then
        echo "Domain cannot be empty."
        pause_screen
        return
    fi

    print_line

    if command_exists dig; then
        dig "$domain"
    elif command_exists nslookup; then
        nslookup "$domain"
    else
        echo "Neither dig nor nslookup is available."
    fi

    pause_screen
}

network_trace_route() {
    show_title "NETWORK TOOLS - TRACE ROUTE"

    local host
    host="$(safe_path_input "Enter host/IP [default: google.com]: ")"

    if [ -z "$host" ]; then
        host="google.com"
    fi

    print_line

    if command_exists traceroute; then
        traceroute "$host"
    elif command_exists tracepath; then
        tracepath "$host"
    else
        echo "No traceroute command available."
    fi

    pause_screen
}

network_check_port() {
    show_title "NETWORK TOOLS - CHECK PORT"

    local host
    local port

    host="$(safe_path_input "Enter host/IP: ")"
    port="$(safe_path_input "Enter port number: ")"

    if [ -z "$host" ] || [ -z "$port" ]; then
        echo "Host and port cannot be empty."
        pause_screen
        return
    fi

    print_line

    if command_exists nc; then
        nc -vz "$host" "$port"
    else
        echo "netcat/nc is not available on this system."
    fi

    pause_screen
}

network_check_website() {
    show_title "NETWORK TOOLS - CHECK WEBSITE RESPONSE"

    local url
    url="$(safe_path_input "Enter website URL [example: https://example.com]: ")"

    if [ -z "$url" ]; then
        echo "URL cannot be empty."
        pause_screen
        return
    fi

    print_line

    if command_exists curl; then
        curl -I "$url"
    else
        echo "curl is not available."
    fi

    pause_screen
}

network_menu() {
    while true; do
        show_title "NETWORK TOOLS MENU"
        echo "1. Ping a host"
        echo "2. Show IP information"
        echo "3. DNS lookup"
        echo "4. Trace route"
        echo "5. Check open port"
        echo "6. Check website response"
        echo "7. Back to main menu"
        print_line

        choice="$(read_choice "Enter your choice: ")"

        case "$choice" in
            1) network_ping_host ;;
            2) network_show_ip ;;
            3) network_dns_lookup ;;
            4) network_trace_route ;;
            5) network_check_port ;;
            6) network_check_website ;;
            7) break ;;
            *) echo "Invalid choice."; sleep 1 ;;
        esac
    done
}