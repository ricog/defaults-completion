# Completion script for the OS X defaults command
#
# To use, add the following to your .bashrc:
#
#    . defaults_bash_completion.sh
#
__defaultscomp_words_include ()
{
    local i=1
    while [[ $i -lt $COMP_CWORD ]]; do
        if [[ "${COMP_WORDS[i]}" = "$1" ]]; then
            return 0
        fi
        i=$((++i))
    done
    return 1
}

__defaultscomp ()
{
    # break $1 on space, tab, and newline characters,
    # and turn it into a newline separated list of words
    local list s sep=$'\n' IFS=$' '$'\t'$'\n'
    local cur="${COMP_WORDS[COMP_CWORD]}"

    for s in $1; do
        __defaultscomp_words_include "$s" && continue
        list="$list$s$sep"
    done

    IFS=$sep
    COMPREPLY=($(compgen -W "$list" -- "$cur"))
}

_defaults ()
{
    local i=1 cmd

    # find the subcommand
    while [[ $i -lt $COMP_CWORD ]]; do
        local s="${COMP_WORDS[i]}"
        case "$s" in
        --*)
            cmd="$s"
            break
            ;;
        -*)
            ;;
        *)
            cmd="$s"
            break
            ;;
        esac
        i=$((++i))
    done

    if [[ $i -eq $COMP_CWORD ]]; then
        __defaultscomp "
            read
            read-type
			write
            domains
            find
			help
            "
        return
    fi

    # subcommands can have their own completion functions
    case "$cmd" in
    read)  _defaults_read ;;
    write)  _defaults_read ;;
    *)                          ;;
    esac
}

_defaults_read ()
{
	local ext=$(\cd $HOME/Library/Preferences && /bin/ls *.plist 2>/dev/null)
	__defaultscomp "$ext"
	return
}
complete -o bashdefault -o default -F _defaults defaults
