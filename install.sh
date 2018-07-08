#!/usr/bin/env bash
   ## Description: Connects to remote server and relays local changes made in git repo and opens a shell in remote server.


                     ################################################
                     #                                              #
                     #              Author Information              #
                     #                                              #
                     # Author: Vishakh Pradeep Kumar                #
                     # Email: grokkingStuff@gmail.com on 04-2018    #
                     # Current maintainer: Vishakh Pradeep Kumar    #
                     ################################################


   #####################################################################################
   #                                                                                   #
   #                                License Information                                #
   #                                                                                   #
   # License: GPLv2, see http://www.fsf.org/licensing/licenses/info/GPLv2.html         #
   # and accompanying license "LICENSE.txt". Redistribution + modification under this  #
   # license permitted.                                                                #
   # If you enclose this script or parts of it in your software, it has to             #
   # be accompanied by the same license (see link) and the place where to get          #
   # the recent version of this program: https://testssl.sh                            #
   # Don't violate the license.                                                        #
   #                                                                                   #
   # USAGE WITHOUT ANY WARRANTY, THE SOFTWARE IS PROVIDED "AS IS". USE IT AT           #
   # your OWN RISK                                                                     #
   #####################################################################################

   
   
   # SYSTEEM LIBRARY
   
   ########################################################
   # Displays a list of all flags with their descriptions
   # Globals:
   #   None
   # Arguments:
   #   None
   # Returns:
   #   None
   ########################################################
   function system::usage() {
       echo "$0 usage:" &&              \
         grep "[[:space:]].)\\ ##" "$0" |  \         # Find all line in script that have '##' after a ')'
         sed 's/##//' |                 \         # Replace all '##' with nothing
         sed -r 's/([a-z])\)/-\1/';              # TODO Can't remember
   }
   #################################################################
   # Detects the operating system that this script is being run on
   # Globals:
   #   OSTYPE
   # Arguments:
   #   None
   # Returns:
   #   MACHINE
   #################################################################
   function system::detect_operating_system() {
   
       local MACHINE
       MACHINE=""
   
       case "$OSTYPE" in
   
       #########################################################################
       # *nix systems                                                          #
       #########################################################################
           solaris*)
               MACHINE="SOLARIS"                                                     # Do people even use Solaris anymore? Gosh, haven't heard this name in a while.
               ;;
           darwin*)
               MACHINE="OSX"
               ;;
           linux*)
               MACHINE="LINUX"
               ;;
           bsd*)
               MACHINE="BSD"
               ;;
       #    aix*)
       #        MACHINE="AIX"
       #        ;;
       #    #Was gonna add AIX but I dunno if it has the $OSTYPE variable and I don't really care.
   
   
       #########################################################################
       # windows systems                                                       #
       #########################################################################
           cygwin*)
               MACHINE="WINDOWS"
               ;&                                                                    # Since Windows has two options for $OSTYPE, we're gonna let it cascade into the next case
           msys*)
               MACHINE="WINDOWS"
   
                                                                                     # We're using uname -s to figure out which shell in Windows we're using.
               unameOut="$(uname -s)"
               case "${unameOut}" in
                   CYGWIN*)
                       MACHINE="WINDOWS-CYGWIN"
                       # This should work for git shell as well.
                       # I'm not sure why you're using git-shell to do anything except run git commands but cool. You do you, mate.
                       ;;
                   MINGW32_NT*)
                       MACHINE="WINDOWS-32"
                       ;;
                   MINGW64_NT*)
                       MACHINE="WINDOWS-64"
                       ;;
                   Linux*)
                       MACHINE="WINDOWS-POWERSHELL"
                       # Not sure why Powershell returns Linux when uname-s is passed to it. Seems janky.
                       echo "This script will not run in Powershell. Please install a bash shell."
                       echo "Terminating program."
                       exit 1
   
               esac
               ;;
   
       #########################################################################
       # This shouldn't happen but I'm super interested if it does!            #
       #########################################################################
           *)
               MACHINE="unknown: $OSTYPE"
               echo "I don't know what you're running but I'm interested! Send me an email at grokkingStuff@gmail.com"
               echo "I'm guessing you're running some sort of custom unix machine so as long as you have access to bash, you should be good."
               echo "I mean, seriously, what are you running! Is it a really old system and if so, can you send me pics? pretty please!"
               echo "If you do have issues, do send me a email but I can't promise I can make it work on your system."
               ;;
       esac
   
       # Time to return the answer
       return "$MACHINE"
   }
   ###########################################################
   # Allows for user to send time-tagged strings into STDERR
   # Globals:
   #   None
   # Arguments:
   #   Array of String(s)
   # Returns:
   #   None
   ###########################################################
   function system::err() {
     echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
   }
   #####################################################################################
   # Checks if the list of commands given to it is executable and available on a system
   # Globals:
   #   None
   # Arguments:
   #
   # Returns:
   #   None
   #####################################################################################
   function system::check_required_programs() {
     for p in "${@}"; do
       hash "${p}" 2>&- || \
           { system::err "Required program \"${p}\" not installed or in search PATH.";
             exit 1;
           }
     done
   }
   ###########################################################################################
   ## Checks if current folder is a VCS and if so, finds the location of the root repository.
   ## Globals:
   ##   None
   ## Arguments:
   ##   None
   ## Returns
   ##   VCS_REPO_ROOT as String
   ###########################################################################################
   #function system::vcs_repo_root() {
   #
   #  local VCS_REPO_ROOT;
   #  VCS_REPO_ROOT="";
   #
   #  # Check if repository is a git repo
   #  if git rev-parse --is-inside-work-tree 2> /dev/null; then
   #    # This is a valid git repository.
   #    VCS_REPO_ROOT="$(git rev-parse --show-toplevel)";
   #
   #  elif hg --cwd ./ root 2> /dev/null; then
   #    # This is a valid mercurial repository.
   #    VCS_REPO_ROOT="$(hg root)";
   #
   #  elif svn ls ./ > /dev/null; then
   #    # This is a valid svn repository.
   #    VCS_REPO_ROOT="$(svn info --show-item wc-root)";
   #  fi
   #
   #  if [[ -z VCS_REPO_ROOT ]]; then
   #    echo $VCS_REPO_ROOT;
   #  else
   #    system:err "Current directory is not within a vcs repository.";
   #  fi 
   #}
   #################################################
   ## Initialise colour variables and text options
   ## Global: 
   ##   None
   ## Arguments:
   ##   None:
   ## Returns:
   ##   None
   #################################################
   #function colour_init() {
   #    if [[ -z ${no_colour-} ]]; then
   #
   #        readonly reset_color="$(tput sgr0 2> /dev/null || true)"
   #        # Text attributes
   #        readonly ta_bold="$(tput bold 2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly ta_uscore="$(tput smul 2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly ta_blink="$(tput blink 2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly ta_reverse="$(tput rev 2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly ta_conceal="$(tput invis 2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #
   #        # Foreground codes
   #        readonly fg_black="$(tput setaf 0     2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly fg_blue="$(tput setaf 4      2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly fg_cyan="$(tput setaf 6      2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly fg_green="$(tput setaf 2     2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly fg_magenta="$(tput setaf 5   2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly fg_red="$(tput setaf 1       2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly fg_white="$(tput setaf 7     2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly fg_yellow="$(tput setaf 3    2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #
   #        # Background codes
   #        readonly bg_black="$(tput setab 0     2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly bg_blue="$(tput setab 4      2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly bg_cyan="$(tput setab 6      2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly bg_green="$(tput setab 2     2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly bg_magenta="$(tput setab 5   2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly bg_red="$(tput setab 1       2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly bg_white="$(tput setab 7     2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #        readonly bg_yellow="$(tput setab 3    2> /dev/null || true)"
   #        printf '%b' "$ta_none"
   #    else
   #        readonly reset_color=''
   #        # Text attributes
   #        readonly ta_bold=''
   #        readonly ta_uscore=''
   #        readonly ta_blink=''
   #        readonly ta_reverse=''
   #        readonly ta_conceal=''
   #        
   #        # Foreground codes
   #        readonly fg_black=''
   #        readonly fg_blue=''
   #        readonly fg_cyan=''
   #        readonly fg_green=''
   #        readonly fg_magenta=''
   #        readonly fg_red=''
   #        readonly fg_white=''
   #        readonly fg_yellow=''
   #        
   #        # Background codes
   #        readonly bg_black=''
   #        readonly bg_blue=''
   #        readonly bg_cyan=''
   #        readonly bg_green=''
   #        readonly bg_magenta=''
   #        readonly bg_red=''
   #        readonly bg_white=''
   #        readonly bg_yellow=''
   #    fi
   #}
   ######################################################
   # Makes echo POSIX-compliant while retaining options
   # Globals:
   #   None
   # Arguments:
   #   None
   # Returns:
   #   None
   ######################################################
   function system::echo () (
   fmt=%s end=\\n IFS=" "
   
   while [ $# -gt 1 ] ; do
   case "$1" in
   [!-]*|-*[!ne]*) break ;;
   *ne*|*en*) fmt=%b end= ;;
   *n*) end= ;;
   *e*) fmt=%b ;;
   esac
   shift
   done
   
   printf "%s%s%s" "$fmt" "$end" "$*"
   )
   
   function ok() {
       echo -e "[ok] " "$1"
   }
   
   function bot() {
       echo -e "\\[._.]/ - " "$1"
   }
   
   function running() {
       echo -en "\\u21d2" "$1" ": "
   }
   
   function action() {
       echo -en "\\u21d2 $1..."
   }
   
   function warn() {
       echo -e "[warning]" "$1"
   }
   
   function error() {
       echo -e "[error] " "$1"
   }
   

   # MAIN CONTROL FLOW
   function main() {

   #

#####################################################################################################
   bot "Installing Applications!"
   echo "\
   libnotify-tools
   vocal
   readline-devel sqlite3-devel libbz2-devel zlib-devel libopenssl-devel
   python3-virtualenv
   fish
   bash
   zsh
   chromium
   firefox
   tor
   emacs
   git
   vlc
   htop
   dropbox
   bats" > install.txt
   
   cat install.txt | while read line; do action "Installing $line"; sudo zypper -iq --gpg-auto-import-keys --no-refresh in -y $line; done
   
   rm install.txt
   
   echo "\n\n"
   bot "Installed applications!"

   bot "Creating Organization!"
   if [ -d "~/Dropbox" ]; then
       dropbox start
       dropbox status
   
       #touch ~/Dropbox/Projects
       #ln ~/Dropbox/Projects ~/Projects
       #touch ~/Dropbox/Agenda
       #touch ~/Dropbox/Documents
       #ln ~/Dropbox/Documents ~/Documents
       #touch ~/Dropbox/Configuration
       #ln ~/Dropbox/Configuration ~/Configuration
       #touch ~/Dropbox/Archive
       #ln ~/Dropbox/Archive ~/Archive
       #touch ~/Dropbox/Website
       #ln ~/Dropbox/Website ~/Website
       #touch ~/Dropbox/Learning
       #ln ~/Dropbox/Learning ~/Learning
       #touch ~/Dropbox/Medical
       #ln ~/Dropbox/Medical ~/Medical
       #touch ~/Dropbox/AssetManagement
       #ln ~/Dropbox/AssetManagement ~/AssetManagement
   
       #touch ~/Dropbox/organizer.org
       #ln ~/Dropbox/organizer.org ~/organizer.org
       ## Place in Agenda for org-agenda
       #mkdir -p ~/Dropbox/Agenda
       #ln ~/Dropbox/organizer.org ~/Dropbox/Agenda/organizer.org
       #touch ~/Dropbox/refile.org
       #ln ~/Dropbox/refile.org ~/refile.org
       ## Place in Agenda for org-agenda
       #mkdir -p ~/Dropbox/Agenda
       #ln ~/Dropbox/refile.org ~/Dropbox/Agenda/refile.org
       #touch ~/Dropbox/meeting.org
       #ln ~/Dropbox/meeting.org ~/meeting.org
       ## Place in Agenda for org-agenda
       #mkdir -p ~/Dropbox/Agenda
       #ln ~/Dropbox/meeting.org ~/Dropbox/Agenda/meeting.org
   fi
   bot "Created organization!"
#####################################################################################################

# Hello there!
echo "
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
" > test.bats
bats test.bats

   }

   main "$@"
