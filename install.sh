#! /bin/sh

# Place variables and paths in .bashrc
FILE="~/.bashrc"
/bin/cat <<EOM >$FILE
export PATH="/usr/local/var/pyenv/bin/:$PATH"

export WORKON_HOME=~/.ve
export PROJECT_HOME=~/Projects
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PYENV_ROOT=/usr/local/var/pyenv
EOM

source ~/.bashrc


# Install packages
echo "
fish
bash
zsh
chromium
firefox
tor
emacs
git
vlc
vocal
htop
dropbox 
" | xargs sudo zypper install --no-confirm --auto-agree-with-licenses --recommends --download-as-needed


# Create organization
dropbox start
if [ -d "~/Dropbox" ]; then
    dropbox start
    dropbox status

    echo "Hi!"

    touch ~/Dropbox/Projects
    ln ~/Dropbox/Projects ~/Projects
    touch ~/Dropbox/Agenda
    ln ~/Dropbox/Agenda ~/Agenda
    touch ~/Dropbox/Documents
    ln ~/Dropbox/Documents ~/Documents
    touch ~/Dropbox/Configuration
    ln ~/Dropbox/Configuration ~/Configuration
    touch ~/Dropbox/Archive
    ln ~/Dropbox/Archive ~/Archive
    touch ~/Dropbox/Website
    ln ~/Dropbox/Website ~/Website
    touch ~/Dropbox/Learning
    ln ~/Dropbox/Learning ~/Learning
    touch ~/Dropbox/Medical
    ln ~/Dropbox/Medical ~/Medical
    touch ~/Dropbox/AssetManagement
    ln ~/Dropbox/AssetManagement ~/AssetManagement
    touch ~/Dropbox/Business
    ln ~/Dropbox/Business ~/Business
    touch ~/Dropbox/Photos
    ln ~/Dropbox/Photos ~/Photos

    touch ~/Dropbox/organizer.org
    ln ~/Dropbox/organizer.org ~/organizer.org
    # Place in Agenda for org-agenda
    mkdir -p ~/Dropbox/Agenda
    ln ~/Dropbox/organizer.org ~/Dropbox/Agenda/organizer.org
    touch ~/Dropbox/refile.org
    ln ~/Dropbox/refile.org ~/refile.org
    # Place in Agenda for org-agenda
    mkdir -p ~/Dropbox/Agenda
    ln ~/Dropbox/refile.org ~/Dropbox/Agenda/refile.org
    touch ~/Dropbox/meeting.org
    ln ~/Dropbox/meeting.org ~/meeting.org
    # Place in Agenda for org-agenda
    mkdir -p ~/Dropbox/Agenda
    ln ~/Dropbox/meeting.org ~/Dropbox/Agenda/meeting.org
    touch ~/Dropbox/calendar.org
    ln ~/Dropbox/calendar.org ~/calendar.org
    mkdir -p ~/Dropbox/Agenda
    ln ~/Dropbox/calendar.org ~/Dropbox/Agenda/calendar.org
fi

# Install python development environment
# curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash && \
#     source ~/.bashrc && \
#     pyenv update
# 
# 
# if command pyenv 2>/dev/null; then
#     curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
#     # pyenv-virtualenv
#     # All virtualenvs will be on...
#     # export WORKON_HOME=~/.ve
#     mkdir -p ~/.ve 
#     
#     # All projects will be on...
#     # export PROJECT_HOME=~/Projects
#     mkdir -p ~/Projects 
#     pyenv install 3.6.0
#     pyenv install 2.7.13
#     pyenv virtualenv 3.6.0 jupyter3
#     pyenv virtualenv 3.6.0 tools3
#     pyenv virtualenv 2.7.13 ipython2
#     pyenv virtualenv 2.7.13 tools2
#     pyenv activate jupyter3
#     pip install jupyter
#     python -m ipykernel install --user
#     pyenv deactivate
#     pyenv activate ipython2
#     pip install ipykernel
#     python -m ipykernel install --user
#     pyenv deactivate
#     pyenv activate tools3
#     pip install youtube-dl gnucash-to-beancount rows 
#     pyenv deactivate
#     pyenv activate tools2
#     pip install rename s3cmd fabric mercurial
#     pyenv deactivate
#     pyenv global 3.6.0 2.7.13 jupyter3 ipython2 tools3 tools2
#     ipython profile create
#     curl -L http://hbn.link/hb-ipython-startup-script > ~/.ipython/profile_default/startup/00-venv-sitepackages.py
# fi
