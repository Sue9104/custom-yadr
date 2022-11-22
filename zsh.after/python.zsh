export PATH=$PATH:$HOME/miniconda3/bin
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/msu/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/msu/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/msu/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/msu/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/msu/miniconda3/etc/profile.d/mamba.sh" ]; then
    . "/home/msu/miniconda3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

