#!/bin/bash

# -
# The MIT License (MIT)
#
# Copyright (c) 2014 RootForum.org
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#===============================================================================
# DEFAULT SETTINGS
#===============================================================================

MODE=1
VERSION="0.1.dev"


#===============================================================================
# AUTOMATED SETTINGS DETECTION
#===============================================================================

detect_binary() {
    local rval=""
    local tval=$(which "${1}")
    if [ -x "${tval}" ]; then
        rval=${tval}
    else
        local BINDIRS="/bin /usr/bin /sbin /usr/sbin /usr/local/bin /usr/local/sbin"
        rval=""
        for i in $BINDIRS; do
            if [ -x "${i}/${1}" ]; then
                rval="${i}/${1}"
                break
            fi
        done
    fi
    echo $rval
}

b_basename=$(detect_binary "basename")
b_grep=$(detect_binary "grep")
b_ls=$(detect_binary "ls")
b_sed=$(detect_binary "sed")
b_sphinx_build=$(detect_binary "sphinx-build")
b_sphinx_intl=$(detect_binary "sphinx-intl")

cyan="\033[1;36m"
magenta="\033[1;35m"
red="\033[1;31m"
amber="\033[1;33m"
green="\033[1;32m"
white="\033[1;37m"
normal="\033[0m"

current_dir=""
root_dir=""


#===============================================================================
# AUXILIARY FUNCTIONS
#===============================================================================

cd_root() {
    current_dir=$(pwd)
    root_dir=${current_dir}
    while [ "$($b_basename $root_dir)" != "beasties-fortress" ]; do
        cd ..
        root_dir=$(pwd)
    done
}

cd_origin() {
    if [ -d "${current_dir}" ]; then
        cd ${current_dir}
    fi
}

detect_locales() {
    local candidates=$(${b_ls} --color=never -A -1 locale | ${b_grep} --color=never -E '(^[a-z]{2}$|^[a-z]{2}_[A-Z]{2}$)')
    local result=""
    for candidate in ${candidates}; do
        if [ -n "$(locale_name ${candidate})" ]; then
            if [ -d "locale/${candidate}/LC_MESSAGES" ]; then
                result="${result} ${candidate}"
            fi
        fi
    done
    echo ${result}
}

locale_name() {
    local lname=""
    case ${1} in
        bn)
            lname="Bengali"
            ;;
        ca)
            lname="Catalan"
            ;;
        cs)
            lname="Czech"
            ;;
        da)
            lname="Danish"
            ;;
        de)
            lname="German"
            ;;
        en)
            lname="English"
            ;;
        es)
            lname="Spanish"
            ;;
        et)
            lname="Estonian"
            ;;
        eu)
            lname="Basque"
            ;;
        fa)
            lname="Iranian"
            ;;
        fi)
            lname="Finnish"
            ;;
        fr)
            lname="French"
            ;;
        he)
            lname="Hebrew"
            ;;
        hr)
            lname="Croatian"
            ;;
        hu)
            lname="Hungarian"
            ;;
        id)
            lname="Indonesian"
            ;;
        it)
            lname="Italian"
            ;;
        ja)
            lname="Japanese"
            ;;
        ko)
            lname="Korean"
            ;;
        lt)
            lname="Lithuanian"
            ;;
        lv)
            lname="Latvian"
            ;;
        mk)
            lname="Macedonian"
            ;;
        nb_NO)
            lname="Norwegian Bokmal"
            ;;
        ne)
            lname="Nepali"
            ;;
        nl)
            lname="Dutch"
            ;;
        pl)
            lname="Polish"
            ;;
        pt_BR)
            lname="Brazilian Portuguese"
            ;;
        pt_PT)
            lname="European Portuguese"
            ;;
        ru)
            lname="Russian"
            ;;
        si)
            lname="Sinhala"
            ;;
        sk)
            lname="Slovak"
            ;;
        sl)
            lname="Slovenian"
            ;;
        sv)
            lname="Swedish"
            ;;
        tr)
            lname="Turkish"
            ;;
        uk_UA)
            lname="Ukrainian"
            ;;
        vi)
            lname="Vietnamese"
            ;;
        zh_CN)
            lname="Simplified Chinese"
            ;;
        zh_TW)
            lname="Traditional Chinese"
            ;;
        *)
            lname=""
            ;;
    esac
    echo ${lname}
}

make_gettext() {
    { ${b_sphinx_build} -b gettext source build/locale; } > /dev/null 2>&1
    echo $?
}


#===============================================================================
# ACTIONS
#===============================================================================

