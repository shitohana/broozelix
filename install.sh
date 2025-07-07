#!/usr/bin/env bash

set -e

BROOZELIX_REPO="https://github.com/shitohana/broozelix.git"

# Parse params
while [[ $# -gt 0 ]]; do
    case $1 in
    -y | --confirm)
        CONFIRM=1
        shift 1
        ;;
    -p | --path)
        INSTALL_PATH="$2"
        shift 2
        ;;
    -h | --help)
        echo "Install broozelix"
        echo "Broozelix is a zellij layout config with a patched helix"
        echo "build with possibility to send commands via UNIX socket."
        echo
        echo "If you alredy have your own broot/helix/zellij configs, those"
        echo "will not be modified. broozelix configs will be just appended"
        echo "to yours"
        echo "Usage: $0 [options]"
        echo "Options:"
        echo "  -y, --confirm.   Automatically confirm all prompts (non-interactive)"
        echo "  -p, --path PATH  Path, where broozelix configs (and helix source)"
        echo "                   will be installed (default: $XDG_CONFIG_HOME/broozelix)"
        echo "  -h, --help       Show this help message"
        echo
        echo "If helix PR #13896 will be merged into main, there will be no need for"
        echo "cloning and building fork. This script will be modified"
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

INSTALL_PATH="${INSTALL_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/broozelix}"
INSTALL_PATH="$(realpath $INSTALL_PATH)"
mkdir -p "$INSTALL_PATH"
cd "$INSTALL_PATH"

clone_broozelix() {
    if [[ ! -d "$INSTALL_PATH/.git" ]]; then
        echo "Cloning broozelix repository"
        git clone "$BROOZELIX_REPO" "$INSTALL_PATH"
    else
        echo "Helix repository already exists at path. Skipping"
    fi
}
clone_broozelix

colorize() {
    local color=$1
    local text=$2
    case $color in
    red) code="31" ;;
    green) code="32" ;;
    yellow) code="33" ;;
    blue) code="34" ;;
    *) code="0" ;;
    esac
    echo -e "\033[${code}m${text}\033[0m"
}

prompt_execute() {
    local prompt="$1"
    local cmd="$2"
    local fallback="$3"
    read -p "$prompt? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" || "${CONFIRM:-0}" == 1 ]]; then
        eval "$cmd"
    else
        eval "$fallback"
    fi
}

check_essential() {
    local tool=$1

    if command -v $tool >/dev/null 2>&1; then
        colorize green "- $tool"
    else
        colorize red "$tool not found. Please install it."
        exit 1
    fi
}

check_cargo_tool() {
    local tool=$1

    if command -v $tool >/dev/null 2>&1; then
        colorize green "- $tool"
    else
        prompt_execute \
            "Install $tool" \
            "cargo install --locked $tool" \
            "echo 'Can't proceed with broozelix installation'; exit 1"
    fi
}

echo "Check essential commands are available"
for tool in cargo git; do
    check_essential $tool
done
echo

echo "Check requirements are satisfied"
for tool in zellij broot bat; do
    check_cargo_tool $tool
done
echo


HELIX_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/helix"
BROOZELIX_MARKER="$HELIX_CONFIG_DIR/broozelix"

create_broozelix_marker() {
    mkdir -p "$HELIX_CONFIG_DIR"
    touch "$BROOZELIX_MARKER"
}

install_helix() {
    if [[ "${CONFIRM:-0}" == 0 ]]; then
        read -p "Enter $(colorize blue Helix) compile env vars or leave blank: " HELIX_COMPILE_ENV
    fi
    pushd "$INSTALL_PATH/helix"

    if ! eval "$HELIX_COMPILE_ENV cargo install --path helix-term --locked"; then
        colorize red "Helix installation failed."
        exit 1
    fi

    prompt_execute \
        "Clean build artifacts" \
        "cargo clean" \
        "echo 'Skipping cleaning build artifacts'"
    
    create_broozelix_marker

    colorize green \
        "Helix has been installed to $(which hx)"
    popd
}

check_and_install_helix() {
    if [[ -f "$BROOZELIX_MARKER" ]]; then
        prompt_execute \
            "Detected existing Broozelix Helix installation. Reinstall?" \
            "install_helix" \
            "echo 'Skipping Helix installation'"
    else
        install_helix
    fi
}

# Compile and install helix
echo -e "Installing $(colorize blue Helix)"
check_and_install_helix


symlink_zellij() {
    ZELLIJ_SRC_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zellij"
    ZELLIJ_DEST_DIR="${INSTALL_PATH}/zellij"

    mkdir -p "$ZELLIJ_DEST_DIR"

    if [[ -d "$ZELLIJ_SRC_DIR" ]]; then
        for file in "$ZELLIJ_SRC_DIR"/*; do
            [ -e "$ZELLIJ_DEST_DIR/$(basename "$file")" ] || ln -s "$file" "$ZELLIJ_DEST_DIR/"
        done
        colorize green "Symlinked Zellij config files from $ZELLIJ_SRC_DIR to $ZELLIJ_DEST_DIR"
    else
        colorize yellow "No existing Zellij config found at $ZELLIJ_SRC_DIR"
    fi
}

echo
echo "Creating symlinks to user zellij config files"
symlink_zellij

echo
colorize blue "Add the following alias to your shell to launch broozelix:"
echo "  alias broozelix=\"$(realpath $INSTALL_PATH)/run.sh\""

for file in "$INSTALL_PATH/zellij/layouts/"*.{sh,kdl}; do
    [[ -f "$file" ]] || continue
    sed "s|\$TEMPLATE|$INSTALL_PATH|g" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done
sed "s|\$TEMPLATE|$INSTALL_PATH|g" "$(realpath $INSTALL_PATH)/run.sh" > "$(realpath $INSTALL_PATH)/run.sh.tmp" && mv "$(realpath $INSTALL_PATH)/run.sh.tmp" "$(realpath $INSTALL_PATH)/run.sh"

chmod +x run.sh
chmod +x zellij/layouts/broot-loop.sh
chmod +x zellij/layouts/helix-loop.sh

cd "$OLDPWD"
