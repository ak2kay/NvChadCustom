#!/bin/bash
# Note: this config will delete your current neovim config && apply config in this repo

set -o errexit
set -o pipefail

script=$(readlink -f "$0")
base_dir=$(dirname "$script")

. "${base_dir}"/utils.sh

custom_config_path="${HOME}/.config/nvim/lua/custom"

echo -n "this script will delete your current neovim config in ${XDG_CONFIG_HOME}(${custom_config_path} if emtpy) and ${XDG_DATA_HOME}(${custom_config_path} if empty). Are you sure (Y/N)? "
if asksure; then
	echo "apply..."
	rm -rf "${HOME}/.local/share/nvim"
	rm -rf "${custom_config_path}"
	rm -rf "${HOME}/.cache/nvim"

	ensureTargetDir "${custom_config_path}"

	stow . --target="${custom_config_path}" --restow 
else
	echo "Exit..."
fi
