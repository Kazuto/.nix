#!/bin/bash

function icon_map() {
  case "$1" in
  "Alacritty" | "Hyper" | "iTerm2" | "kitty" | "Terminal" | "终端" | "WezTerm" | "Ghostty")
    icon_result=":terminal:"
    ;;
  "App Store")
    icon_result=":app_store:"
    ;;
  "Bruno")
    icon_result=":bruno:"
    ;;
  "Chromium" | "Google Chrome" | "Google Chrome Canary" | "Thorium")
    icon_result=":google_chrome:"
    ;;
  "Default")
    icon_result=":default:"
    ;;
  "Discord" | "Discord Canary" | "Discord PTB")
    icon_result=":discord:"
    ;;
  "Docker" | "Docker Desktop")
    icon_result=":docker:"
    ;;
  "Finder")
    icon_result=":finder:"
    ;;
  "Firefox")
    icon_result=":firefox:"
    ;;
  "Mail" | "Mailspring")
    icon_result=":mail:"
    ;;
  "Microsoft Teams")
    icon_result=":microsoft_teams:"
    ;;
  "Neovide" | "MacVim" | "Vim" | "VimR")
    icon_result=":vim:"
    ;;
  "Obsidian")
    icon_result=":obsidian:"
    ;;
  "Safari")
    icon_result=":safari:"
    ;;
  "Spotify")
    icon_result=":spotify:"
    ;;
  "System Preferences" | "System Settings")
    icon_result=":gear:"
    ;;
  "TablePlus" )
    icon_result=":tableplus:"
    ;;
  "Telegram")
    icon_result=":telegram:"
    ;;
  "VLC")
    icon_result=":vlc:"
    ;;
  "WhatsApp")
    icon_result=":whats_app:"
    ;;
  *)
    icon_result=":default:"
    ;;
  esac
}

icon_map "$1"

echo "$icon_result"
