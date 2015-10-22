#! /bin/bash

tmp=/tmp/ubuntu_install_tmp
mkdir $tmp

# install java
# ============

javaloc=`which java`

if [ ! javaloc ]
then
	sudo apt-get -y install default-jre openjdk-7-jdk openjdk-7-jre-lib
	javaloc=`which java`
fi

while [ -L $javaloc ]
do
	javaloc=`readlink $javaloc`
done

export JAVA_HOME=$(dirname $(dirname $loc))
echo "JAVA_HOME=$JAVA_HOME" >> $HOME/.bashrc


# install and configure tmux
# ==========================
test `which tmux` && sudo apt-get -y install tmux
test -d $HOME/.tmux.conf && wget https://raw.githubusercontent.com/linxihui/Misc/master/some_useful_scripts/tmux.conf -O $HOME/.tmux.conf


# install vim, and plugins
# ========================

sudo apt-get -y install vim vim-gnome

mkdir -p $HOME/.vim/colors
wget -q https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -P $HOME/.vim/colors

wget -q https://raw.githubusercontent.com/linxihui/Misc/master/some_useful_scripts/vimrc_Eric.vim -O $HOME/.vimrc

# plugins: latexsuite, rainbow-parentheses, vim-r-plugin, tslime, csv, tabular, NERDTree
wget -q https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -O $HOME/.vim/autoload/pathogen.vim

wget -q http://iweb.dl.sourceforge.net/project/vim-latex/snapshots/vim-latex-1.8.23-20141116.812-gitd0f31c9.tar.gz -P $tmp && tar -xf $tmp/vim-latex* -C $tmp 
rm -rf $tmp/vim-latex*
cp -R $tmp/vim-latex*/* $HOME/.vim

mkdir -p $HOME/.vim/bundle
wget -q https://github.com/godlygeek/tabular/archive/master.zip -P $tmp && unzip -q $tmp/master.zip -d $tmp && rm -rf $tmp/master.zip
cp -R $tmp/tabular*/* $HOME/.vim/

wget -q https://github.com/kien/rainbow_parentheses.vim/archive/master.zip -P $tmp && unzip -q $tmp/master.zip -d $tmp && rm -rf $tmp/master.zip
cp -R $tmp/rainbow_parentheses.vim*/* $HOME/.vim/

wget -q https://github.com/vim-scripts/Vim-R-plugin/archive/master.zip -P $tmp && unzip -q $tmp/master.zip -d $tmp && rm -rf $tmp/master.zip
cp -R $tmp/Vim-R-plugin*/* $HOME/.vim/

wget -q https://github.com/scrooloose/nerdtree/archive/master.zip -P $tmp && unzip -q $tmp/master.zip -d $tmp && rm -rf $tmp/master.zip
cp -R $tmp/nerdtree*/* $HOME/.vim/

wget -q https://github.com/JuliaLang/julia-vim/archive/master.zip -P $tmp && unzip -q $mp/master.zip -d $tmp && rm -rf $tmp/master.zip
cp -R $tmp/julia-vim*/* $HOME/.vim/

wget -q https://raw.githubusercontent.com/jimmyharris/tslime.vim/master/plugin/tslime.vim -P $HOME/.vim/plugin

wget -q http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/21798/versions/5/download/zip -O $tmp/vim-matlab.zip
unzip -q $tmp/vim-matlab.zip -d $HOME/.vim/

rm -f $HOME/.vim/.gitignore $HOME/.vim/README*


# install newest version of R (the version on Ubuntu repository is outdated)
# ==========================================================================

ubuntuVersion=`b_release -a | tail -n 1 | cut -f2`
sudo echo -e "\ndeb http://cran.utstat.utoronto.ca/bin/linux/ubuntu $ubuntuVersion/\n" >> "/etc/apt/sources.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install r-base r-base-dev

# create a subshell to configure java for R, install R packages
(
sudo apt-get -y install libcurl4-gnutls-dev libxml2-dev libssl-dev
sudo R CMD javareconf

Rscript -e "
    install.packages(
        c('readr', 'openxlsx', 'data.table', 'plyr', 'dplyr', 'reshape2', 'ff', 
            'ffbase', 'tables', 'sqldf', 'jsonlite', 'stringr', 'ggplot2', 'lattice', 
            'latticeExtra', 'maps', 'ggvis', 'leaflet', 'devtools', 'futile.logger', 
            'testthat', 'getopt', 'pryr', 'inline', 'Rcpp', 'RcppArmadillo', 'RcppEigen', 
            'foreach', 'doMC', 'doMPI', 'xtable', 'rmarkdown', 'slidfy', 'XML', 'httr', 
            'shiny', 'pROC', 'glmnet', 'mboost', 'gbm', 'ada', 'randomForest', 'randomForestSRC', 
            'party', 'kernlab', 'kknn', 'neuralnet', 'deepnet', 'e1071', 'NMF', 'lle', 
            'autoencoder', 'irace', 'mlr', 'Hmisc', 'mice', 'mlbench', 'matrixStats', 'sp', 
            'gdata', 'xlsx', 'multcomp', 'coda', 'rjags', 'quantreg', 'gee', 'lme4', 'cmprsk')
        )"

)


# install ipython (jupiter), pip, numpy, scipy, pandas, patsy, Theano
# ===================================================================

sudo apt-get -y install ipython ipython-notebook ipython-notebook-common ipython-qtconsole

wget -q https://bootstrap.pypa.io/get-pip.py -P $tmp
sudo python $tmp/get-pip.py
(sudo pip install numpy scipy pandas pasty Theano ;)


# Other program languages and library
# ===================================

# install newest version of Julia
sudo apt-get -y install julia

# install octave
sudo apt-get -y install octave

# C++ libraries: Eigen3, Armandillo, boost, 
sudo apt-get -y install liblbfgs-dev


# install chinese support
# ========================

sudo apt-get -y intsall firefox-locale-zh-hant language-pack-gnome-zh-hant language-pack-zh-hant libreoffice-help-zh-tw libreoffice-l10n-zh-tw
sudo apt-get -y install fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy
sudo apt-get -y install ibus ibus-googlepinyin ibus-table-wubi


# install google-chrome
# =====================

sudo apt-get -y install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $tmp
sudo dpkg -i $tmp/google-chrome*.deb

sudo apt-get -y install guake


# Adobe reader: http://get.adobe.com/uk/reader/otherversions/
wget -q ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb -P $tmp
sudo dpkg -i --force-architecture $tmp/AdbeRdr9.5.5-1_i386linux_enu.deb
sudo apt-get -f install
sudo apt-get -y install libxml2:i386 lib32stdc++6

# RStudio
wget -q https://download1.rstudio.org/rstudio-0.99.486-amd64.deb -P $tmp
sudo dpkg -i $tmp/rstudio*

# skype
sudo dpkg --add-architecture i386
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt-get -y update && sudo apt-get -y install skype

# teamviewer
wget http://download.teamviewer.com/download/teamviewer_i386.deb -P $tmp
yes | sudo dpkg -i $tmp/teamviewer_i386.deb
sudo apt-get -f install

# Others
sudo apt-get -y install vlc pidgin okular kile

# long time to install texlive-full
# sudo apt-get -y install texlive-full
