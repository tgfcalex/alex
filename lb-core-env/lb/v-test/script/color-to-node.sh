#!/bin/bash

#
# Set Colors
#
red=$(tput setaf 1)
green=$(tput setaf 76)
white=$(tput setaf 7)
tan=$(tput setaf 202)
blue=$(tput setaf 25)
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

#
# Headers and Logging
#
_underline() {
    printf "${underline}${bold}%s${reset}\n" "$@"
}
_h1() {
    printf "\n${underline}${bold}${blue}%s${reset}\n" "$@"
    sleep 2
}
_h2() {
    printf "\n${underline}${bold}${white}%s${reset}\n" "$@"
}
_debug() {
    printf "${white}%s${reset}\n" "$@"
}
_info() {
    printf "${white}➜ %s${reset}\n" "$@"
}
_success() {
    printf "${green}✔ %s${reset}\n" "$@"
}
_error() {
    printf "${red}✖ %s${reset}\n" "$@"
}
_warn() {
    printf "${tan}➜ %s${reset}\n" "$@"
}
_bold() {
    printf "${bold}%s${reset}\n" "$@"
    #echo
    #read -p "请确认操作，任意键继续..." var
}
_note() {
    printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
}

_usage() {
    printf "${green}%s${reset}\n" "Usage:"
    printf "${green}%s${reset}\n" "$@"
}


_wait() {
    set +e
    local COUNTER=$1
    printf "${tan}➜ %s${reset}\c"  "$2"
    unset BLANK
    while [ $COUNTER -gt 0 ];do
        printf "\b\b${green}%b${reset}" "$COUNTER$BLANK"
        sleep 1
        ((COUNTER-=1))
        [ $COUNTER -le 9 ] && BLANK=" "
    done
    echo "$3"
}

