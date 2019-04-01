echo "Setup to install Murmur and the dependencies"

#check that all the tools are already installed
# MongoDB
# PostgreSQL
# Ruby + Node
# wkhtmltopdf
# ImageMagick
# tmux


echo "Check for Homebrew and install if we don't have it"
if test ! $(which brew); then
echo "I will install brew"
else
echo "Brew already installed"
fi

echo "We will try to install ASDF"
    #only add if not exists
    echo "check if the path already exists in ~/.zshrc file"

    if grep -Fq "source /usr/local/opt/asdf/asdf.sh" ~/.zshrc; then
        echo "source /usr/local/opt/asdf/asdf.sh Already added";
    else
        echo "Let's add it";
        echo 'source /usr/local/opt/asdf/asdf.sh' >> ~/.zshrc
    fi

    if grep -Fq ". /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash" ~/.zshrc; then
        echo ". /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash Already added";
    else
        echo "Let's add it";
        echo '. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash' >> ~/.zshrc
    fi



zsh<<CONFIG
  source ~/.zshrc

  # Install useful plugins (at least for me :D)
  echo "[INFO] Installing asdf plugins...";

  asdf plugin-add ruby
  asdf plugin-add nodejs
  asdf plugin-add elixir
  asdf plugin-add elm
  asdf plugin-add java
  asdf plugin-add maven
  asdf plugin-add nodejs
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring;
  # asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git;
  # asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git;
  # asdf plugin-add packer https://github.com/Banno/asdf-hashicorp.git;

  #install differents tools
  asdf install ruby 2.6.2
  asdf install ruby 2.5.1
  asdf install maven 3.6.0
  asdf install mongodb 3.4.15
  asdf install nodejs 8.14.0
  asdf install postgres 10.5
  asdf install elixir 1.7.3
CONFIG
