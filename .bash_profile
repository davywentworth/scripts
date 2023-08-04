source ~/.git-completion.bash
eval "$(rbenv init -)"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
source ~/.thanx/env
export NODE_ENV="development"

# for building mysql2 gem
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"


export DYNETI_MAVEN_USERNAME=thanx
export DYNETI_MAVEN_PASSWORD=*2NhaSNcp845
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH=/usr/local/git/bin:$PATH
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

export CONSUMER_TARGET_DIR=/Users/davy/dev/thanx-homepage/app/assets/javascripts
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

LIGHTBLUE="\[\e[01;34m\]"
YELLOW="\[\e[0;33m\]"
RED="\[\e[0;31m\]"
WHITE="\[\e[1;37m\]"
PLAIN="\[\e[m\]"

PS1="${LIGHTBLUE}\T  ${YELLOW}\w ${RED}\$(__git_ps1)  ${WHITE}> ${PLAIN}"

##
# Your previous /Users/davy/.bash_profile file was backed up as /Users/davy/.bash_profile.macports-saved_2012-03-20_at_08:30:06
##

# MacPorts Installer addition on 2012-03-20_at_08:30:06: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
export DYLD_LIBRARY_PATH="/usr/local/mysql/lib:$DYLD_LIBRARY_PATH"

# imagemagick - requires brew install pkg-config
export PKG_CONFIG_PATH="/opt/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export PATH="$HOME/.rvm/usr/ssl:$PATH"
export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

# for exporting the consumer js from the build script
export CONSUMER_TARGET_DIR=/Users/davy/dev/thanx-homepage/app/assets/javascripts

# export IGNORE_NETWORK_CONNECTIVITY="true"