show_usage() {
    if [ "${MODE}" -eq "1" ]; then
        c_cyan=${cyan}
        c_magenta=${magenta}
        c_red=${red}
        c_amber=${amber}
        c_green=${green}
        c_white=${white}
        c_normal=${normal}
    else
        c_cyan=""
        c_magenta=""
        c_red=""
        c_amber=""
        c_green=""
        c_white=""
        c_normal=""
    fi
    echo -e "${c_red}usage: ${c_green}$($b_basename ${0}) ${c_white}[-n] ${c_amber}[<command>] ${c_white}[args]${c_normal}

${c_red}global options:${c_normal}

   ${c_white}-n${c_normal}   do not use color escape sequences in output

${c_red}commands:${c_normal}

  ${c_white}add [<locale>]${c_normal}
    add specified locale to translations

  ${c_white}list${c_normal}
    list already existing locales

  ${c_white}update${c_normal}
    update .po files

  ${c_white}version${c_normal}
    show version information

Please report any issues like bugs etc. via the project's bug tracking
tool available at https://github.com/RootForum/beasties-fortress" >&2
}

show_version() {
    if [ "$#" -gt "0" ]; then
        arg=${1}
    else
        arg="-l"
    fi
    case ${arg} in
        -s)
            echo "${VERSION}" >&2
            ;;
        *)
            echo "`$b_basename $0` ${VERSION}

Copyright (c) 2014 RootForum.org
License: MIT License <http://opensource.org/licenses/MIT>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law." >&2
            ;;
    esac
}

list_locales() {
    echo "The following locales were detected:"
    echo
    for locale in $(detect_locales); do
        printf "   ${magenta}%-5s ${white} -  " ${locale}
        printf "%s${normal}\n" "$(locale_name ${locale})"
    done
}

add_locale() {
    if [ -n "$(locale_name ${1})" ]; then
        echo -e -n "${cyan}[WORK] ${white}updating pot files... "
        rval=$(make_gettext)
        if [ "${rval}" -eq "0" ]; then
            echo -e "${green}succeeded.${normal}"
        else
            echo -e "${red}failed.${normal}"
        fi
        if [ -d "locale/${1}/LC_MESSAGES" ]; then
            echo -e "${amber}[WARN] ${white}locale ${1} already exists... ${amber}skipped.${normal}"
        else
            cd source
            echo -e -n "${cyan}[WORK] ${white}adding locale ${1}... "
            { ${b_sphinx_intl} update -p ../build/locale -l ${1}; }  > /dev/null 2>&1
            rval=$?
            if [ "${rval}" -eq "0" ]; then
                echo -e "${green}succeeded.${normal}"
            else
                echo -e "${red}failed.${normal}"
            fi
            cd ..
        fi
    else
        echo -e "${red}[FAIL] ${white}You must specify a valid locale.${normal}"
        exit 1
    fi
}

update_locales() {
    echo -e -n "${cyan}[WORK] ${white}updating pot files... "
    rval=$(make_gettext)
    if [ "${rval}" -eq "0" ]; then
        echo -e "${green}succeeded.${normal}"
    else
        echo -e "${red}failed.${normal}"
    fi
    for locale in $(detect_locales); do
        echo -e -n "${cyan}[WORK] ${white}updating locale ${magenta}${locale}${white}... "
        cd source
        { ${b_sphinx_intl} update -p ../build/locale -l ${locale}; }  > /dev/null 2>&1
        rval=$?
        if [ "${rval}" -eq "0" ]; then
            echo -e "${green}succeeded.${normal}"
        else
            echo -e "${red}failed.${normal}"
        fi
        cd ..
    done
}


#===============================================================================
# MAIN PART
#===============================================================================

action="show_usage"

while [ "$#" -gt "0" ]; do
    case ${1} in
        -n)
            MODE=0
            red=""
            amber=""
            green=""
            white=""
            normal=""
            cyan=""
            magenta=""
            shift
            ;;
        help)
            action="show_usage"
            shift
            break
            ;;
        -h)
            action="show_usage"
            shift
            break
            ;;
        --help)
            action="show_usage"
            shift
            break
            ;;
        version)
            action="show_version"
            shift
            break
            ;;
        -v)
            action="show_version"
            shift
            break
            ;;
        --version)
            action="show_version"
            shift
            break
            ;;
        add)
            action="add_locale"
            shift
            break
            ;;
        build)
            action="build_locales"
            shift
            break
            ;;
        list)
            action="list_locales"
            shift
            break
            ;;
        update)
            action="update_locales"
            shift
            break
            ;;
        *)
            action="show_usage"
            shift
            break
            ;;
    esac
done

cd_root

case ${action} in
    add_locale)
        add_locale $*
        ;;
    list_locales)
        list_locales $*
        ;;
    update_locales)
        update_locales $*
        ;;
    show_usage)
        show_usage
        ;;
    show_version)
        show_version $*
        ;;
    *)
        show_usage
        ;;
esac

cd_origin

exit 0
