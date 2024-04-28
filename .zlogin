case "${XDG_VTNR}" in
    1)  if [ -z "${WAYLAND_DISPLAY}" ] && which sway &> /dev/null; then
            while IFS== read -r key value; do
                printf -v "$key" %s "$value" && export "$key"
            done < ~/.config/sway/env

            unset DISPLAY WAYLAND_DISPLAY
            export XDG_SESSION_DESKTOP=sway
            export XDG_CURRENT_DESKTOP=$XDG_SESSION_DESKTOP
            exec systemd-cat -t sway sway
        fi
        ;;
    *)
        ;;
esac