alias lt="ls -latr"
alias sqlstart="ps -e|grep mysqld;sudo mysqld_safe"
function cherry {
  TARGET=$1
  if [ $# -eq 0 ]; then
    echo "using default: origin/master"
    TARGET="origin/master"
  fi
  echo "~~~~~~~~~Not on $TARGET ~~~~~~~~~~~";
  git cherry -v "$TARGET";
  echo "~~~~~~~~~Not on HEAD~~~~~~~~~~~~~~~~~~~~";
  git cherry -v HEAD "$TARGET";
}

# Opens a new tab in the current Terminal window and optionally executes a command.
# When invoked via a function named 'newwin', opens a new Terminal *window* instead.
newtab() {

    # If this function was invoked directly by a function named 'newwin', we open a new *window* instead
    # of a new tab in the existing window.
    local funcName=$FUNCNAME
    local targetType='tab'
    local targetDesc='new tab in the active Terminal window'
    local makeTab=1
    case "${FUNCNAME[1]}" in
        newwin)
            makeTab=0
            funcName=${FUNCNAME[1]}
            targetType='window'
            targetDesc='new Terminal window'
            ;;
    esac

    # Command-line help.
    if [[ "$1" == '--help' || "$1" == '-h' ]]; then
        cat <<EOF
Synopsis:
    $funcName [-g|-G] [command [param1 ...]]

Description:
    Opens a $targetDesc and optionally executes a command.

    The new $targetType will run a login shell (i.e., load the user's shell profile) and inherit
    the working folder from this shell (the active Terminal tab).
    IMPORTANT: In scripts, \`$funcName\` *statically* inherits the working folder from the
    *invoking Terminal tab* at the time of script *invocation*, even if you change the
    working folder *inside* the script before invoking \`$funcName\`.

    -g (back*g*round) causes Terminal not to activate, but within Terminal, the new tab/window
      will become the active element.
    -G causes Terminal not to activate *and* the active element within Terminal not to change;
      i.e., the previously active window and tab stay active.

    NOTE: With -g or -G specified, for technical reasons, Terminal will still activate *briefly* when
    you create a new tab (creating a new window is not affected).

    When a command is specified, its first token will become the new ${targetType}'s title.
    Quoted parameters are handled properly.

    To specify multiple commands, use 'eval' followed by a single, *double*-quoted string
    in which the commands are separated by ';' Do NOT use backslash-escaped double quotes inside
    this string; rather, use backslash-escaping as needed.
    Use 'exit' as the last command to automatically close the tab when the command
    terminates; precede it with 'read -s -n 1' to wait for a keystroke first.

    Alternatively, pass a script name or path; prefix with 'exec' to automatically
    close the $targetType when the script terminates.

Examples:
    $funcName ls -l "\$Home/Library/Application Support"
    $funcName eval "ls \\\$HOME/Library/Application\ Support; echo Press a key to exit.; read -s -n 1; exit"
    $funcName /path/to/someScript
    $funcName exec /path/to/someScript
EOF
        return 0
    fi

    # Option-parameters loop.
    inBackground=0
    while (( $# )); do
        case "$1" in
            -g)
                inBackground=1
                ;;
            -G)
                inBackground=2
                ;;
            --) # Explicit end-of-options marker.
                shift   # Move to next param and proceed with data-parameter analysis below.
                break
                ;;
            -*) # An unrecognized switch.
                echo "$FUNCNAME: PARAMETER ERROR: Unrecognized option: '$1'. To force interpretation as non-option, precede with '--'. Use -h or --h for help." 1>&2 && return 2
                ;;
            *)  # 1st argument reached; proceed with argument-parameter analysis below.
                break
                ;;
        esac
        shift
    done

    # All remaining parameters, if any, make up the command to execute in the new tab/window.

    local CMD_PREFIX='tell application "Terminal" to do script'

        # Command for opening a new Terminal window (with a single, new tab).
    local CMD_NEWWIN=$CMD_PREFIX    # Curiously, simply executing 'do script' with no further arguments opens a new *window*.
        # Commands for opening a new tab in the current Terminal window.
        # Sadly, there is no direct way to open a new tab in an existing window, so we must activate Terminal first, then send a keyboard shortcut.
    local CMD_ACTIVATE='tell application "Terminal" to activate'
    local CMD_NEWTAB='tell application "System Events" to keystroke "t" using {command down}'
        # For use with -g: commands for saving and restoring the previous application
    local CMD_SAVE_ACTIVE_APPNAME='tell application "System Events" to set prevAppName to displayed name of first process whose frontmost is true'
    local CMD_REACTIVATE_PREV_APP='activate application prevAppName'
        # For use with -G: commands for saving and restoring the previous state within Terminal
    local CMD_SAVE_ACTIVE_WIN='tell application "Terminal" to set prevWin to front window'
    local CMD_REACTIVATE_PREV_WIN='set frontmost of prevWin to true'
    local CMD_SAVE_ACTIVE_TAB='tell application "Terminal" to set prevTab to (selected tab of front window)'
    local CMD_REACTIVATE_PREV_TAB='tell application "Terminal" to set selected of prevTab to true'

    if (( $# )); then # Command specified; open a new tab or window, then execute command.
            # Use the command's first token as the tab title.
        local tabTitle=$1
        case "$tabTitle" in
            exec|eval) # Use following token instead, if the 1st one is 'eval' or 'exec'.
                tabTitle=$(echo "$2" | awk '{ print $1 }')
                ;;
            cd) # Use last path component of following token instead, if the 1st one is 'cd'
                tabTitle=$(basename "$2")
                ;;
        esac
        local CMD_SETTITLE="tell application \"Terminal\" to set custom title of front window to \"$tabTitle\""
            # The tricky part is to quote the command tokens properly when passing them to AppleScript:
            # Step 1: Quote all parameters (as needed) using printf '%q' - this will perform backslash-escaping.
        local quotedArgs=$(printf '%q ' "$@")
            # Step 2: Escape all backslashes again (by doubling them), because AppleScript expects that.
        local cmd="$CMD_PREFIX \"${quotedArgs//\\/\\\\}\""
            # Open new tab or window, execute command, and assign tab title.
            # '>/dev/null' suppresses AppleScript's output when it creates a new tab.
        if (( makeTab )); then
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active tab after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_SAVE_ACTIVE_TAB" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_APP" -e "$CMD_REACTIVATE_PREV_TAB" >/dev/null
                else
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_APP" >/dev/null
                fi
            else
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" >/dev/null
            fi
        else # make *window*
            # Note: $CMD_NEWWIN is not needed, as $cmd implicitly creates a new window.
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active window after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_WIN" -e "$cmd" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_WIN" >/dev/null
                else
                    osascript -e "$cmd" -e "$CMD_SETTITLE" >/dev/null
                fi
            else
                    # Note: Even though we do not strictly need to activate Terminal first, we do it, as assigning the custom title to the 'front window' would otherwise sometimes target the wrong window.
                osascript -e "$CMD_ACTIVATE" -e "$cmd" -e "$CMD_SETTITLE" >/dev/null
            fi
        fi
    else    # No command specified; simply open a new tab or window.
        if (( makeTab )); then
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active tab after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_SAVE_ACTIVE_TAB" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$CMD_REACTIVATE_PREV_APP" -e "$CMD_REACTIVATE_PREV_TAB" >/dev/null
                else
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$CMD_REACTIVATE_PREV_APP" >/dev/null
                fi
            else
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" >/dev/null
            fi
        else # make *window*
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active window after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_WIN" -e "$CMD_NEWWIN" -e "$CMD_REACTIVATE_PREV_WIN" >/dev/null
                else
                    osascript -e "$CMD_NEWWIN" >/dev/null
                fi
            else
                    # Note: Even though we do not strictly need to activate Terminal first, we do it so as to better visualize what is happening (the new window will appear stacked on top of an existing one).
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWWIN" >/dev/null
            fi
        fi
    fi

}

# Opens a new Terminal window and optionally executes a command.
newwin() {
    newtab "$@" # Simply pass through to 'newtab', which will examine the call stack to see how it was invoked.
}

console() {
    thanx-cli platform console -c "thanx-$1" -p "$2"
}
info() {
    thanx-cli platform info -w -c "thanx-$1" -p "$2"
}
run() {
    thanx-cli platform console -c "thanx-$1" -p "$2"
}
alias reset_test="bin/rails db:drop RAILS_ENV=test; bin/rails db:create RAILS_ENV=test; bin/rails db:migrate RAILS_ENV=test;"
alias reset_dev="bin/rails db:drop; bin/rails db:create; bin/rails db:migrate;"
alias h="history"
alias ip="ifconfig | grep inet"
alias j="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias push="~/dev/python/push.py"
alias finish="~/dev/scripts-repo/finish.py"
alias toggle_db="~/dev/scripts/toggle_db.rb"
alias start="~/dev/scripts/start"
alias merchant-ui-start="~/dev/scripts/merchant-ui.bash"
alias clean="~/dev/python/clean.py"
alias rebase_quick="git fetch; git rebase --autosquash origin/master -i"
alias scd="z.sh"
alias nuc="code \`bundle info --path nucleus\`"
alias crepo="~/bin/crepo/crepo.py"
alias droid="~/dev/android-sdk-macosx/tools/emulator -avd test"
alias cov="open ~/dev/thanx-web/coverage/rcov/index.html"
alias jenkins="ssh bitnami@184.169.164.94"
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias less="less -N"
alias new="git checkout origin/master -q; git checkout -b"
alias log="git log --pretty=oneline --abbrev-commit"
alias get_thanx_sql='mysqldump -h thanx-staging-`date +%Y-%m-%d`.c8zovno0stoq.us-east-1.rds.amazonaws.com -P 3306 -u thanx -p thanx_production > thanx-`date +%Y-%m-%d`.sql'
alias cos="git checkout db/schema.rb"
alias bun="bundle update nucleus"
alias fixup="git commit -a -m fixup!"
alias local_nuke="bundle config local.nucleus /Users/davy/dev/thanx-nucleus"
alias consumer-ui="cd ~/dev/thanx-signup-ui"
alias consumer-api="cd ~/dev/thanx-api"
alias merchant-ui="cd ~/dev/thanx-merchant-ui"
alias merchant-api="cd ~/dev/thanx-merchant-api-new"
alias ordering-ui="cd ~/dev/thanx-ordering-ui"
alias mobile="cd ~/dev/thanx-mobile"
alias breact="cd ~/dev/thanx-breact"
alias signup="cd ~/dev/thanx-signup"
alias core="cd ~/dev/thanx-core"
alias admin="cd ~/dev/thanx-admin"
alias nucleus="cd ~/dev/thanx-nucleus"
alias no_local_nuke="bundle config --delete local.nucleus"
alias thanx="thanx-cli"
alias tn="/usr/local/Cellar/terminal-notifier/2.0.0/terminal-notifier.app/Contents/MacOS/terminal-notifier  -message "
alias rspec="bundle exec rspec"
jo() { open "https://thanxapp.atlassian.net/browse/`git rev-parse --abbrev-ref HEAD`" ;}
alias all-done="terminal-notifier -message 'all done'"
alias hr="heroku run rails c -a"
tl() { cd `git rev-parse --show-toplevel` ;}
alias server="bundle exec unicorn -p 7000 -c ./config/unicorn.rb"
export PATH=/usr/local/bin:$PATH
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
# :export PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
export PATH="./bin:$PATH"
export PATH=".bundle/bin:$PATH"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

# completion
_yarn_options='test test-debugger test-watchman test-unit test-unit-watchman test-integration preflight'
complete -W "${_yarn_options}" 'yarn'
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# function chpwd() {
#   local PKG
#   PKG=$PWD/package.json
#   if [ -f "$PKG" ]; then
#     PACKAGE_VERSION=$(cat package.json \
#       | grep \"node\": \
#       | head -1 \
#       | awk -F: '{ print $2 }' \
#       | sed 's/[",~^]//g' \
#       | tr -d '[[:space:]]')
#     nvm use $PACKAGE_VERSION
#   fi
# }

function cd() { builtin cd "$@" && nvm use; }

function run_after_save {
  prefix=$1
  file=$2
  line=$3
  if [ -z "$line" ]; then
    nodemon -x "$prefix $file" -w "$file"
  else
    nodemon -x "$prefix $file:$line" -w "$file"
  fi
}
alias wsr='run_after_save "bundle exec spring rspec"'
alias wr='run_after_save "bundle exec rspec"'
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="${HOME}/.pyenv/shims:${PATH}"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
