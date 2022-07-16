# Conda clobbers HOST, so we save the real hostname into another variable.
HOSTNAME="$(hostname)"
precmd() {
    OLDHOST="${HOST}"
    HOST="${HOSTNAME}"
}
preexec() {
    HOST="${OLDHOST}"
}
