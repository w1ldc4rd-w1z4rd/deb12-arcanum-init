#!/bin/bash
#
#          _nnnn_
#         dGGGGMMb
#        @p~qp~~qMb
#        M|@||@) M|
#        @,----.JM|
#       JS^\__/  qKL
#      dZP        qKRb
#     dZP          qKKb
#    fZP            SMMb
#    HZM            MMMM
#    FqM            MMMM
#  __| ".        |\dS"qML
#  |    `.       | `' \Zq
# _)      \.___.,|     .'
# \____   )MMMMMP|   .'
#      `-'       `--' 
#
# Debian 12 Setup
# By: Wildcard Wizard (v2024-10-24)
#
# ~~~~~~~~~~~~~~~~ BEGIN

# Enable debugging output
set -x

# Exit on error
set -e

# ~~~~~~~~~~~~~~~~ SUDO

echo $USER | perl -nle 'print qq~${_} ALL=(ALL) NOPASSWD:ALL~' | sudo tee -a /etc/sudoers >/dev/null

# ~~~~~~~~~~~~~~~~ UPDATES

# Update package list
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y

# Upgrade packages
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Perform distribution upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# ~~~~~~~~~~~~~~~~ DEPENDANCIES

sudo apt install sudo -y
sudo apt install perl -y
sudo apt install libperl-dev -y

# ~~~~~~~~~~~~~~~~ LOCALE

# Install locales package
sudo apt-get install -y locales

# Ensure the en_US.UTF-8 locale is present in the locale.gen file
sudo sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen

# Generate locales
sudo locale-gen

# Configure locales non-interactively
sudo dpkg-reconfigure --frontend=noninteractive locales

# Set default locale
echo 'LANG="en_US.UTF-8"' | sudo tee /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' | sudo tee -a /etc/default/locale

# Update locale settings
sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Apply changes to current session
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Display current locale settings
echo "Current locale settings:"
locale

echo "Available locales:"
locale -a

echo "Configuration complete. It's recommended to reboot the system for changes to take full effect."

# ~~~~~~~~~~~~~~~~ INSTALLER

# Temporarily disable exit on error
set +e

perl -Mutf8 -M'open qw(:std :utf8 :encoding(UTF-8))' -MTerm::ANSIColor=':constants' -nE'

$|++;

