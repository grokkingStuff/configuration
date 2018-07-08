#!/usr/bin/env bats

@test "Test if applications are installed" {
    command -v fish
    command -v bash
    command -v zsh
    command -v chromium
    command -v firefox
    command -v tor
    command -v emacs
    command -v git
    command -v vlc
    command -v htop
    command -v dropbox
    command -v bats
}
@test "Test if the Projects folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/Projects ]
 [ -d ~/Projects ]
}
@test "Test if the Agenda folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/Agenda ]
}
@test "Test if the Documents folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/Documents ]
 [ -d ~/Documents ]
}
@test "Test if the Configuration folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/Configuration ]
 [ -d ~/Configuration ]
}
@test "Test if the Archive folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/Archive ]
 [ -d ~/Archive ]
}
@test "Test if the Website folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/Website ]
 [ -d ~/Website ]
}
@test "Test if the Learning folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/Learning ]
 [ -d ~/Learning ]
}
@test "Test if the Medical folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/Medical ]
 [ -d ~/Medical ]
}
@test "Test if the AssetManagement folder exists in the Dropbox folder and in the home directory" {
 [ -d ~/Dropbox/AssetManagement ]
 [ -d ~/AssetManagement ]
}
@test "Check if pyenv has installed successfully" {
    command -v pyenv
}
