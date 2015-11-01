#! /bin/sh

# Eric Xihui Lin, Oct 08 2015
# Work on Linux only

# get sublime version and tmux location
sub=`ls $HOME/.config/ | grep sublime`
tmuxloc=`which tmux`

# check if sublime installed
if [ ! $sub ]
then
	sub_opt=`ls /opt/ | grep -i sublime`
	if [ $sub_opt ]
	then 
		if [ $sub_opt =~ "2$"] 
		then
			mkdir -p "$HOME/.config/sublime-text-2"
		else
			mkdir -p "$HOME/.config/sublime-text-3"
		fi
	else
		echo "Sublime not found."
	fi
fi

sub=`ls $HOME/.config/ | grep sublime`

mkdir -p $HOME/.config/$sub/Packages

# install tmux if not exists
if [ ! $tmuxloc ]
then
	sudo apt-get -y install tmux
	tmuxloc=`which tmux`
fi

# config tmux
if [ ! -f $HOME/.tmux.conf ]
then
	wget -q https://raw.githubusercontent.com/linxihui/Misc/master/some_useful_scripts/tmux.conf -O $HOME/.tmux.conf
fi

# check if plugin 'SendText' has been installed
if [ -d $HOME/.config/$sub/Packages/SendText ]
then
	echo "SendText plugin has been installed already. Exit."
	exit 0
fi

# get SendText, unzip, move to sublime package location, and clean downloads
wget -q https://github.com/wch/SendText/archive/master.zip -P /tmp/_sublime_sendtext
unzip -q /tmp/_sublime_sendtext/master.zip -d /tmp/_sublime_sendtext
cp -R /tmp/_sublime_sendtext/SendText-master ~/.config/$sub/Packages/SendText
rm -rf /tmp/_sublime_sendtext

# config SendText: use tmux
echo "{
    // Uncomment the program you want send text to:
    // \"program\": \"Terminal.app\",
    // \"program\": \"iTerm\",
    \"program\": \"tmux\",
    // \"program\": \"screen\",
    \"paths\":
    {
        // It might be necessary to explicitly set path (usually /usr/bin
        // or /usr/local/bin) to tmux and screen. Uncomment below and specify
        // the correct path:
        \"tmux\": \"$tmuxloc\"
        // \"screen\": \"/usr/local/bin/screen\"
    }
}" > $HOME/.config/$sub/Packages/SendText/SendText.sublime-settings
