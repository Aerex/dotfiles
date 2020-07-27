#!/bin/sh

fancy_echo_line "Dock - Automatically hide and show"
defaults write com.apple.dock autohide -bool true

fancy_echo_line "Dock - Remove the auto-hiding delay"
defaults write com.apple.Dock autohide-delay -float 0

fancy_echo_line "Dock - Don’t show Dashboard as a Space"
defaults write com.apple.dock "dashboard-in-overlay" -bool true
