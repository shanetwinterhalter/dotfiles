#!/bin/zsh

script_dir="${0:a:h}"

function create_link {
    if [ ! -L $2 ]; then
        echo "Creating link from $2 to ${script_dir}/$1"
        ln -s ${script_dir}/$1 $2
    fi
}

function install_zsh_plugin {
    if [ -d ${script_dir}/zsh-plugins/$1 ]; then
        cd ${script_dir}/zsh-plugins/$1 && git pull && cd ${script_dir}
    else
        git clone $2 zsh-plugins/$1
    fi
 }

# Download zsh plugins
mkdir -p ${script_dir}/zsh-plugins
install_zsh_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git  

create_link zshenv ~/.zshenv
create_link zshrc ${script_dir}/.zshrc

if command -v kitty &> /dev/null; then
    create_link kitty ~/.config/kitty
fi

if command -v Hyprlandi &> /dev/null; then
  create_link hypr ~/.config/hypr
fi

if command -v waybar &> /dev/null; then
  create_link waybar ~/.config/waybar
fi

if command -v rofii &> /dev/null; then
  create_link rofi ~/.config/rofi
fi

if command -v spotify-launcher &> /dev/null; then
  create_link electron/electron-flags.conf ~/.config/electron-flags.conf
  create_link spotify/spotify-launcher.conf ~/.config/spotify-launcher.conf
fi