sub ꕤ
{
    my $__ = {}; # color, message
    $$__{q║ʕ•ᴥ•ʔ║} = { COLOR => shift =~ s☰^$☰WHITE☰r, MSG => @_ // q║║ };
    my $output = sprintf q║print %s q`%s`, RESET;║, $$__{q║ʕ•ᴥ•ʔ║}{COLOR}, qq║@_║;
    eval $output;
}

sub ꖜ
{
	no warnings;
	my $__ = shift; # cmd
	print q║> ║;
	$__ =~ s☰.☰select(undef, undef, undef, rand(0.03)); ꕤ q║YELLOW║ => $&☰sger;
	say q║║;
	system $__;
	if ( $? != 0 )
	{
	    print q║> ║;
	    print BOLD UNDERLINE RED;
	    ꕤ qq║RED║ => qq║Fail: Command "$_" exited with status @{[$? >> 8]}\n║;
	    say RESET qq║║;
	    # sleep 1;
	    exit 69;
	}
	use warnings;
}

chomp;

s☰^(?!\#)(.*)$☰ꖜ($1)☰merg unless m~^$~;

END
{
	ꕤ q║GREEN BOLD║ => qq║All Done!\n║;
	ꕤ q║WHITE║ => qq║For mOAR visit: ║;
	ꕤ q║GREEN BOLD║ => qq║https://wildcard-wizards.sh\n║;
	ꕤ q║WHITE║ => qq║Run this to finish up:\n║;
	ꕤ q║WHITE║ => qq║source $HOME/.bashrc\n║;
}

' <<'END_OF_INPUT'
# ~~~~~~~~~~~~~~~~ DIRS

mkdir -p $HOME/temp
mkdir -p $HOME/git
mkdir -p $HOME/code
# Create necessary directories for backup, swap, and undo files
mkdir -p $HOME/.vim/tmp

# ~~~~~~~~~~~~~~~~ FIREWALL

# UFW Configuration
sudo apt install ufw -y
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
yes | sudo ufw enable
sudo ufw status verbose

# ~~~~~~~~~~~~~~~~ CONFIGS

# Append lines to .bashrc individually
echo "" | tee -a $HOME/.bashrc >/dev/null

# Set vi mode for command line editing
echo "# Set vi mode for command line editing" | tee -a $HOME/.bashrc >/dev/null
echo "set -o vi" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Export Environment Variables
echo "# Export Environment Variables" | tee -a $HOME/.bashrc >/dev/null
echo "# Set default editor as Vim" | tee -a $HOME/.bashrc >/dev/null
echo "export VISUAL=/usr/bin/vim" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Customize the command prompt
echo "# Customize the command prompt" | tee -a $HOME/.bashrc >/dev/null
echo "export PS1='\w> '" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Add custom path to PATH
echo "# Add custom path to PATH" | tee -a $HOME/.bashrc >/dev/null
echo "export PATH=\$HOME/code:\$PATH" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias Commands
echo "# Alias Commands" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias for clearing the screen
echo "# Alias for clearing the screen" | tee -a $HOME/.bashrc >/dev/null
echo "alias c='clear'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias for listing files in long format with human-readable sizes
echo "# Alias for listing files in long format with human-readable sizes" | tee -a $HOME/.bashrc >/dev/null
echo "alias l='clear && ls -lha'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias to edit and reload .bashrc
echo "# Alias to edit and reload .bashrc" | tee -a $HOME/.bashrc >/dev/null
echo "alias bed='vi \${HOME}/.bashrc && source \${HOME}/.bashrc && clear'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias to view command history
echo "# Alias to view command history" | tee -a $HOME/.bashrc >/dev/null
echo "alias h='history'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias to edit Apache config and restart Apache server
echo "# Alias to edit Apache config and restart Apache server" | tee -a $HOME/.bashrc >/dev/null
echo "alias web='sudo vi /etc/apache2/sites-available/web.conf && sudo service apache2 restart'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias to change directory to /var/www/
echo "# Alias to change directory to /var/www/" | tee -a $HOME/.bashrc >/dev/null
echo "alias www='cd /var/www/'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias for updating and upgrading the system
echo "# Alias for updating and upgrading the system" | tee -a $HOME/.bashrc >/dev/null
echo "alias up='sudo apt update -y && sudo apt upgrade -y'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias for setting up SSL with certbot and restarting Apache
echo "# Alias for setting up SSL with certbot and restarting Apache" | tee -a $HOME/.bashrc >/dev/null
echo "alias ssl='sudo certbot --apache && sudo service apache2 restart'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias to check SSH login attempts, remote logins, and active sessions in a single line
echo "# Alias to check SSH login attempts, remote logins, and active sessions in a single line" | tee -a $HOME/.bashrc >/dev/null
echo "alias w='clear && sudo fail2ban-client status sshd | grep -v Banned && printf \"*** REMOTE LOGINS ***\\n\" && lastlog | grep -v \"***Never\" && printf \"*** STILL LOGGED IN ***\\n\" && last | grep -i still'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Alias for copying files with rsync
echo "# Alias for copying files with rsync" | tee -a $HOME/.bashrc >/dev/null
echo "alias cpr='rsync --archive --verbose --update --progress'" | tee -a $HOME/.bashrc >/dev/null
echo "" | tee -a $HOME/.bashrc >/dev/null

# Adding useful defaults to .vimrc
echo "set number" | tee -a $HOME/.vimrc >/dev/null
echo "syntax on" | tee -a $HOME/.vimrc >/dev/null
echo "set showcmd" | tee -a $HOME/.vimrc >/dev/null
echo "set cursorline" | tee -a $HOME/.vimrc >/dev/null
echo "set wildmenu" | tee -a $HOME/.vimrc >/dev/null
echo "set expandtab" | tee -a $HOME/.vimrc >/dev/null
echo "set tabstop=4" | tee -a $HOME/.vimrc >/dev/null
echo "set shiftwidth=4" | tee -a $HOME/.vimrc >/dev/null
echo "set autoindent" | tee -a $HOME/.vimrc >/dev/null
echo "set smartindent" | tee -a $HOME/.vimrc >/dev/null
echo "set background=dark" | tee -a $HOME/.vimrc >/dev/null
echo "set incsearch" | tee -a $HOME/.vimrc >/dev/null
echo "set hlsearch" | tee -a $HOME/.vimrc >/dev/null
echo "set ignorecase" | tee -a $HOME/.vimrc >/dev/null
echo "set smartcase" | tee -a $HOME/.vimrc >/dev/null
echo "set clipboard=unnamedplus" | tee -a $HOME/.vimrc >/dev/null
echo "set splitright" | tee -a $HOME/.vimrc >/dev/null
echo "set splitbelow" | tee -a $HOME/.vimrc >/dev/null
echo "set mouse=a" | tee -a $HOME/.vimrc >/dev/null
echo "set backupdir=$HOME/.vim/tmp,." | tee -a $HOME/.vimrc >/dev/null
echo "set directory=$HOME/.vim/tmp,." | tee -a $HOME/.vimrc >/dev/null
echo "set undodir=$HOME/.vim/tmp,." | tee -a $HOME/.vimrc >/dev/null
echo "set undofile" | tee -a $HOME/.vimrc >/dev/null
echo "set hidden" | tee -a $HOME/.vimrc >/dev/null
echo "set ruler" | tee -a $HOME/.vimrc >/dev/null
echo "set relativenumber" | tee -a $HOME/.vimrc >/dev/null
echo "set laststatus=2" | tee -a $HOME/.vimrc >/dev/null
echo "set statusline=%f%m%r%h%w[%{&ff},%Y][%l/%L,%c][%p%%]" | tee -a $HOME/.vimrc >/dev/null
echo "filetype plugin on" | tee -a $HOME/.vimrc >/dev/null
echo "filetype indent on" | tee -a $HOME/.vimrc >/dev/null

# Debian Basics Installer
# Install essential packages and tools

# Install CA certificates for SSL/TLS
sudo apt install -y ca-certificates

# Install build-essential package (includes gcc, g++, and make)
sudo apt install -y build-essential

# Install make utility separately (although it is included in build-essential)
sudo apt install -y make

# Install neofetch, a system information tool
sudo apt install -y neofetch

# Install ufw (Uncomplicated Firewall) for managing firewall rules
sudo apt install -y ufw

# Install vim text editor
sudo apt install -y vim

# Install git version control system
sudo apt install -y git

# Install rsync for file synchronization and transfer
sudo apt install -y rsync

# Install curl, a tool for transferring data using various protocols
sudo apt install -y curl

# Install wget, a utility for retrieving files using HTTP, HTTPS, and FTP
sudo apt install -y wget

# Install ack-grep, a grep-like source code search tool
sudo apt install -y ack-grep

# Install gpm (General Purpose Mouse) for console mouse support
sudo apt install -y gpm

# Install pcregrep, a grep that understands Perl Compatible Regular Expressions
sudo apt install -y pcregrep

# Install lynx, a text-based web browser
sudo apt install -y lynx

# Install htop, an interactive process viewer
sudo apt install -y htop

# Install ssh client and server
sudo apt install -y ssh

# Install net-tools (includes ifconfig, netstat, route, etc.)
sudo apt install -y net-tools

# Install ifupdown for network interface management
sudo apt install -y ifupdown

# Install unzip utility for extracting zip archives
sudo apt install -y unzip

# Install screen, a terminal multiplexer
sudo apt install -y screen

# Install tmux, another terminal multiplexer
sudo apt install -y tmux

# Install thermald, the Linux thermal daemon (commented out)
# sudo apt install -y thermald

# Archive software
# Install xz-utils for XZ format compression and decompression
sudo apt install -y xz-utils

# Install tar for creating and extracting tar archives
sudo apt install -y tar

# Debian Extras Installer
# Install youtube-dl, a YouTube downloader (Deprecated)
# sudo apt install -y youtube-dl

# Install xdotool for simulating keyboard/mouse input
sudo apt install -y xdotool

# Install minimodem, a software audio FSK modem
sudo apt install -y minimodem

# Install zbar-tools for reading barcodes from various sources
sudo apt install -y zbar-tools

# Install qrencode for generating QR codes
sudo apt install -y qrencode

# Install sox, the Swiss Army knife of sound processing programs
sudo apt install -y sox

# Install ffmpeg for audio and video processing
sudo apt install -y ffmpeg

# Install ImageMagick for image manipulation
sudo apt install -y imagemagick

# Install zenity for creating GUI dialog boxes in shell scripts
sudo apt install -y zenity

# Install dialog for creating text-based user interfaces
sudo apt install -y dialog

# Install expect for automating interactive applications
sudo apt install -y expect

# Install yad (Yet Another Dialog) for creating GUI dialog boxes
sudo apt install -y yad

# Install mc (Midnight Commander), a text-based file manager
sudo apt install -y mc

# Install ranger, another text-based file manager
sudo apt install -y ranger

# Install genisoimage for creating ISO 9660 filesystem images
sudo apt install -y genisoimage

# Debian GUI software
# Install Kate, a text editor for KDE
sudo apt install -y kate

# Install psensor, a graphical hardware temperature monitor
sudo apt install -y psensor

# PCRE (Perl Compatible Regular Expressions)
# Install libpcre3, the PCRE library
sudo apt install -y libpcre3

# Install libpcre3-dev, development files for the PCRE library
sudo apt install -y libpcre3-dev

# Install Perl and related tools
sudo apt install -y cpanminus

sudo apt-get install zlib1g-dev -y

# Install Perl modules using cpanm (system-wide)
sudo cpanm Mojolicious
sudo cpanm IO::All
sudo apt-get install libssl-dev -y
sudo cpanm Net::SMTP::SSL
sudo cpanm Getopt::Long

# Remove unnecessary packages
sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove -y

# Clean up package cache
sudo DEBIAN_FRONTEND=noninteractive apt-get clean
END_OF_INPUT

# Disable debugging output
set +x

echo ""
# Check if a reboot is needed
if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required"
    # Uncomment the next line if you want to automatically reboot
    # sudo reboot
fi
