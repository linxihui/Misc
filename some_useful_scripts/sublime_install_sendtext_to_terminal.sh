#! /bin/sh

# Eric Xihui Lin, Oct 08 2015
# Work on Linux only

sub=`ls $HOME/.config/ | grep sublime`
tmuxloc=`which tmux`

if [ ! -d $ubs ]
then
	echo "Sublime Text not installed."
fi

if [ -d $HOME/.config/$sub/SendText ]
then
	exit 0
fi

wget -q https://github.com/wch/SendText/archive/master.zip -P /tmp/_sublime_sendtext
unzip -q /tmp/_sublime_sendtext/master.zip -d /tmp/_sublime_sendtext

cp -R /tmp/_sublime_sendtext/SendText-master ~/.config/$sub/Packages/SendText
rm -rf /tmp/_sublime_sendtext

if [ ! $tmuxloc ]
then
	sudo apt-get -y install tmux
fi

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
