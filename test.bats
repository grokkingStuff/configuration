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
}
