#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

current_userid=$(id -u)
if [ $current_userid -ne 0 ]; then
    echo "$(basename "$0") uninstallation script requires superuser privileges to run" >&2
    exit 1
fi

dotnet_pkg_name_suffix="com\.microsoft\.dotnet.+?(?=preview).*"
dotnet_install_root="/usr/local/share/dotnet/sdk"

remove_dotnet_pkgs(){
    installed_pkgs=($(pkgutil --pkgs | ggrep -P $dotnet_pkg_name_suffix))
    
    for i in "${installed_pkgs[@]}"
    do
        pkgutil --force --forget "$i"
    done
}
remove_dotnet_pkgs
[ "$?" -ne 0 ] && echo "Failed to remove dotnet packages." >&2 && exit 1

echo "Deleting preview SDKs - $dotnet_install_root" >&2

remove_preview_sdks(){
    sdks=($(ls $dotnet_install_root | ggrep -P ".*preview.*"))

    for i in "${sdks[@]}"
    do
        echo "  \"$i\"" >&2
        rm -rf "$dotnet_install_root"
    done

}
remove_preview_sdks

echo "dotnet preview SDKs removal succeeded." >&2
exit 0
