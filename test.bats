#!./test/libs/bats/bin/bats

@test "Test if applications are installed" {
    command -v dropbox
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
    command -v fuse-exfat
    command -v bats
}
@test "Check if pyenv has installed successfully" {
    command -v pyenv
}
