#!/usr/bin/env bash
# Send a desktop notification through the running KDE Plasma session.
# Plasma implements the freedesktop.org notification specification, which
# libnotify's notify-send targets.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: plasma-notify [OPTIONS] TITLE [BODY]

Send a desktop notification through the running KDE Plasma session.
When BODY is omitted and stdin is not a terminal, the body is read from stdin.

Options:
  -a, --app NAME        application name shown in the notification
                        (default: plasma-notify)
  -u, --urgency LEVEL   low, normal, or critical (default: normal)
  -i, --icon NAME       icon name or absolute path
  -t, --timeout MS      expiry timeout in milliseconds (0 = server default)
  -r, --replace-id ID   replace an existing notification with this ID
  -c, --category TYPE   notification category, e.g. device, email, im
  -p, --print-id        print the notification ID
  -h, --help            show this help

Examples:
  plasma-notify "Build finished"
  plasma-notify -u critical -i dialog-error "Backup failed" "See /var/log/backup.log"
  printf 'line one\nline two\n' | plasma-notify "Report"
EOF
}

require_value() {
  if (($# < 2)); then
    echo "plasma-notify: $1 requires a value" >&2
    exit 2
  fi
}

app_name=plasma-notify
urgency=normal
icon=
timeout=
replace_id=
category=
print_id=false

while (($# > 0)); do
  case $1 in
  -a | --app)
    require_value "$@"
    app_name=$2
    shift 2
    ;;
  -u | --urgency)
    require_value "$@"
    urgency=$2
    shift 2
    ;;
  -i | --icon)
    require_value "$@"
    icon=$2
    shift 2
    ;;
  -t | --timeout)
    require_value "$@"
    timeout=$2
    shift 2
    ;;
  -r | --replace-id)
    require_value "$@"
    replace_id=$2
    shift 2
    ;;
  -c | --category)
    require_value "$@"
    category=$2
    shift 2
    ;;
  -p | --print-id)
    print_id=true
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  --)
    shift
    break
    ;;
  -?*)
    echo "plasma-notify: unknown option: $1" >&2
    usage >&2
    exit 2
    ;;
  *) break ;;
  esac
done

title=${1-}
if (($# > 0)); then shift; fi
body=${1-}
if (($# > 0)); then shift; fi
if (($# > 0)); then
  echo "plasma-notify: unexpected argument: $1" >&2
  exit 2
fi

if [[ -z $title ]]; then
  echo "plasma-notify: missing notification title" >&2
  usage >&2
  exit 2
fi

case $urgency in
low | normal | critical) ;;
*)
  echo "plasma-notify: invalid urgency: $urgency (expected low, normal, or critical)" >&2
  exit 2
  ;;
esac

if [[ -z $body && ! -t 0 ]]; then
  body=$(cat)
fi

args=(--app-name "$app_name" --urgency "$urgency")
[[ -n $icon ]] && args+=(--icon "$icon")
[[ -n $timeout ]] && args+=(--expire-time "$timeout")
[[ -n $replace_id ]] && args+=(--replace-id "$replace_id")
[[ -n $category ]] && args+=(--category "$category")
[[ $print_id == true ]] && args+=(--print-id)

exec notify-send "${args[@]}" -- "$title" "$body"
