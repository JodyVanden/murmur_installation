echo "Setup to install Murmur and the dependencies"

#check that all the tools are already installed
# MongoDB
# PostgreSQL
# Ruby + Node
# wkhtmltopdf
# ImageMagick
# tmux

# echo "Check for Homebrew and install if we don't have it"
# if test ! $(which brew); then
# echo "I will install brew"
# else
# echo "Brew already installed"
# fi

# # Update Homebrew recipes
# echo "update homebrew"
# brew update

# # Install all our dependencies with bundle (See Brewfile)
# echo "install all dependencies from the BrewFile"
# brew tap homebrew/bundle
# brew bundle

# echo "We will try to install ASDF"
#     #only add if not exists
#     echo "check if the path already exists in ~/.zshrc file"

#     if grep -Fq "source /usr/local/opt/asdf/asdf.sh" ~/.zshrc; then
#         echo "source /usr/local/opt/asdf/asdf.sh Already added";
#     else
#         echo "-----> it's not there";
#         echo "-----> Let's add it to your zshrc";
#         echo 'source /usr/local/opt/asdf/asdf.sh' >> ~/.zshrc
#     fi

#     if grep -Fq ". /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash" ~/.zshrc; then
#         echo ". /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash Already added";
#      else
#         echo "-----> it's not there";
#         echo "-----> Let's add it to your zshrc";
#         echo '. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash' >> ~/.zshrc
#     fi

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
       
        echo "[INFO] Installing asdf tools ...";
        #install differents tools
        asdf install ruby 2.6.2
        asdf install ruby 2.5.1
        asdf install maven 3.6.0
        asdf install mongodb 3.4.15
        asdf install nodejs 8.14.0
        asdf install postgres 10.5
        asdf install elixir 1.7.3
CONFIG


#start Cloning data in folder
echo "[INFO] create the directory";
mkdir -p ~/code/new/cultureamp
git clone git@github.com:cultureamp/murmur.git ~/code/new/cultureamp/murmur

#run the mongoDB database
echo "run the mongoDb database"
    #asdf version
    asdf install
    mkdir -p ~/.asdf/installs/mongodb/3.4.15/data
    mongod --dbpath ~/.asdf/installs/mongodb/3.4.15/data &

#homebrew option
brew services start mongodb@3.4
if grep -Fq "export PATH="/usr/local/opt/mongodb@3.4/bin:$PATH"" ~/.zshrc; then
        echo "export PATH="/usr/local/opt/mongodb@3.4/bin:$PATH" Already added";
    else
        echo "Let's add it";
        echo 'export PATH="/usr/local/opt/mongodb@3.4/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc
    fi

#install dependencies for npm
echo "run npm install"
npm install

#postgrsql installation
echo "run postgres install"
POSTGRES_EXTRA_CONFIGURE_OPTIONS=--with-uuid=e2fs asdf install 
pg_ctl start

#starts the setup
cd ~/code/new/cultureamp/murmur
#install bundler v1.17.1
echo "install last bundler gem"
gem install bundler
echo "run bundle install"
bundle install
echo "run npm install"
npm intall
#install mailcatcher
echo "install mailcatcher gem"
gem install mailcatcher
echo "run the script murmur/bin/setup"
~/code/new/cultureamp/murmur/bin/setup.sh

#create the database etc
DISABLE_SPRING=true bin/rake db:reset
RAILS_ENV=development bin/event_framework event_store:db:create
RAILS_ENV=test bin/event_framework event_store:db:create