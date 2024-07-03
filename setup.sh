#!/bin/zsh

script_dir="${0:a:h}"

function create_link {
    if [ ! -L $2 ]; then
        echo "Creating link from $2 to ${script_dir}/$1"
        ln -s ${script_dir}/$1 $2
    fi
}

# Download zsh plugins
mkdir -p ${script_dir}/zsh-plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

create_link zshenv ~/.zshenv
create_link zshrc ${script_dir}/.zshrc
create_link kitty ~/.config/kitty

if [[ $(uname) == "Linux" ]]; then
  create_link hypr ~/.config/hypr
  create_link waybar ~/.config/waybar
  create_link rofi ~/.config/rofi
  create_link spotify/spotify-launcher.conf ~/.config/spotify-launcher.conf
  create_link electron/electron-flags.conf ~/.config/electron-flags.conf
fi

