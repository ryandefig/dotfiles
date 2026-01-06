#!/usr/bin/env zsh
# Prompt configuration with git integration and upstream tracking

# Load version control system info
autoload -Uz vcs_info

# Run vcs_info before each prompt
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

# Enable command substitution in prompt
setopt PROMPT_SUBST

# Configure git info format
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

# Disable default virtualenv prompt modification
VIRTUAL_ENV_DISABLE_PROMPT=1

# Unicode characters for visual design
L_ANGLE="\u276e"
R_ANGLE="\u276f"
DOT="\u00b7"

# Display current directory
function prompt_dir() {
    print -n "%F{blue}$L_ANGLE%~$R_ANGLE%f "
}

# Display active Python virtualenv
function prompt_virtualenv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        print -n "%F{magenta}$L_ANGLE$(basename ${VIRTUAL_ENV})$R_ANGLE%f "
    fi
}

# Display git branch and status with upstream tracking
function prompt_vcs() {
    local local_ref local_info local_color
    local remote_ref remote_info remote_color
    local upstream local_sha remote_sha base_sha

    local_ref="$vcs_info_msg_0_"

    if [[ -n "$local_ref" ]]; then
        local_info=$local_ref
        local_color="green"

        # Check if working directory is dirty (has uncommitted changes)
        if [[ -n "$(git status --porcelain --ignore-submodules 2>/dev/null)" ]]; then
            local_color="yellow"
        fi

        # Check if HEAD is detached (optimized: use vcs_info action instead of second git status)
        if [[ -n "$vcs_info_msg_1_" ]]; then
            local_info="(detached) ${local_ref/.../}"
        fi

        # Get upstream tracking information
        remote_ref="$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD) 2>/dev/null)"
        if [[ -n $remote_ref ]]; then
            upstream=${1:-'@{u}'}
            local_sha=$(git rev-parse @ 2>/dev/null)
            remote_sha=$(git rev-parse "$upstream" 2>/dev/null)
            base_sha=$(git merge-base @ "$upstream" 2>/dev/null)

            # Determine relationship between local and remote
            if [ "$local_sha" = "$remote_sha" ]; then
                # Up to date with remote
                remote_color=$local_color
            elif [ "$local_sha" = "$base_sha" ]; then
                # Behind remote (need to pull)
                remote_color="red"
            elif [ "$remote_sha" = "$base_sha" ]; then
                # Ahead of remote (need to push)
                remote_color="cyan"
            else
                # Diverged (need to pull and merge/rebase)
                remote_color="magenta"
            fi

            remote_info=" %F{${remote_color}}$DOT$DOT$DOT ${remote_ref}$R_ANGLE%f"
        else
            # No upstream configured
            remote_color=$local_color
            remote_info="%F{${remote_color}}$R_ANGLE%f"
        fi

        local_info="%F{${local_color}}$L_ANGLE${local_info}%f"

        print -n "${local_info}${remote_info}"
    fi
}

# Prompt ending without newline
function prompt_end_no_newline() {
    print -n " "
}

# Prompt ending with newline and angle bracket
function prompt_end_newline() {
    print -n "\n%F{white}$R_ANGLE%f "
}

# Main prompt (single line)
export PROMPT=$'$(prompt_virtualenv)$(prompt_dir)$(prompt_vcs)$(prompt_end_no_newline)'

# Alternative: Two-line prompt with angle bracket on second line
# Uncomment to use:
# export PROMPT=$'$(prompt_virtualenv)$(prompt_dir)$(prompt_vcs)$(prompt_end_newline)'